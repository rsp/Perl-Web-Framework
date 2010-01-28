package WebFramework::Controller::StandardOut;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';

use Carp ();
use WebFramework::Utils::String ();


sub _print_header {
    my ($key, $value) = @_;

    print($key . ': ' . $value . "\r\n");
    return;
}


sub _print_status {
    my ($response) = @_;

    if (!(defined($response->{status}))) {
        Carp::croak('A response status code must be specified but was not.');
    }
    _print_header('Status', $response->{status});
    return;
}


sub _print_headers {
    my ($response) = @_;
    
    if (defined($response->{headers})) {
        foreach my $key (keys(%{$response->{headers}})) {
            if ($key ne WebFramework::Utils::String::guarantee_header_case($key)) {
                Carp::croak('WebFramework::Controller::StandardOut::_print_headers trying to print a header with bad capitalization: '."'$key'". ' vs' .'"'. WebFramework::Utils::String::guarantee_header_case($key). '"');
            }
            if (ref($response->{headers}->{$key}) eq 'ARRAY') {
                # Values of repeated headers can be collapsed to a comma separated value.
                # http://www.ietf.org/rfc/rfc2616.txt section 4.2
                _print_header($key, join(',', @{$response->{headers}->{$key}}));
            }
            else {
                _print_header($key, $response->{headers}->{$key});
            }
        }
    }
    return;
}


sub _print_end_headers {
    print("\r\n");
    return;
}


sub _after {
    my ($response) = @_;

    _print_status($response);
    _print_headers($response);
    _print_end_headers();

    if (defined($response->{body})) {
        print($response->{body});
    }
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

WebFramework::Controller::StandardOut - Prints a standard response hash to STDOUT as the CGI response.


=head1 VERSION


=head1 SYNOPSIS

The most likely use of the StandardOut wrapper is through its inclusion in the C<WebFramework::Controller::controller> subroutine.

  use WebFramework::Controller qw(controller);
  
  our $template_controller = controller(sub {
      my ($request) = @_;
    
      return {
          'status' => '200 OK',
          'headers' => {
              'Content-Type' => 'text/plain',
              'X-Alpha' => [
                  'abc',
                  '123',
              ],
          },
          'body' => 'hello, world',
      };
  });


=head1 DESCRIPTION

Printing directly to C<STDOUT> in a CGI script is a side-effect style of programming. Avoiding that is one of the main goals of WebFramework and this StandardOut wrapper is the wrapper enabling a functional style of programming controllers. If your controller is wrapped in the StandardOut wrapper then, instead of printing to C<STDOUT>, you C<return> a response hash that is then handled by the wrapper. 

The response hash must have a C<status> key and may have C<headers> and C<body> keys as shown in the synopsis section. The C<headers> hash must have keys that are in C<Capital-Hyphen-Case>. The value for a header key can be a scalar or an array.

Other wrappers that are inside the StandardOut wrapper do/may add other useful keys in the response object. For example, the JSONOut wrapper makes it so a C<json> key in the response object is converted to the correct C<Content-Type> and C<body> keys before the response is passed to StandardOut. This is how the majority of the wrappers work.


=head1 SUBROUTINES/METHODS

=head2 wrapper($inner_controller)

A subroutine for wrapping an inner controller. Returns the wrapped controller.


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
