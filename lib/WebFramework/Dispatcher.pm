package WebFramework::Dispatcher;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(dispatcher);

our $VERSION = '0.01';

use WebFramework::Controller::CGI ();


sub dispatcher {
    my ($routes) = @_;

    return WebFramework::Controller::CGI::wrapper(sub {
        my ($request) = @_;

        my ($path) = split(qr{\?}, $ENV{REQUEST_URI});

        for my $route (@{$routes}) {
            if ((defined($route->{path})   ? $path =~ $route->{path}                : 1) &&
                (defined($route->{method}) ? uc($ENV{REQUEST_METHOD}) =~ $route->{method}     : 1)) {
                return $route->{controller}->($request); # pass original request on to delegate controller
            }
        }
    });
}


1;
__END__


=head1 NAME

WebFramework::Dispatcher - Create a dispatch controller that delegates to other controllers to generate HTTP response.


=head1 VERSION


=head1 SYNOPSIS

Your application will likely have one use of a dispatcher to define the Your::App::main subroutine.

    use WebFramework::Dispatcher qw(dispatcher);
    use Your::App::Controller qw();

    our $main = dispatcher([

        {'method'     => qr{GET},
         'path'       => qr{^/login$},
         'controller' => $Your::App::Controller::login_form},

        {'method'     => qr{POST},
         'path'       => qr{^/login$},
         'controller' => $Your::App::Controller::create_session},

        {'controller' => $Your::App::Controller::catch_all},    
    ]);


=head1 DESCRIPTION

A dispatcher is a controller subroutine that examines the incomming HTTP request and compares the request with a list of routes. The controller specified in the first matching route is sent the request and is delegated the responsibility of generating the HTTP response. That controller's response is the response passed back by the dispatcher subroutine.

A dispatcher does not modify the incomming HTTP request or modify the outgoing response object from the delgate controller.


=head1 SUBROUTINES/METHODS

=head2 dispatcher($routes)

The dispatcher subroutine takes an array reference as its C<$routes> argument. The array contains hash references: each hash reference is a "route". Each route must have a C<controller> key with a value of another controller capable of generating a response. Each route can optionally have C<method> and C<path> keys with regular expression values to be matched against the incomming HTTP request. The routes are tested in sequence and first matching route is used to generate the HTTP response.


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
