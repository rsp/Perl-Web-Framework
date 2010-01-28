package WebFramework::Utils::Request;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(parse_url_query_string);

our $VERSION = '0.01';

use CGI::Util ();

# loose order of parameters
sub parse_url_query_string {
    my ($query_string) = @_;
    
    my @key_value_pairs = split('&', $query_string);
    my $params = {};
    foreach my $key_value_pair (@key_value_pairs) {
        my ($key, $value) = map {CGI::Util::unescape($_);} split('=', $key_value_pair, 2);
        $params->{$key} ||= [];
        push(@{$params->{$key}}, $value);
    }
    
    return $params;
}



1;
__END__


=head1 NAME

WebFramework::Utils::Request - Perl extension for


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
