package WebFramework::Controller::Env;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';

use Config;
use Carp ();
use File::Spec::Functions ();
use WebFramework::Utils::File ();
use WebFramework::Utils::Module ();
use WebFramework::Utils::Hash ();


sub _around {
    my ($request, $inner_controller) = @_;

    my $env_top;
    my $env_middle;
    my $env_bottom;
    my $file;
    my $etc_dir;

    # Assemble the top of the new env hash starting with highest precedence.
    
    # the real system environment
    $env_top = WebFramework::Utils::Hash::clone_hash(\%ENV);

    # extra configuration files
    if (defined($ENV{ENV_FILES})) {
        my @paths = split($Config{path_sep}, $ENV{ENV_FILES});
        foreach my $file (@paths) {
            if (length($file) == 0) { # could be adjacent path separators in ENV_FILES path which is allowed
                next;
            }
            my $properties = WebFramework::Utils::File::do_file($file);
            foreach my $key (keys(%{$properties})) {
                if (!(defined($env_top->{$key}))) {
                  $env_top->{$key} = $properties->{$key};
                }
            }
        }
    }

    # Assemble the bottom of the new env hash starting with lowest precedence.

    # default properties
    $etc_dir = WebFramework::Utils::File::find_module_lib_subdir('WebFramework', 'etc');
    $file = File::Spec::Functions::catfile($etc_dir, 'default.pl');
    $env_bottom = WebFramework::Utils::File::do_file($file);

    # load app config file
    $etc_dir = WebFramework::Utils::File::find_module_lib_subdir(WebFramework::Utils::Module::remove_last($request->{controller}), 'etc');
    $file = File::Spec::Functions::catfile($etc_dir, 'environment.pl');
    $env_middle = WebFramework::Utils::File::do_file($file);
    # merge the tmp over the env_bottom.
    foreach my $key (keys(%{$env_middle})) {
      $env_bottom->{$key} = $env_middle->{$key};
    }
    
    # look through the env_top and env_bottom to determine the DEPLOYMENT.
    my $deployment = defined($env_top->{'DEPLOYMENT'}) ? $env_top->{'DEPLOYMENT'} : $env_bottom->{'DEPLOYMENT'};
    if (!(defined($deployment))) {
      Carp::croak('Could not determine deployment.');
    }
    
    # load app deployment config file
    $etc_dir = WebFramework::Utils::File::find_module_lib_subdir(WebFramework::Utils::Module::remove_last($request->{controller}), 'etc');
    $file = File::Spec::Functions::catfile($etc_dir, $deployment.'.pl');
    $env_middle = WebFramework::Utils::File::do_file($file);

    if (defined($env_middle->{'DEPLOYMENT'})) {
      # not allowed because DEPLOYMENT is used to determine which file to load and this file hasn't been loaded 
      # when that determination is made. It is a chicken and egg problem and we don't want it.
      Carp::croak('Not allowed to define DEPLOYMENT in the app deployment file: ' . $file);
    }
    
    # merge the env_middle over the env_bottom.
    foreach my $key (keys(%{$env_middle})) {
      $env_bottom->{$key} = $env_middle->{$key};
    }

    # merge the env_top and env_bottom.
    foreach my $key (keys(%{$env_top})) {
      $env_bottom->{$key} = $env_top->{$key};
    }

    my $result;
    {
        local %ENV = %{$env_bottom};
        # call inner controller in the new environment
        $result = $inner_controller->($request);
    }
    return $result;
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

WebFramework::Controller::Env - Loads configuration files and adds the configuration parameters as environment variables.


=head1 VERSION


=head1 SYNOPSIS

The most likely use of the Env wrapper is through its inclusion in the C<WebFramework::Controller::controller> subroutine.

  use WebFramework::Controller qw(controller);
  
  our $template_controller = controller(sub {
      my ($request) = @_;
    
      return {
          'body' => 'The special environment variable value is "'.$ENV{SPECIAL}.".',
      };
  });

Where the C<SPECIAL> parameter is specified in one of the configuration files.


=head1 DESCRIPTION

This wrapper augments the real environment with parameters loaded from a series of configuration files. The wrapped controller runs in this augmented environment. This allows configuration to be specified in a way independent of server-specific ways (e.g. C<SetEnv> with Apache's C<mod_env>.)

The augmented environment is built by layering various files in a particular order. These files are described below in order of highest to lowest precedence.

Any parameters specifed in the real environment have the highest precedence and will not be overridden by any value in a configuration file. 

The $ENV{ENV_FILES} value in the real environment can specify a path of one or more environment files. For example C</some/file.pl:/some/other/file.pl>. The values specified in the first file in the path have higher precedence than the values in the second file and so on.

The application deployment configuration file is loaded from a standard location. For example if your application C<My::App> is in C<development> mode then the C<development.pl> configuration file is loaded from C<My-App/lib/My/App/etc/development.pl>.

The application configuration file is loaded from  C<My-App/lib/My/App/etc/environment.pl>.

The default configuration file is loaded from C<WebFramework/lib/WebFramework/etc/default.pl>.

A configuration file is just a Perl source file that ends with a hash reference.

  use strict;
  use warnings;
  
  my $value = 'asdf';
  
  {
    'SPECIAL' => $value,
  };
  __END__

The default value of the C<DEPLOYMENT> parameter is C<development>. The C<DEPLOYMENT> can be set in the real environment or in any configuration file other than the C<E<lt>DEPLOYMENTE<gt>.pl> file.


=head1 SUBROUTINES/METHODS

=head2 wrapper($inner_controller)

A subroutine for wrapping an inner controller. Returns the wrapped controller.


=head1 DIAGNOSTICS


=head1 CONFIGURATION AND ENVIRONMENT

See the description regarding the C<DEPLOYMENT> parameter and how the configuration file values are combined with the real environment.


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
