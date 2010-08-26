package WebFramework::Controller::BodyIn;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw(wrapper);

our $VERSION = '0.01';

use HTTP::Body ();
use WebFramework::Utils::File qw(absolutize_filename);

sub _before {
    my ($request) = @_;

    if (defined($ENV{CONTENT_TYPE}) && 
        (($ENV{CONTENT_TYPE} =~ qr|^multipart/form-data|)
         ||
         ($ENV{CONTENT_TYPE} =~ qr|^application/x-www-form-urlencoded|)
        )
       ) {

        my $parser = HTTP::Body->new( $ENV{CONTENT_TYPE}, $ENV{CONTENT_LENGTH} );
        $parser->tmpdir(absolutize_filename($ENV{TMPDIR}, $request->{controller}));
        $parser->cleanup(1);
        my $length = $ENV{CONTENT_LENGTH};

        while ( $length ) {

            my $body_string;
            read(\*STDIN, $body_string, (( $length < 8192 ) ? $length : 8192));

            $length -= length($body_string);
        
            $parser->add($body_string);
        }
    
        my $uploads = $parser->upload; # hashref
        my $param_ref  = $parser->param;  # hashref
        # my $body    = $parser->body;   # IO::Handle

        $request->{uploads} = $uploads;

        foreach my $key (keys(%$param_ref)) {
            if (ref($param_ref->{$key}) eq 'ARRAY') {
                $request->{body}->{params}->{$key} = $param_ref->{$key};
            }
            else {
                $request->{body}->{params}->{$key} = [$param_ref->{$key}];
            }
        }
    }
    
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

WebFramework::Controller::BodyIn - Perl extension for


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


=head1 INCOMPATIBILITIES


=head1 BUGS AND LIMITATIONS

If the length of a part's body is long, this library will just keep reading it into memory. This 
could be dangerous (i.e. use up all system memory) if a request contains a long body.


When reading a part's body bytes into a temporary file, the complete body bytes are read into memory
and then written out to the file. Reading a subsection of the part body's bytes, looking for the following
delimiter or closing delimiter line, writing that subsection to the file and then repeating would
be more memory efficient. Cannot really do this by reading "a line" of the part body at a time
because the chance of encountering a line terminator is unlikely. Put another way, what would an appropriate
line terminator acutally be (in a GIF file, for example.) CGI.pm does address this problem.


The form input name and filename attributes values are double quoted. This library does not handle the case
where the value of these attributes contains a double quote, even if preceeded by a backslash. In a quick 
check, it seems that at least Firefox does not add backslashes to filename values if the file contains
a double quote. The browser sends:

  Content-Disposition: form-data; name="file_input"; filename="test-file"name.txt"

So checking for backslash-escaped double quotes wouldn't even work. In the above example, this library
will assume the filename is just "test-file" and the "\"name.txt" part of the original filename is lost. 
HTML authors should not use double quotes in their form input name values either.


=head1 AUTHOR

Peter Michaux, E<lt>petermichaux@gmail.comE<gt>


=head1 LICENSE AND COPYRIGHT

Copyright (C) 2009 by Peter Michaux

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.
