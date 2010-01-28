package WebFramework::Controller::FiveHundred;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';


sub _around {
    my ($request, $inner_controller) = @_;

    my $response;

    eval {
        $response = $inner_controller->($request);
    };
    if ($@) {
        $response = {
            'status' => '500 Internal Server Error',
            'headers' => {
              'Content-Type' => 'text/plain; charset=utf-8',
            },
            'body' => 'some error message ' . $@,
        };
    }
    return $response;
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

WebFramework::Controller::FiveHundred - Adds an C<eval> wrapper around the inner controller to send a C<500> status response with an error message to the browser.


=head1 VERSION


=head1 SYNOPSIS

The most likely use of the FiveHundred wrapper is through its inclusion in the C<WebFramework::Controller::controller> subroutine.

  use WebFramework::Controller qw(controller);
  
  our $protected_controller = controller(sub {
      my ($request) = @_;
    
      die("something unknown happened");
  });


=head1 DESCRIPTION


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
