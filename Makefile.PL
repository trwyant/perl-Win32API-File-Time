use 5.006002;

use strict;
use warnings;

use Config;
use ExtUtils::MakeMaker;

(my $mmv = ExtUtils::MakeMaker->VERSION) =~ s/_//g;

my %args = (
    NAME => 'Win32API::File::Time',
    VERSION_FROM => 'lib/Win32API/File/Time.pm',
    PREREQ_PM => {
	'Win32::API' => 0.01,
	'Win32API::File' => 0.08,
    },
    PL_FILES => {},	# Prevent old MakeMaker from running Build.PL
    'dist' => {COMPRESS => 'gzip', SUFFIX => 'gz'},
    AUTHOR => 'Tom Wyant (Thomas.R.Wyant-III@usa.dupont.com)',
    ABSTRACT => 'Get and set file times in Windows - including open files',
);

$mmv >= 6.31 and $args{LICENSE} = 'perl';

$mmv >= 6.4501 and $args{META_MERGE} = {
    resources => {
	bugtracker => 'https://rt.cpan.org/Public/Dist/Display.html?Name=Win32API-File-Time',
	license => 'http://dev.perl.org/licenses/',
    },
};

WriteMakefile(%args);
