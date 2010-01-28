package WebFramework::Controller;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(controller);

our $VERSION = '0.01';

use WebFramework::Controller::CGI ();
use WebFramework::Controller::Env ();
use WebFramework::Controller::StandardOut ();
use WebFramework::Controller::FiveHundred ();
use WebFramework::Controller::StatusOut ();
use WebFramework::Controller::ContentTypeOut ();
use WebFramework::Controller::HeadersIn ();
use WebFramework::Controller::PathIn ();
use WebFramework::Controller::QueryIn ();
use WebFramework::Controller::BodyIn ();
use WebFramework::Controller::ParamsIn ();
use WebFramework::Controller::JSONIn ();
use WebFramework::Controller::CookiesIn ();
use WebFramework::Controller::TemplateOut ();
use WebFramework::Controller::JSONOut ();
use WebFramework::Controller::RedirectOut ();
use WebFramework::Controller::CookiesOut ();

sub controller {
    my ($inner_controller) = @_;

    return WebFramework::Controller::CGI::wrapper(
           WebFramework::Controller::Env::wrapper(
           WebFramework::Controller::StandardOut::wrapper(
           WebFramework::Controller::FiveHundred::wrapper(
           WebFramework::Controller::StatusOut::wrapper(
           WebFramework::Controller::ContentTypeOut::wrapper(
           WebFramework::Controller::HeadersIn::wrapper(
           WebFramework::Controller::PathIn::wrapper(
           WebFramework::Controller::QueryIn::wrapper(
           WebFramework::Controller::BodyIn::wrapper(
           WebFramework::Controller::ParamsIn::wrapper(
           WebFramework::Controller::JSONIn::wrapper(
           WebFramework::Controller::CookiesIn::wrapper(
           WebFramework::Controller::TemplateOut::wrapper(
           WebFramework::Controller::JSONOut::wrapper(
           WebFramework::Controller::RedirectOut::wrapper(
           WebFramework::Controller::CookiesOut::wrapper(

               $inner_controller

           )))))))))))))))));
}

1;
__END__


=head1 NAME

WebFramework::Controller - Provides a controller wrapper that combines many other controller wrappers.


=head1 VERSION


=head1 SYNOPSIS

  use WebFramework::Controller qw(controller);

  our $template_controller = controller(sub {
      my ($request) = @_;
  
      return {
          'template' => 'my/template.html.tt',
          'stash'    => {
              'alpha' => 1.0,
              'beta'  => '2.0',
          },
      };
  });


=head1 DESCRIPTION

This is the wrapper you probably want to use in the majority of cases. It combines many other wrappers that you would likely want to have around your controller subroutines: WebFramework::Controller::Env, WebFramework::Controller::JSONIn, WebFramework::Controller::TemplateOut, etc. Please read the source code of this module for a complete listing of the currently included wrappers. Please see each individual wrapper for a description of how that particular wrapper works.


=head1 SUBROUTINES/METHODS

=head2 controller($inner_controller)

A subroutine for wrapping an inner controller. Returns the wrapped controller.


=head1 DIAGNOSTICS


=head1 CONFIGURATION AND ENVIRONMENT


=head1 DEPENDENCIES


=head1 INCOMPATIBILITIES


=head1 BUGS AND LIMITATIONS

The way wrappers work, one wrapper can clobber another wrappers work. For example, in the following controller, will the body be produced by the results of the template or from stringifying the json? If the C<WebFramework::Controller::JSONOut> wrapper is outside the C<WebFramework::Controller::Template> wrapper then the body will be the result of stringifying the json parameter but the content type will set to C<text/html; charset=utf-8> by C<WebFramework::Controller::Template>. In a case like this, you should not depend on any particular current ordering of the wrappers included in this wrapper. The order of the included wrappers may change and so change the resulting response body.

  use WebFramework::Controller qw(controller);

  our $template_controller = controller(sub {
      my ($request) = @_;
  
      return {
          'template' => 'my/template.html.tt',
          'json'     => {'a' => 1},
      };
  });


=head1 AUTHOR

Peter Michaux, E<lt>petermichaux@gmail.comE<gt>


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2009 by Peter Michaux

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.
