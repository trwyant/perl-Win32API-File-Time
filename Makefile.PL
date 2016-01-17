use 5.006002;

use strict;
use warnings;

use Config;
use ExtUtils::MakeMaker;

$ENV{AUTHOR_BUILD}
    or 'MSWin32' eq $^O
    or 'cygwin' eq $^O
    or die "OS unsupported\n";

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

if ( $mmv >= 6.4501 ) {
    $args{META_ADD} = {
	no_index => {
	    directory => [ qw{ inc t xt } ],
	},
    };
    $args{META_MERGE} = {
	resources => {
	    bugtracker => 'https://rt.cpan.org/Public/Dist/Display.html?Name=Win32API-File-Time',
	    license => 'http://dev.perl.org/licenses/',
	},
    };
}

$mmv >= 6.4701
    and $args{MIN_PERL_VERSION} = 5.006002;

my %build_requires = (
    'Test::More'	=> 0.88,
);

if ( $mmv >= 6.5501 ) {
    $args{BUILD_REQUIRES} = \%build_requires;
} elsif ( $mmv >= 6.4501 ) {
    $args{META_MERGE}{build_requires} = \%build_requires;
} else {
    @{ $args{PREREQ_PM} }{ keys %build_requires } = values %build_requires;
}

WriteMakefile(%args);
