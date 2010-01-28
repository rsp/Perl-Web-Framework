package WebFramework::Controller::CookiesOut;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';

use CGI::Cookie ();
use WebFramework::Utils::Hash ();

sub _after {
    my ($response) = @_;

    my $cookies = defined($response->{cookies}) ?
                      $response->{cookies} :
                      defined($response->{cookie}) ?
                          [$response->{cookie}] :
                          undef;
    if (defined($cookies)) {
        $response->{headers} ||= {};
        my $values = defined($response->{headers}->{'Set-Cookie'}) ?
                         ((ref($response->{headers}->{'Set-Cookie'}) eq 'ARRAY') ?
                             $response->{headers}->{'Set-Cookie'} :
                             [$response->{headers}->{'Set-Cookie'}]) :
                         [];
        foreach my $cookie (@{$cookies}) {
            # let CGI::Cookie take care of escaping and formatting
            # the Set-Cookie header value correctly.
            my $cgi_cookie = CGI::Cookie->new();
            if ($cookie->{name}) {
                $cgi_cookie->name($cookie->{name});
            }
            if ($cookie->{value}) {
                $cgi_cookie->value($cookie->{value});
            }
            if ($cookie->{domain}) {
                $cgi_cookie->domain($cookie->{domain});
            }
            if ($cookie->{path}) {
                $cgi_cookie->path($cookie->{path});
            }
            if ($cookie->{expires}) {
                $cgi_cookie->expires($cookie->{expires});
            }
            if ($cookie->{max_age}) {
                $cgi_cookie->max_age($cookie->{max_age});
            }
            if ($cookie->{httponly}) {
                $cgi_cookie->httponly($cookie->{http_only});
            }
            push(@{$values}, $cgi_cookie->as_string());
        }
        $response->{headers}->{'Set-Cookie'} = $values;
    }
    return $response;
}

sub _around {
    my ($request, $inner_controller) = @_;

    return _after($inner_controller->($request));
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

WebFramework::Controller::CookiesOut - Perl extension for


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
