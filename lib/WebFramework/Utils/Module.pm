package WebFramework::Utils::Module;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw();

our $VERSION = '0.01';

sub remove_last {
    my ($controller) = @_;

    my @bits = split('::', $controller);
    pop(@bits);
    return join('::', @bits);
}

1;
__END__


=head1 NAME

WebFramework::Utils::Module - Perl extension for


=head1 VERSION


=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 SUBROUTINES/METHODS


=head1 DIAGNOSTICS


=head1 CONFIGURATION AND ENVIRONMENT


=head1 DEPENDENCIES


=head1 INCOMPATIBILITIES


=head1 BUGS AND LIMITATIONS


=head1 AUTHOR

Peter Michaux, E<lt>petermichaux@gmail.comE<gt>


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2009 by Peter Michaux

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.
