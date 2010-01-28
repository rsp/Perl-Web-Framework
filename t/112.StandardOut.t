#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 6;
use Test::Exception;

BEGIN { use_ok('WebFramework::Controller::StandardOut', qw()) };

my $ok_controller = WebFramework::Controller::StandardOut::wrapper(
    sub {
        my ($request) = @_;

        return {
            'status' => '200 OK',
            'headers' => {
                'Content-Type' => 'text/asdf',
                'X-Alpha'      => [
                    'abc',
                    '123',
                ],
            },
            'body' => 'the body content',
        };
    }
);

my $empty_response_controller = WebFramework::Controller::StandardOut::wrapper(
    sub {
        my ($request) = @_;

        return {};
    }
);


{
    # scalar I/O in Perl 5.8
    # http://www.perl.com/pub/a/2003/08/21/perlcookbook.html?page=2
    local *STDOUT;
    my $http_response;
    my $fh;
    open(\*STDOUT, '>', \$http_response) or die('could not open scalar I/O');

    my $response = $ok_controller->({});
    
    like($http_response, qr{^Status: 200 OK\r\n}, 'Status is printed into response');
    like($http_response, qr{\r\nContent-Type: text/asdf\r\n}, 'Content-Type is printed into response');
    like($http_response, qr{\r\nX-Alpha: abc,123\r\n}, 'X-Alpha with two values is printed into response');
    like($http_response, qr{\r\n\r\nthe body content$}, 'body is printed into response');
    
    close(\*STDOUT);
}

dies_ok(sub{$empty_response_controller->({})}, 'response without status dies');
