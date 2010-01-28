#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 5;
use Test::Exception;
use JSON ();

BEGIN { use_ok('WebFramework::Controller::JSONOut', qw()) };

my $object_for_json = {
    'a' => 1.0,
    'b' => [0, '1', '2.0'],
    'c' => {'z' => []},
};
# hopefully JSON::to_json will repeatably serialize $object_for_json the same way each time.
my $json_text = JSON::to_json($object_for_json);

my $json_controller = WebFramework::Controller::JSONOut::wrapper(
    sub {
        my ($request) = @_;
        
        return {
            'headers' => {
                'Content-Type' => 'foo/bar', # should be clobbered
            },
            'json' => $object_for_json,
            'body' => 'bad body', # should be clobbered
        };
    }
);

my $scalar_controller = WebFramework::Controller::JSONOut::wrapper(
    sub {
        my ($request) = @_;
        
        return {
            'json' => 123,
        };
    }
);


my $response;

$response = $json_controller->({});
is($response->{headers}->{'Content-Type'}, 'application/json; charset=utf-8', 'The Content-Type header was set.');
is($response->{body}, $json_text, 'The object for json was serialized properly.');
ok(!exists($response->{'json'}), 'The json property was deleted');

dies_ok(sub{$scalar_controller->({})}, 'controller that sets scalar for json object value is bad.');
