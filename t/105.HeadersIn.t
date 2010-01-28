#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 8;

BEGIN { use_ok('WebFramework::Controller::HeadersIn', qw()) };

my $headers_controller;

# ---------

delete($ENV{HTTP_CONTENT_TYPE});
delete($ENV{CONTENT_TYPE});
delete($ENV{HTTP_CONTENT_LENGTH});
delete($ENV{CONTENT_LENGTH});
delete($ENV{HTTPS_ACCEPT});

$headers_controller = WebFramework::Controller::HeadersIn::wrapper(
    sub {
        my ($request) = @_;
        
        isnt(defined($request->{headers}->{'Content-Type'}), 'Should be no Content-Type header.');
        isnt(defined($request->{headers}->{'Content-Length'}), 'Should be no Content-Length header.');
        isnt(defined($request->{headers}->{'Accept'}), 'Should be no Accept header.');
        
        return {};
    }
);

$headers_controller->({});

# ---------

my $content_type = 'application/json';
my $content_length = 1024;
my $accept = 'foo/bar';

$ENV{HTTP_CONTENT_TYPE} = 'something to be overridden';
$ENV{CONTENT_TYPE} = $content_type;
$ENV{HTTP_CONTENT_LENGTH} = 'something else to be overridden';
$ENV{CONTENT_LENGTH} = $content_length;
$ENV{HTTPS_ACCEPT} = $accept;

$headers_controller = WebFramework::Controller::HeadersIn::wrapper(
    sub {
        my ($request) = @_;
        
        is($request->{headers}->{'Content-Type'}, $content_type, 'Test Content-Type header set.');
        isnt(defined($request->{headers}->{'CONTENT_TYPE'}), 'Test CONTENT_TYPE header with that case is not set.');
        is($request->{headers}->{'Content-Length'}, $content_length, 'Test Content-Length header set.');
        is($request->{headers}->{'Accept'}, $accept, 'Test that Accept header is set.');
        
        return {};
    }
);

$headers_controller->({});
