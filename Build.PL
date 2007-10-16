use strict;
use warnings;

use Module::Build;
use Config;
use FileHandle;

our $VERSION = '0.001';

my $bldr = Module::Build->new (
	dist_author => 'Tom Wyant (wyant at cpan dot org)',
	dist_abstract => 'Get and set file times in Windows - including open files',
	module_name => 'Win32API::File::Time',
	requires => {
	    'Win32::API' => 0.01,
	    'Win32API::File' => 0.08,
	},
##	dynamic_config => 1,
	license => 'perl',
	);

$bldr->create_build_script ();

