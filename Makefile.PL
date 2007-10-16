use Config;
use ExtUtils::MakeMaker;

## my $vers = sprintf '-%.3f', $];
## $vers =~ s/\.0+/./;
## $] < 5.008 and $vers = '';

WriteMakefile (
	NAME => 'Win32API::File::Time',
	VERSION_FROM => 'lib/Win32API/File/Time.pm',
	PREREQ_PM => {
			'Win32::API' => 0.01,
			'Win32API::File' => 0.08,
			},
#	'linkext' => {LINKTYPE => ''},
	PL_FILES => {},	# Prevent old MakeMaker from running Build.PL
	'dist' => {COMPRESS => 'gzip', SUFFIX => 'gz'},
	$] >= 5.005 ? (
		AUTHOR => 'Tom Wyant (Thomas.R.Wyant-III@usa.dupont.com)',
		ABSTRACT => 'Get and set file times in Windows - including open files',
		(ExtUtils::MakeMaker->VERSION >= 6.31 ?
		    (LICENSE => 'perl') : ())
##		BINARY_LOCATION => "$Config{archname}$vers/Win32API-File-Time.tar.gz",
		) : (),
	);

