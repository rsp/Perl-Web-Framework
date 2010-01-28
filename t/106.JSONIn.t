#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 8;
use File::Spec::Functions qw();


BEGIN { use_ok('WebFramework::Controller::JSONIn', qw()) };

my $json_controller;
my $response;

# ---------

$json_controller = WebFramework::Controller::JSONIn::wrapper(
    sub {
        my ($request) = @_;
        
        # these tests run only for a well formed request
        is($request->{json}->{alpha}, 1, 'alpha parameter made it into the controller');
        # use a regular expression because want to ensure string comparison. Perhaps
        # there is a better way.
        like($request->{json}->{beta}, qr{^2.0$}, 'beta parameter made it into the controller');
        
        return {
            status => '200',
        };
    }
);

# body too long test
{
    $ENV{'CONTENT_TYPE'} = 'application/json';
    $ENV{'CONTENT_LENGTH'} = '1025';
    my $max_file_length = -1;
    ok($ENV{'CONTENT_LENGTH'} > $max_file_length, "check that file is actually too large");
    $ENV{'JSON_BODY_MAX_LENGTH'} = $max_file_length;
    $response =  $json_controller->({});
    like($response->{status}, qr{^413}, 'response status is set correctly for big bodies');
}

# bad Content-Length header
{
    $ENV{'CONTENT_TYPE'} = 'application/json';
    $ENV{'CONTENT_LENGTH'} = 'abc';
    $response =  $json_controller->({});
    like($response->{status}, qr{^400}, 'response status is set correctly for malformed Content-Length header.');
}


# no Content-Length header
{
    $ENV{'CONTENT_TYPE'} = 'application/json';
    delete($ENV{'CONTENT_LENGTH'});
    $response =  $json_controller->({});
    like($response->{status}, qr{^411}, 'response status is set correctly for missing Content-Length header.');
}

# well formed request
{
    my $filename = File::Spec::Functions::catdir('t', 'files', 'json_body.js');
    $ENV{'CONTENT_TYPE'} = 'application/json';
    $ENV{'CONTENT_LENGTH'} = -s $filename;
    $ENV{'JSON_BODY_MAX_LENGTH'} = $ENV{'CONTENT_LENGTH'}+10;
    local *STDIN;
    open(\*STDIN, '<', $filename) or die("couldn't open file '$filename'");
    $response =  $json_controller->({});
    like($response->{status}, qr{^200}, 'response status is set correctly for good JSON request.');
    close(\*STDIN);    
}

