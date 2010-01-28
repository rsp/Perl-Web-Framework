package WebFramework::Controller::ParamsIn;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';

sub _before {
    my ($request) = @_;

    my @sources = ($request->{query}->{params},
                   $request->{body}->{params});
    
    my $params = {};
    my $param = {};
    
    foreach my $source (@sources) {
        if (defined($source)) {
            foreach my $key (keys(%{$source})) {
                if (defined($params->{$key})) {
                    # In the next line, Perl will flatten to make one combined array.
                    my @combination = (@{$params->{$key}}, @{$source->{$key}});
                    $params->{$key} = \@combination;
                }
                else {
                    $params->{$key} = $source->{$key};
                }
            }
        }
    }

    # params has array ref values 
    # param has single scalar values
    foreach my $key (keys(%{$params})) {
        if (ref($params->{$key}) ne 'ARRAY') {
            $params->{$key} = [$params->{$key}];
        }
        $param->{$key} = $params->{$key}->[0];
    }

    $request->{params} = $params;
    $request->{param} = $param;    
    
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

WebFramework::Controller::ParamsIn - Perl extension for


=head1 VERSION


=head1 SYNOPSIS


=head1 DESCRIPTION

# http://www.w3.org/Protocols/rfc1341/7_2_Multipart.html
# http://tools.ietf.org/html/rfc1867
# http://www.ietf.org/rfc/rfc2616.txt


Note that the temporary directory must be writable by the server process. Don't make the directory world writable. Make it owned by the correct owner.


=head1 SUBROUTINES/METHODS


=head1 DIAGNOSTICS


=head1 CONFIGURATION AND ENVIRONMENT


=head1 DEPENDENCIES

must be inside QueryIn and BodyIn

=head1 INCOMPATIBILITIES


=head1 BUGS AND LIMITATIONS


=head1 AUTHOR

Peter Michaux, E<lt>petermichaux@gmail.comE<gt>


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2009 by Peter Michaux

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.
