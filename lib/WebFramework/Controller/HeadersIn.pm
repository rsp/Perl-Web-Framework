package WebFramework::Controller::HeadersIn;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';


sub _convert_case {
    my ($key) = @_;
	return join('-', map { ucfirst(lc($_)) } split(/\_/, $key));
}


sub _before {
    my ($request) = @_;

    my $headers = {};

    foreach my $name (keys(%ENV)) {
        my $value = $ENV{$name};
        if ($name =~ /^HTTPS?_(.*)$/ ) { # $1 holds the header name in uppercase and underscore (e.g. CONTENT_TYPE)
            $headers->{_convert_case($1)} = $value;
        }
    }
    # The CGI spec requires Content-Type and Content-Length headers to be 
    # specified as environment variables CONTENT_TYPE and CONTENT_LENGTH.
    # If the server also specified them as HTTP_CONTENT_TYPE, etc, then
    # just clobber those previous defined properties.
    $headers->{'Content-Type'}   = $ENV{CONTENT_TYPE};
    $headers->{'Content-Length'} = $ENV{CONTENT_LENGTH};

    $request->{headers} = $headers;
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

WebFramework::Controller::HeadersIn - Adds access to HTTP request headers through the C<$request-E<gt>{headers}> hash reference.


=head1 VERSION


=head1 SYNOPSIS

The most likely use of the HeadersIn wrapper is through its inclusion in the C<WebFramework::Controller::controller> subroutine.

  use WebFramework::Controller qw(controller);
  
  our $submission_controller = controller(sub {
      my ($request) = @_;
    
      if ($request->{headers}->{'Content-Length'} <= 512) {
          return {
              body => 'Thank you for your brief submission.',
          };
      }
      else {
          return {
              body => 'Your submission was way too long.',
          };
      }
  });


=head1 DESCRIPTION

The headers keys added to the C<$request-E<gt>{headers}> hash are in C<Capital-Hyphen-Case>.

Headers repeated in the original HTTP request are combined as a comma separated value.


=head1 SUBROUTINES/METHODS

=head2 wrapper($inner_controller)

A subroutine for wrapping an inner controller. Returns the wrapped controller.


=head1 DIAGNOSTICS


=head1 CONFIGURATION AND ENVIRONMENT


=head1 DEPENDENCIES


=head1 INCOMPATIBILITIES


=head1 BUGS AND LIMITATIONS

=head1 SEE ALSO

The CGI specification discusses how HTTP headers are passed to the CGI script as headers:

  http://hoohoo.ncsa.illinois.edu/cgi/env.html


=head1 AUTHOR

Peter Michaux, E<lt>petermichaux@gmail.comE<gt>


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2009 by Peter Michaux

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.
