use strict;
use warnings;

use Module::Build;
use Config;
use FileHandle;

our $VERSION = '0.001_01';

(my $mbv = Module::Build->VERSION) =~ s/_//g;

my %args = (
    dist_author => 'Tom Wyant (wyant at cpan dot org)',
    dist_abstract => 'Get and set file times in Windows - including open files',
    module_name => 'Win32API::File::Time',
    requires => {
	'Win32::API' => 0.01,
	'Win32API::File' => 0.08,
    },
    license => 'perl',
);

$mbv >= 0.28 and $args{meta_merge} = {
    no_index => {
	directory => [qw{inc t}],
    },
    resources => {
	bugtracker => 'https://rt.cpan.org/Public/Dist/Display.html?Name=Win32API-File-Time',
    },
};

$mbv >= 0.34
    and $args{auto_configure_requires} = 0;	# Don't require Module::Build

my $bldr = Module::Build->new(%args);

$bldr->create_build_script ();
