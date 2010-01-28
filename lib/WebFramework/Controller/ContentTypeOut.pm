package WebFramework::Controller::ContentTypeOut;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';


sub _after {
    my ($response) = @_;

    if (!(defined($response->{headers}->{'Content-Type'}))) {
        $response->{headers}->{'Content-Type'} = 'text/plain';
    }

    if (($response->{headers}->{'Content-Type'} =~ qr{^text/(plain|html)}) &&
        ($response->{headers}->{'Content-Type'} !~ qr{charset})) {
    
        $response->{headers}->{'Content-Type'} .= '; charset=utf-8';
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

WebFramework::Controller::ContentTypeOut - A convenience wrapper that adds a default C<Content-Type> header to the HTTP response.


=head1 VERSION


=head1 SYNOPSIS

The most likely use of the ContentTypeOut wrapper is through its inclusion in the C<WebFramework::Controller::controller> subroutine.

  use WebFramework::Controller qw(controller);
  
  our $hello_controller = controller(sub {
      my ($request) = @_;
    
      return {
          'body' => '"hello, world" in plain text.',
      };
  });


=head1 DESCRIPTION

If the incoming response hash does not have a C<$response->{headers}->{'Content-Type'}> then C<text/plain> is added as the C<Content-Type>.

If the C<$response->{headers}->{'Content-Type'}> value is either C<text/plain> or C<text/HTML> and the C<charset> is not specified in the C<Content-Type> value then the UTF-8 character set is specified.


=head1 SUBROUTINES/METHODS

=head2 wrapper($inner_controller)

A subroutine for wrapping an inner controller. Returns the wrapped controller.


=head1 DIAGNOSTICS


=head1 CONFIGURATION AND ENVIRONMENT


=head1 DEPENDENCIES

This wrapper must be used inside a C<WebFramework::StandardOut::wrapper> as the outgoing response hash from this ContentTypeOut wrapper is of the type that C<WebFramework::StandardOut::wrapper> expects as its incoming response hash.


=head1 INCOMPATIBILITIES


=head1 BUGS AND LIMITATIONS


=head1 AUTHOR

Peter Michaux, E<lt>petermichaux@gmail.comE<gt>


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2009 by Peter Michaux

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.
