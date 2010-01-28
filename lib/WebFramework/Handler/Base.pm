package WebFramework::Handler::Base;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(handle);

our $VERSION = '0.01';

use Carp ();

# by the time the request gets here it should be the same regardless of the server
# being CGI, FastCGI, or some other technology. That is what the WebFramework::Handler
# namespace is for: unifying the incoming data that the Web Application sees.
# The common incoming data that the Web Application sees is more or less like 
# what a CGI application sees: in, out, err, env, and the addition of the controller being called.
sub handle {
    my ($request) = @_;

    my $controller = eval('$'.$request->{controller}); ## no critic (ProhibitStringyEval)
    if ($@) {
        Carp::croak($@);
    }

    return $controller->($request);
}

1;
__END__


=head1 NAME

WebFramework::Handler::Base - Perl extension for


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
