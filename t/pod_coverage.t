use strict;
use warnings;

my $ok;
BEGIN {
    eval "use Test::More";
    if ($@) {
	print "1..0 # skip Test::More required to test pod coverage.\n";
	exit;
    }
    unless ($^O eq 'MSWin32') {	# Dummy up enough to make module compile.
	no warnings qw{once};
	$INC{'Win32/API.pm'} = 'dummy';
	$INC{'Win32API/File.pm'} = 'dummy';
	*Win32API::File::Time::FILE_ATTRIBUTE_NORMAL = sub {};
	*Win32API::File::Time::FILE_FLAG_BACKUP_SEMANTICS = sub {};
	*Win32API::File::Time::FILE_SHARE_READ = sub {};
	*Win32API::File::Time::FILE_SHARE_WRITE = sub {};
	*Win32API::File::Time::FILE_READ_ATTRIBUTES = sub {};
	*Win32API::File::Time::FILE_WRITE_ATTRIBUTES = sub {};
	*Win32API::File::Time::OPEN_EXISTING = sub {};
    }
    eval "use Test::Pod::Coverage 1.00";
    if ($@) {
	print <<eod;
1..0 # skip Test::Pod::Coverage 1.00 or greater required.
eod
	exit;
    }
}

all_pod_coverage_ok ({coverage_class => 'Pod::Coverage::CountParents'});
