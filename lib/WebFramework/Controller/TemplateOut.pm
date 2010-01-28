package WebFramework::Controller::TemplateOut;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';

use File::Spec::Functions ();
use Carp ();
use Template ();
use MIME::Types ();
use WebFramework::Utils::File ();
use WebFramework::Utils::Module ();

sub _after {
    my ($controller_name, $response) = @_;

    if (!(defined($response->{template}))) {
        return $response;
    }

    my $tt_config = {};

    foreach my $k (keys(%ENV)) {
        if ($k =~ m/^TT\.(.*)$/) { # $1 will hold the grouped part at the end of the match
            $tt_config->{$1} = $ENV{$k};
        }
    }

    if (!(defined($tt_config->{INCLUDE_PATH}))) {
        $tt_config->{INCLUDE_PATH} =
            File::Spec::Functions::catdir(
                WebFramework::Utils::File::find_module_lib_subdir(
                    WebFramework::Utils::Module::remove_last($controller_name),
                    'View'),
               'templates');
    }

    my $tt = Template->new($tt_config);
    my $stash = defined($response->{stash}) ? $response->{stash} : {};
    my $template_result;
    $tt->process($response->{template}, $stash, \$template_result);
    $response->{body} = $template_result;

    if (!(defined($response->{headers}->{'Content-Type'}))) {
        my ($extension) = $response->{template} =~ qr|\.([^.]+)\.[^.]+$|;
        if (!(defined($extension))) {
            Carp::croak('The template name format is incorrect. The filename must have a double extension like ".html.tt" but the filename is "'.$response->{template}.'".');
        }
        my ($mediatype) = MIME::Types::by_suffix($extension);
        if ($mediatype eq '') {
            Carp::croak('The MIME::Types module does not know the associated media type for extension "'.$extension.'".');
        }
        $response->{headers}->{'Content-Type'} = $mediatype . '; charset=utf-8'; # all templates files are saved in UTF-8
    }
    delete($response->{template});
    delete($response->{stash});
    return $response;
}

sub wrapper {
    my ($inner_controller) = @_;

    return sub {
        my ($request) = @_;

        my $controller_name = $request->{controller};
        return _after($controller_name, $inner_controller->($request));
    };
}

1;
__END__


=head1 NAME

WebFramework::Controller::TemplateOut - Convinience wrapper to use Template Toolkit to generate the full response body.


=head1 VERSION


=head1 SYNOPSIS

The most likely use of the TemplateOut wrapper is through its inclusion in the C<WebFramework::Controller::controller> subroutine.

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

If a C<$response-E<gt>{template}> value is provided by an inner controller, this wrapper will use Template Toolkit to generate the response using that template. If an optional C<$response-E<gt>{stash}> is provided that will be used as the Template Toolkit stash.

If a C<Content-Type> header is not already present on the incomming response hash then this wrapper will use the penultimate file extension (e.g. a file name ending with C<.html.tt> has a penultimate extension of C<html>) to determine the correct C<Content-Type> header for the response.


=head1 SUBROUTINES/METHODS

=head2 wrapper($inner_controller)

A subroutine for wrapping an inner controller. Returns the wrapped controller.


=head1 DIAGNOSTICS


=head1 CONFIGURATION AND ENVIRONMENT

Environment variables prefixed with C<TT.> are stripped of the prefix and sent to Template Toolkit as its configuration parameters.

If a C<TT.INCLUDE_PATH> environment variable is not present then this wrapper will determine the default template location relative to your main controller (usually a WebFramework::Dispatcher::dispatcher). A picture shows the arrangment:

  My-App/
      lib/
          My/
              App.pm  # contains My::App::main
              App/
                  View/
                      templates/ # default template directory


=head1 DEPENDENCIES

This wrapper must be used inside a C<WebFramework::StandardOut::wrapper> as the outgoing response hash for this TemplateOut wrapper is of the type that C<WebFramework::StandardOut::wrapper> expects as its incoming response hash.


=head1 INCOMPATIBILITIES


=head1 BUGS AND LIMITATIONS


=head1 AUTHOR

Peter Michaux, E<lt>petermichaux@gmail.comE<gt>


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2009 by Peter Michaux

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.
