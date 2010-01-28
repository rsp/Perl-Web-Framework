use strict;
use warnings;

{
    'DEPLOYMENT'           => 'development',
    'LOG.LEVEL'            => 'debug',
    'LOG.FILE'             => 'var/log/app.log', # Relative to root directory of the application. Not good if application package is installed.
    'TMPDIR'               => 'tmp',
    'JSON_BODY_MAX_LENGTH' => 1048576, # 1 Megabyte
};
__END__


=head1 NAME


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
