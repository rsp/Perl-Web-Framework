package WebFramework::Utils::File;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(absolutize_filename);

our $VERSION = '0.01';

use Carp ();
use File::Spec::Functions ();
use WebFramework::Utils::Module ();

sub do_file {
    my ($file) = @_;

    # from Camel book, third edition, page 702
    my $data;
    unless ($data = do($file)) {
        Carp::croak("couldn't parse $file: $@") if $@;
        Carp::croak("couldn't do $file: $!") unless defined $data;
        Carp::croak("couldn't run $file") unless $data;
    }
    return $data;
}

# inspired by Module::Install::ShareDir::_dist_file_old()
sub find_module_lib_subdir {
    my ($module_name, $templates) = @_;

    my $path = File::Spec::Functions::catfile(split('::', $module_name), $templates);
    foreach my $inc (@INC) {
        next unless defined $inc and ! ref $inc;
        my $full = File::Spec::Functions::catdir($inc, $path);
        next unless -d $full;
        unless (-r $full) {
            Carp::croak "Directory '$full', no read permissions";
        }
        return $full;
    }
    Carp::croak("Failed to find shared directory '$templates' for module '$module_name'");
}

sub find_module_inc_dir {
    my ($module_name) = @_;

    my $path = File::Spec::Functions::catfile(split('::', $module_name));
    foreach my $inc (@INC) {
        next unless defined $inc and ! ref $inc;
        my $full = File::Spec::Functions::catdir($inc, $path);
        next unless -d $full;
        return $inc;
    }
    Carp::croak("Failed to inc dir for module '$module_name'");
}

sub find_package_root_dir {
    my ($module_name) = @_;

    return File::Spec::Functions::catdir(find_module_inc_dir($module_name), '..');
}

sub slurp {
    my ($file_handle) = @_;

    return do {
      local $/;
      <$file_handle>;  
    };
}

sub absolutize_filename {
    my ($filename, $controller) = @_;

    if (!(File::Spec::Functions::file_name_is_absolute($filename))) {
        $filename = File::Spec::Functions::catdir(
                        find_package_root_dir(WebFramework::Utils::Module::remove_last($controller)),
                        $filename);
    }
    return $filename;
}

1;
__END__


=head1 NAME

WebFramework::Utils::File - Perl extension for


=head1 VERSION


=head1 SYNOPSIS


=head1 DESCRIPTION


=head1 SUBROUTINES/METHODS


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
