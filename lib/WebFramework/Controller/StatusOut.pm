package WebFramework::Controller::StatusOut;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';

use HTTP::Status ();


sub _after {
    my ($response) = @_;

    $response->{status} ||= '200 OK'; # FastCGI needs this to be set so default to 200. CGI doesn't.
    if ($response->{status} =~ /^\d+$/) {
        my $text = HTTP::Status::status_message($response->{status});
        if (defined($text)) {
            $response->{status} .= ' ' . $text;
        }
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

WebFramework::Controller::StatusOut - Adds or completes the response status if the response status is not present.


=head1 VERSION


=head1 SYNOPSIS

The most likely use of the StatusOut wrapper is through its inclusion in the C<WebFramework::Controller::controller> subroutine.

  use WebFramework::Controller qw(controller);
  
  our $ok_controller = controller(sub {
      my ($request) = @_;
    
      return {
          'body' => 'will have status "200 OK"',
      };
  });


  our $ok_controller = controller(sub {
      my ($request) = @_;

      return {
          'status' => '404',
          'body' => 'will have status "404 Not Found"',
      };
  });


=head1 DESCRIPTION

If no  C<status> is specified in the incomming response hash, then this wrapper will add a C<status> of C<200 OK>. If the C<status> in the incomming response hash has a value that is just an integer, then this wrapper will complete the C<status> value with the appropriate text if the status code is known. For example, C<status> of C<404> will be changed to C<404 Not Found>. If the integer is not known by this wrapper then no status text will be added.


=head1 SUBROUTINES/METHODS

=head2 wrapper($inner_controller)

A subroutine for wrapping an inner controller. Returns the wrapped controller.


=head1 DIAGNOSTICS


=head1 CONFIGURATION AND ENVIRONMENT


=head1 DEPENDENCIES

This wrapper must be used inside a C<WebFramework::StandardOut::wrapper> as the outgoing response hash for this RedirectOut wrapper is of the type that C<WebFramework::StandardOut::wrapper> expects as its incoming response hash.


=head1 INCOMPATIBILITIES


=head1 BUGS AND LIMITATIONS


=head1 AUTHOR

Peter Michaux, E<lt>petermichaux@gmail.comE<gt>


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2009 by Peter Michaux

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.
