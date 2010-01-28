package WebFramework::Controller::JSONIn;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';

use JSON ();


sub _around {
    my ($request, $inner_controller) = @_;

    if (defined($ENV{CONTENT_TYPE}) && ($ENV{CONTENT_TYPE} =~ qr|^application/json|)) {
        if (defined($ENV{CONTENT_LENGTH})) {
            if ($ENV{CONTENT_LENGTH} =~ qr{^[123456789]\d*$}) {
                if (defined($ENV{JSON_BODY_MAX_LENGTH}) && ($ENV{CONTENT_LENGTH} <= $ENV{JSON_BODY_MAX_LENGTH} )) {
                    my $body_string = '';
                    read(\*STDIN, $body_string, $ENV{CONTENT_LENGTH});
                    $request->{json} = JSON::from_json($body_string);
                }
                else {
                    return {
                        'status' => '413 Request Entity Too Large',
                    };
                }
            }
            else {
                # tell the client about malformed syntax
                return {
                    'status' => '400 Bad Request',
                };
            }
        }
        else {
            # tell the client to send a Content-Length header
            return {
                'status' => '411 Length Required',
            };
        }
    }

    return $inner_controller->($request);
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

WebFramework::Controller::JSONIn - Parses JSON requests and makes the request body available through the C<$request-E<gt>{json}> hash or array reference.


=head1 VERSION


=head1 SYNOPSIS

The most likely use of the JSONIn wrapper is through its inclusion in the C<WebFramework::Controller::controller> subroutine.

  use WebFramework::Controller qw(controller);
  
  our $json_controller = controller(sub {
      my ($request) = @_;
    
      if (defined($request->{json})) {
          return {
              body => 'You sent a JSON request. The "alpha" value was ' .
                      $request->{json}->{alpha},
          };
      }
      else {
          return {
              body => 'I like JSON better.',
          };
      }    
  });


=head1 DESCRIPTION

HTTP requests with a C<Content-Type> header starting with C<application/json> are JSON requests. These bodies of these JSON requests are parsed to Perl data structures. The resulting data structure is available though the the C<$request-E<gt>{json} hash or array reference.

If the environment variable C<JSON_BODY_MAX_LENGTH> is set (must be an integer) and the request's C<Content-Length> header indicates the request body is too large then a C<413 Request Entity Too Large> reponse is sent. It is strongly recommended that this environment variable be set. (It is specified in the default WebFramework environment file and so the environment variable will be set if the Env wrapper is used around the JSONIn wrapper. If you are using the C<WebFramework::Controller::controller> wrapper then all of this is done for you.)

If the C<Content-Length> header is not an integer then a C<400 Bad Request> response is sent.

If the C<Content-Length> header is not present then a C<411 Length Required> response is sent.


=head1 SUBROUTINES/METHODS

=head2 wrapper($inner_controller)

A subroutine for wrapping an inner controller. Returns the wrapped controller.


=head1 DIAGNOSTICS


=head1 CONFIGURATION AND ENVIRONMENT

See the description section regarding the C<JSON_BODY_MAX_LENGTH> environment variable.


=head1 DEPENDENCIES

This wrapper must be used inside a C<WebFramework::StandardOut::wrapper> as the outgoing response hash for error responses from this JSONIn  wrapper is of the type that C<WebFramework::StandardOut::wrapper> expects as its incoming response hash.

You should use this wrapper inside the C<WebFramework::Env::wrapper> as that wrapper at least loads a maximum limit for the length of an incomming JSON body. Otherwise you should set the C<JSON_BODY_MAX_LENGTH> environment variable yourself. 


=head1 INCOMPATIBILITIES


=head1 BUGS AND LIMITATIONS

This wrapper reads the body of the original HTTP response up to the length specified in the C<Content-Length> header. This wrapper does not check that the body is below a certain length. If the body is very large then reading the whole body into memory could use too many system resources. If long bodies are a potential problem, verify that the value of the C<Content-Length> header is not too large B<before> this wrapper runs.
 

=head1 AUTHOR

Peter Michaux, E<lt>petermichaux@gmail.comE<gt>


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2009 by Peter Michaux

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.
