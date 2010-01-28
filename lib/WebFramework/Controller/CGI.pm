package WebFramework::Controller::CGI;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';

# Because WebFramework unifies all server technology to the CGI system,
# the subroutines here are very simple. They don't have to do or modify anything along the pipeline of serving a request.
# It is almost pointless to have these but perhaps the underlying unified system in WebFramework will change in the future
# and so these subroutines abstract that underlying unified system so that it can change.

sub wrapper {
    my ($inner_controller) = @_;

    return $inner_controller;
}

1;
__END__


=head1 NAME

WebFramework::Controller::CGI - Perl extension for


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
