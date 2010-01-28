package WebFramework::Controller::CookiesIn;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';

use CGI::Cookie ();


sub _before {
    my ($request) = @_;

    my %cgi_cookies = CGI::Cookie->fetch();

    my $cookies = {};

    foreach my $name (keys(%cgi_cookies)) {
        my $cookie = $cgi_cookies{$name};
        $cookies->{$cookie->name()} = $cookie->value();
    }

    $request->{cookies} = $cookies;
    return $request;
}


sub wrapper {
    my ($inner_controller) = @_;

    return sub {
        my ($request) = @_;
        return $inner_controller->(_before($request));
    };
}


1;
__END__


=head1 NAME

WebFramework::Controller::CookiesIn - Adds access to HTTP request cookies through the C<$request-E<gt>{cookies}> hash reference.


=head1 VERSION


=head1 SYNOPSIS

The most likely use of the CookiesIn wrapper is through its inclusion in the C<WebFramework::Controller::controller> subroutine.

  use WebFramework::Controller qw(controller);
  use Your::Module qw(find_user_by_session_id);
  
  our $protected_controller = controller(sub {
      my ($request) = @_;
    
      if (find_user_by_session_id($request->{cookies}->{session})) {
          return {
              body => 'the secret is #########',
          };
      }
      else {
          return {
              body => 'fat chance we'll tell the secret',
          };
      }    
  });


=head1 DESCRIPTION


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
