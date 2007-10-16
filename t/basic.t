local $^W = 0;

use strict;
use warnings;

use File::Basename;
use File::Spec;
use FileHandle;
use POSIX qw{strftime};
use Test;

my $test_num = 1;
my $loaded;
BEGIN {
    if ($ENV{DEVELOPER_TEST} && !eval {
	    require Win32::API;
	    require Win32API::File;
	    1;
	}) {
	print "1..0 # skip Win32::API and Win32API::File not available.\n";
	exit;
    }
    $| = 1; plan (tests => 4);
    print "# Test 1 - Loading the library.\n"}
END {print "not ok 1\n" unless $loaded;}
use Win32API::File::Time qw{GetFileTime SetFileTime utime};
$loaded = 1;
ok ($loaded);

my $me = File::Spec->rel2abs ($0);
my $df = '%d-%b-%Y %H:%M:%S';

print "# This file is $me\n";
my ($patim, $pmtim, $pctim);
(undef, undef, undef, undef, undef, undef, undef, undef,
    $patim, $pmtim, $pctim, undef, undef) = stat ($me);
defined $patim ? pftime ($patim, $pmtim, $pctim) : print <<eod;
# Error - stat $me
#         $!
#         $^E
eod
print "#\n";

$test_num++;
my $rslt;
print "# Test $test_num - Get file times.\n";
my ($atime, $mtime, $ctime) = GetFileTime ($me);
print <<eod;
#           Win32API::File::Time  stat
# Accessed: @{[strftime $df, localtime $atime]}  @{[
	strftime $df, localtime $patim]}
#  Created: @{[strftime $df, localtime $ctime]}  @{[
	strftime $df, localtime $pctim]}
eod
$pctim or print <<eod;
# stat() returned 0 for creation time. Creation time will not be
# included in the test.
eod
# stat() returns 0 under wine, at least in ActivePerl.
$rslt = $mtime == $pmtim && (!$pctim || $ctime == $pctim);
ok ($rslt);
$rslt ? pftime ($atime, $mtime, $ctime) : print <<eod;
# GetFileTime failed.
# $^E
eod

my $testfile = File::Spec->catfile ($ENV{TEMP} || $ENV{TMP}, 'Win32API-File-Time.tmp');
my $skip = FileHandle->new (">$testfile") ? '' : "Unable to create $testfile";

$test_num++;
print <<eod;
# Test $test_num - Set the access and modification with SetFileTime.
#     File $testfile
eod
my $now = time () - 10;
$now = $now - $now % 2;	# FAT only only stores to nearest two seconds.
($patim, $pmtim, $pctim) = (undef, undef, undef);
$skip or $rslt = SetFileTime ($testfile, $now, $now) and do {
    (undef, undef, undef, undef, undef, undef, undef, undef,
	$patim, $pmtim, $pctim, undef, undef) = stat ($testfile);
    $rslt = $pmtim == $now;	# Don't test atime, because of resolution.
    };
$skip or print <<eod;
# desired mod time: $now = @{[strftime $df, localtime $now]}.
#  actual mod time: @{[defined $pmtim ? "$pmtim = @{[strftime $df, localtime $pmtim]}" : 'undef']}
eod
skip ($skip, $rslt);
$skip or $rslt or print <<eod;
# SetFileTime failed.
# $^E
eod

$test_num++;
print "# Test $test_num - Set the access and modification with utime.\n";
$now += 10;
($patim, $pmtim, $pctim) = (undef, undef, undef);
$skip or $rslt = utime $now, $now, $testfile and do {
    (undef, undef, undef, undef, undef, undef, undef, undef,
	$patim, $pmtim, $pctim, undef, undef) = stat ($testfile);
    $rslt = $pmtim == $now;	# Don't test atime, because of resolution.
    };
$skip or print <<eod;
# desired mod time: $now = @{[strftime $df, localtime $now]}.
#  actual mod time: @{[defined $pmtim ? "$pmtim = @{[strftime $df, localtime $pmtim]}" : 'undef']}
eod
skip ($skip, $rslt);
$skip or $rslt or print <<eod;
# utime failed.
# $^E
eod

$skip or unlink $testfile;

sub pftime {
my ($sat, $smt, $sct) = map {strftime $df, localtime $_} @_;
print <<eod;
# Accessed: $sat
# Modified: $smt
#  Created: $sct
eod
}
sub sftime {
map {strftime $df, localtime $_} @_
}

