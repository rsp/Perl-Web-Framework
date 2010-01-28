package WebFramework::Controller::JSONOut;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';

use Carp ();
use JSON ();


sub _after {
    my ($response) = @_;

    if (!(defined($response->{json}))) {
        return $response;
    }

    my $ref_type = ref($response->{json});
    
    if (($ref_type ne 'HASH') && ($ref_type ne 'ARRAY')) {
        Carp::croak('The "json" key of the response hash must have ' .
                    'a value which is a hash or array reference. ' .
                    'The value is "'.$ref_type.'"');
    }

    $response->{headers}->{'Content-Type'} = 'application/json; charset=utf-8';
    
    $response->{body} = JSON::to_json($response->{json});

    delete($response->{json});

    return $response;
}


sub wrapper {
    my ($inner_controller) = @_;

    return sub {
        my ($request) = @_;
        return _after($inner_controller->($request));
    };
}


1;
__END__


=head1 NAME

WebFramework::Controller::JSONOut - A convinience wrapper for generating an HTTP response containing a JSON body.


=head1 VERSION


=head1 SYNOPSIS

The most likely use of the JSONOut wrapper is through its inclusion in the C<WebFramework::Controller::controller> subroutine.

  use WebFramework::Controller qw(controller);
  
  our $json_controller = controller(sub {
      my ($request) = @_;
    
      return {
          'json' => {
              'a' => 1.0,
              'b' => [0, '1', '2.0'],
              'c' => {'z' => []},
          },
      };
  });


=head1 DESCRIPTION

This wrapper checks for a C<json> key on the incoming response hash. If the key is present then the appropriate C<Content-Type> header is set and and the value of the C<json> key is serialized to a JSON text to be the body of the HTTP response.

This wrapper checks that the C<json> key has a value that is either a hash or array reference otherwise an exception is thrown.

If the incoming response has a C<json> key and also already has a <$response->{headers}->{'Content-Type'}> and/or <$response->{body}> key then the already existing values are clobbered. This is the intended behavior.


=head1 SUBROUTINES/METHODS

=head2 wrapper($inner_controller)

A subroutine for wrapping an inner controller. Returns the wrapped controller.


=head1 DIAGNOSTICS


=head1 CONFIGURATION AND ENVIRONMENT


=head1 DEPENDENCIES

This wrapper must be used inside a C<WebFramework::StandardOut::wrapper> as the outgoing response hash for this JSONOut wrapper is of the type that C<WebFramework::StandardOut::wrapper> expects as its incoming response hash.


=head1 INCOMPATIBILITIES


=head1 BUGS AND LIMITATIONS


=head1 AUTHOR

Peter Michaux, E<lt>petermichaux@gmail.comE<gt>


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2009 by Peter Michaux

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.
