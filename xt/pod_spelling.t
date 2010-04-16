use strict;
use warnings;

my $skip;
BEGIN {
    eval "use Test::Spelling";
    $@ and do {
	print "1..0 # skip Test::Spelling not available.\n";
	exit;
    };
}

our $VERSION = '0.000_01';

add_stopwords (<DATA>);

all_pod_files_spelling_ok ();
__DATA__
Aldo
Calpini
GetFileTime
Jenda
Krynicky
MSWin
McQueen
Nemours
PPM
SetFileTime
Tye
Wyant
cc
de
dll
exportable
readonly
stat
tuits
