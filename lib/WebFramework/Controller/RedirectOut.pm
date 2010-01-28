package WebFramework::Controller::RedirectOut;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';

use Carp ();


sub _after {
    my ($response) = @_;

    if (!defined($response->{301}) && !defined($response->{302})) {
        return $response;
    }

    if (defined($response->{301}) && defined($response->{302})) {
        Carp::croak('Both $response->{301} and $response->{302} are set but only one can be set. ' .
                    'The value of $response->{301} is "' . $response->{301} . '" and ' .
                    'the value of $response->{302} is "' . $response->{302} . '".');
    }

    my $location = $response->{301} || $response->{302};
    
    if ($location) {
        $response->{headers}->{Location} = $location;
        $response->{status} = defined($response->{301}) ? 301 : 302;
    }
    delete($response->{301});
    delete($response->{302});
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

WebFramework::Controller::RedirectOut - A convenience wrapper for generating a temporary or permanent HTTP redirect response.


=head1 VERSION


=head1 SYNOPSIS

The most likely use of the RedirectOut wrapper is through its inclusion in the C<WebFramework::Controller::controller> subroutine.

  use WebFramework::Controller qw(controller);
  
  our $redirect_controller = controller(sub {
      my ($request) = @_;
    
      return {
          '302' => '/some/other/place',
      };
  });


=head1 DESCRIPTION

This wrapper checks for a C<301> or C<302> key on the incoming response hash. If one is present then the appropriate C<Status> and C<Location> values are added to the outgoing response object.

This wrapper checks that the incoming response hash has none or one of the C<301> or C<302> keys. If both are present the wrapper throws an exception.

If the incoming response has a C<301> or C<302> key and also already has a <$response->{status}> and/or <$response->{headers}->{Location}> property then the already existing values are clobbered. This is the intended behavior.


=head1 SUBROUTINES/METHODS

=head2 wrapper($inner_controller)

A subroutine for wrapping an inner controller. Returns the wrapped controller.


=head1 DIAGNOSTICS


=head1 CONFIGURATION AND ENVIRONMENT


=head1 DEPENDENCIES

This wrapper must be used inside a C<WebFramework::StandardOut::wrapper> as the outgoing response hash for this RedirectOut wrapper is of the type that C<WebFramework::StandardOut::wrapper> expects as its incoming response hash.


=head1 INCOMPATIBILITIES


=head1 BUGS AND LIMITATIONS

It would not make sense that the incoming response hash has anything other than a single scalar as the value for the C<301> or C<302> key. For example, if the value was an array then that means two C<Location> headers or a comma separated list of values for one C<Location> header will be in the response and that doesn't make sense. It would probably mean that the program has made a mistake and an exception would help debug things. This wrapper does not check that the value is just a scalar. It would be good to check that the value is a scalar and throw an error if it is not.

If the incoming response hash contains a relative URL for the C<301> or C<302> value, this wrapper does not convert that value to an absolute URL. Perhaps some browsers require an absolute URL in the C<Location> header and this wrapper could do that.


=head1 AUTHOR

Peter Michaux, E<lt>petermichaux@gmail.comE<gt>


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2009 by Peter Michaux

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.
