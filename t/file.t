package main;

use strict;
use warnings;

# local $^W = 0;

use File::Temp;
use Test::More 0.88;	# for done_testing.

use lib qw{ inc };

use My::Module::Test;
use Win32API::File::Time qw{ :all };	# Must be loaded after My::Module::Test

my $reactos = 'MSWin32' eq $^O && $ENV{OS} =~ m/ reactos /smxi;

my $support_wide_system_calls =
    Win32API::File::Time->SUPPORT_WIDE_SYSTEM_CALLS();

note join ' ', 'Wide system calls are',
    $support_wide_system_calls ? 'supported' : 'not supported';

foreach my $wide_system_calls ( 0 .. $support_wide_system_calls ) {

    $support_wide_system_calls
	and local ${^WIDE_SYSTEM_CALLS} = $wide_system_calls;

    $support_wide_system_calls
	and note "Test with \${^WIDE_SYSTEM_CALLS} set to $wide_system_calls";

    my $me = $0;
    my ( undef, undef, undef, undef, undef, undef, undef, undef,
	$patim, $pmtim, $pctim, undef, undef ) = stat $me
	or BAIL_OUT "Failed to stat $me: $!";
    note spftime( "$me via stat()", $patim, $pmtim, $pctim );

    my ( $atime, $mtime, $ctime ) = GetFileTime( $me );
    note spftime( "$me via GetFileTime()", $atime, $mtime, $ctime );

    cmp_ok $mtime, '==', $pmtim, 'Got same modification time as stat()'
	or diag <<"EOD";
    GetFileTime: @{[ scalar localtime $mtime ]}
	   stat: @{[ scalar localtime $pmtim ]}
EOD

    if ( $reactos ) {
	note 'Creation time not checked under ReactOS';
    } elsif ( ! $pctim ) {
	note 'Creation time not checked because stat() returned 0';
    } else {
	cmp_ok $ctime, '==', $pctim, 'Got same creation time as stat()'
	    or diag <<"EOD";
    GetFileTime: @{[ scalar localtime $mtime ]}
	   stat: @{[ scalar localtime $pmtim ]}
EOD
    }

    my $temp = File::Temp->new();
    my $temp_name = $temp->filename();
    my $now = time;
    $now -= $now % 2;	# FAT's time resolution is 2 seconds.
    CORE::utime $now, $now, $temp_name
	or BAIL_OUT "utime() on $temp_name failed: $!";

    ( undef, undef, undef, undef, undef, undef, undef, undef,
	$patim, $pmtim, $pctim ) = stat $temp_name;
    note spftime( "$temp_name before SetFileTime()", $patim, $pmtim, $pctim );

    my $want = $now + 10;
    SetFileTime( $temp_name, $want, $want );
    ( undef, undef, undef, undef, undef, undef, undef, undef,
	$patim, $pmtim, $pctim ) = stat $temp_name;
    note spftime( "$temp_name after SetFileTime()", $patim, $pmtim, $pctim );

    cmp_ok $want, '==', $pmtim, 'Set modification time with SetFileTime()'
	or diag <<"EOD";
    SetFileTime: @{[ scalar localtime $want ]}
	   stat: @{[ scalar localtime $pmtim ]}
EOD

    $want += 10;
    utime( $want, $want, $temp_name );
    ( undef, undef, undef, undef, undef, undef, undef, undef,
	$patim, $pmtim, $pctim ) = stat $temp_name;
    note spftime( "$temp_name after utime()", $patim, $pmtim, $pctim );

    cmp_ok $want, '==', $pmtim, 'Set modification time with utime()'
	or diag <<"EOD";
    utime: @{[ scalar localtime $want ]}
     stat: @{[ scalar localtime $pmtim ]}
EOD
}

done_testing;

sub spftime {
    my ( $fn, $sat, $smt, $sct ) = @_;
    ( $sat, $smt, $sct ) = map { scalar localtime $_ } $sat, $smt, $sct;
    return <<"EOD";
$fn;
Accessed: $sat
Modified: $smt
 Created: $sct
EOD
}

1;

# ex: set textwidth=72 :
