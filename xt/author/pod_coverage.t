package main;

use strict;
use warnings;

my $ok;
BEGIN {
    eval {
	require Test::More;
	Test::More->import();
	1;
    } or do {
	print "1..0 # skip Test::More required to test pod coverage.\n";
	exit;
    };
    'MSWin32' eq $^O or do {	# Dummy up enough to make module compile.
	no warnings qw{once};
	$INC{'Win32/API.pm'} = 'dummy';		## no critic (RequireLocalizedPunctuationVars)
	$INC{'Win32API/File.pm'} = 'dummy';	## no critic (RequireLocalizedPunctuationVars)
	*Win32API::File::Time::FILE_ATTRIBUTE_NORMAL = sub {};
	*Win32API::File::Time::FILE_FLAG_BACKUP_SEMANTICS = sub {};
	*Win32API::File::Time::FILE_SHARE_READ = sub {};
	*Win32API::File::Time::FILE_SHARE_WRITE = sub {};
	*Win32API::File::Time::FILE_READ_ATTRIBUTES = sub {};
	*Win32API::File::Time::FILE_WRITE_ATTRIBUTES = sub {};
	*Win32API::File::Time::OPEN_EXISTING = sub {};
    };
    eval {
	require Test::Pod::Coverage;
	Test::Pod::Coverage->VERSION( 1.00 );
	Test::Pod::Coverage->import();
	1;
    } or do {
	print <<eod;
1..0 # skip Test::Pod::Coverage 1.00 or greater required.
eod
	exit;
    };
}

all_pod_coverage_ok ({coverage_class => 'Pod::Coverage::CountParents'});

1;
