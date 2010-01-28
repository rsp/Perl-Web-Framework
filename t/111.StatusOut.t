#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 5;

BEGIN { use_ok('WebFramework::Controller::StatusOut', qw()) };

my $ok_controller = WebFramework::Controller::StatusOut::wrapper(
    sub {
        my ($request) = @_;

        return {};
    }
);

my $number_controller = WebFramework::Controller::StatusOut::wrapper(
    sub {
        my ($request) = @_;

        return {
            'status' => 200,
        };
    }
);

my $explicit_controller = WebFramework::Controller::StatusOut::wrapper(
    sub {
        my ($request) = @_;

        return {
            'status' => '77777 You Got It',
        };
    }
);

my $unknown_status_controller = WebFramework::Controller::StatusOut::wrapper(
    sub {
        my ($request) = @_;

        return {
            'status' => '393939',
        };
    }
);


my $response;

$response = $ok_controller->({});
is($response->{status}, '200 OK', 'check the response status set properly');

$response = $number_controller->({});
is($response->{status}, '200 OK', 'check the response status text set properly');

$response = $explicit_controller->({});
is($response->{status}, '77777 You Got It', 'check the response status text passed through untouched');

$response = $unknown_status_controller->({});
is($response->{status}, '393939', 'with unknown status code no status code text is attached');
