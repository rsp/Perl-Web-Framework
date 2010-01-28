#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 4;

BEGIN { use_ok('WebFramework::Controller::FiveHundred', qw()) };

my $error_controller = WebFramework::Controller::FiveHundred::wrapper(
    sub {
        my ($request) = @_;

        die('something unknown happened');

        return {};
    }
);

my $regular_controller = WebFramework::Controller::FiveHundred::wrapper(
    sub {
        my ($request) = @_;

        return {
            status => '200',
        };
    }
);

my $response;
$response = $error_controller->({});
is($response->{status}, '500 Internal Server Error', 'check the response status is 500');
like($response->{body}, qr{something unknown happened}, 'check the response contains the error message');

$response = $regular_controller->({});
is($response->{status}, 200, 'check that non-error response makes it though the wrapper untouched.')