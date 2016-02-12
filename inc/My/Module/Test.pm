package My::Module::Test;

use 5.006002;

use strict;
use warnings;

use Carp;

our $VERSION = '0.007_03';

BEGIN {

    my %is_windows = map { $_ => 1 } qw{ cygwin MSWin32 };

    sub is_windows { return $is_windows{$^O}; }

    unless ( is_windows() ) {

	require lib;
	lib->import( 'inc/mock' );

    }

}

1;

__END__

=head1 NAME

My::Module::Test - Test C<Win32API::File::Time>.

=head1 SYNOPSIS

 use lib qw{ inc };
 use My::Module::Test;

=head1 DESCRIPTION

This module is private to the C<Win32API-File-Time> distribution. It can
be changed or retracted without notice.

This module provides testing functionality for C<Win32API::File::Time>.
This includes making mock Windows code available under non-Windows
systems.

=head1 METHODS

This class supports the following public methods:

=head1 ATTRIBUTES

This class has the following attributes:


=head1 SEE ALSO

<<< replace or remove boilerplate >>>

=head1 SUPPORT

Support is by the author. Please file bug reports at
L<http://rt.cpan.org>, or in electronic mail to the author.

=head1 AUTHOR

Tom Wyant (wyant at cpan dot org)

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2016 by Thomas R. Wyant, III

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl 5.10.0. For more details, see the full text
of the licenses in the directory LICENSES.

This program is distributed in the hope that it will be useful, but
without any warranty; without even the implied warranty of
merchantability or fitness for a particular purpose.

=cut

# ex: set textwidth=72 :
