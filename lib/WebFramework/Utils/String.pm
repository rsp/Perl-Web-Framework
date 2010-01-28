package WebFramework::Utils::String;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw();

our $VERSION = '0.01';

sub starts_with {
    my ($subject, $prefix) = @_;

    return substr($subject, 0, 1) eq $prefix;
}

sub ends_with {
    my ($subject, $suffix) = @_;

    return substr($subject, (length($subject) - 1)) eq $suffix;
}

sub guarantee_header_case {
    my ($header_name) = @_;

    return join('-', map {ucfirst(lc($_));} split('-', $header_name));
}


1;
__END__


=head1 NAME

WebFramework::Utils::String - Perl extension for


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
