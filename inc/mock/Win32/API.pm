package Win32::API;

use 5.006002;

use strict;
use warnings;

use Carp;
use Time::Local ();

our $VERSION = '0.007_03';

sub new {
    my ( $class, $lib, $sub ) = @_;
    my $mock = join '__', '_mock', $lib, $sub;
    my $code = $class->can( $mock )
	or croak "No mock code available for $lib $sub";
    return bless $code, ref $class || $class;
}

# Note that in pretty much ALL the following, the Microsoft calling
# convention requires that arguments be modified, and that those
# modifications be visible to the caller. For this reason we must not
# unpack the argument list, at least not completely.
sub Call {
    my $self = shift;
    return $self->( @_ );
}

sub _mock__KERNEL32__FileTimeToSystemTime {	## no critic (RequireArgUnpacking)
    my ( undef, $ft ) = unpack 'LL', $_[0];
    my @local = localtime $ft;
    @local = reverse @local[0..5];
    $local[0] += 1900;
    $local[1] += 1;
    splice @local, 2, 0, 0;
    push @local, 0;
    @_[1] = pack 'ssssssss', @local;
    return 1;
}

sub _mock__KERNEL32__GetFileTime {	## no critic (RequireArgUnpacking)
    my ( $fh ) = @_;
    my ( undef, undef, undef, undef, undef, undef, undef, undef, $atime,
	$mtime, $ctime ) = stat $fh
	or return;
    $_[1] = pack 'LL', 0, $ctime;
    $_[2] = pack 'LL', 0, $atime;
    $_[3] = pack 'LL', 0, $mtime;
    return 1;
}

sub _mock__KERNEL32__FileTimeToLocalFileTime {
    $_[1] = $_[0];
    return 1;
}

sub _mock__KERNEL32__LocalFileTimeToFileTime {
    $_[1] = $_[0];
    return 1;
}

sub _mock__KERNEL32__SetFileTime {
    my ( $fh, $atime, $mtime ) = @_;
    ( undef, $atime ) = unpack 'LL', $atime;
    ( undef, $mtime ) = unpack 'LL', $mtime;
    return utime $atime, $mtime, $fh;
}

sub _mock__KERNEL32__SystemTimeToFileTime {	## no critic (RequireArgUnpacking)
    my @localtime = unpack 'sssssss', $_[0];
    splice @localtime, 2, 1;
    $localtime[0] -= 1900;
    $localtime[1] -= 1;
    my $local = Time::Local::timelocal( reverse @localtime );
    $_[1] = pack 'LL', 0, $local;
    return 1;
}

1;

__END__

=head1 NAME

mock::Win32::API - <<< replace boilerplate >>>

=head1 SYNOPSIS

<<< replace boilerplate >>>

=head1 DESCRIPTION

<<< replace boilerplate >>>

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
