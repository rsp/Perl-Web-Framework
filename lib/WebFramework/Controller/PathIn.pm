package WebFramework::Controller::PathIn;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';

use WebFramework::Utils::Hash ();
use WebFramework::Utils::Request ();

sub _before {
    my ($request) = @_;

    if ($ENV{PATH_INFO}) {
        $request->{path} = $ENV{PATH_INFO};
    }
    return $request;
}

sub _around {
    my ($request, $inner_controller) = @_;

    return $inner_controller->(_before($request));
}

sub wrapper {
    my ($inner_controller) = @_;

    return sub {
        my ($request) = @_;
        return _around($request, $inner_controller);
    };
}

1;
__END__


=head1 NAME

WebFramework::Controller::PathIn - Perl extension for


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
