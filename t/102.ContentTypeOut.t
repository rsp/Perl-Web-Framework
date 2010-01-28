#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 7;
use Test::Exception;

BEGIN { use_ok('WebFramework::Controller::ContentTypeOut', qw()) };

my $no_content_type_controller = WebFramework::Controller::ContentTypeOut::wrapper(
    sub {
        my ($request) = @_;
        
        return {};
    }
);

my $plain_text_controller = WebFramework::Controller::ContentTypeOut::wrapper(
    sub {
        my ($request) = @_;
        
        return {
            'headers' => {
                'Content-Type' => 'text/plain',
            },
        };
    }
);

my $html_controller = WebFramework::Controller::ContentTypeOut::wrapper(
    sub {
        my ($request) = @_;
        
        return {
            'headers' => {
                'Content-Type' => 'text/html',
            },
        };
    }
);

my $plain_charset_controller = WebFramework::Controller::ContentTypeOut::wrapper(
    sub {
        my ($request) = @_;
        
        return {
            'headers' => {
                'Content-Type' => 'text/plain; charset=asdf',
            },
        };
    }
);

my $html_charset_controller = WebFramework::Controller::ContentTypeOut::wrapper(
    sub {
        my ($request) = @_;
        
        return {
            'headers' => {
                'Content-Type' => 'text/html; charset=asdf',
            },
        };
    }
);

my $foo_bar_controller = WebFramework::Controller::ContentTypeOut::wrapper(
    sub {
        my ($request) = @_;
        
        return {
            'headers' => {
                'Content-Type' => 'foo/bar',
            },
        };
    }
);

my $response;

$response = $no_content_type_controller->({});
is($response->{headers}->{'Content-Type'}, 'text/plain; charset=utf-8', 'The Content-Type header was set.');

$response = $plain_text_controller->({});
is($response->{headers}->{'Content-Type'}, 'text/plain; charset=utf-8', 'The charset was appended to text/plain.');

$response = $html_controller->({});
is($response->{headers}->{'Content-Type'}, 'text/html; charset=utf-8', 'The charset was appended to text/html.');

$response = $plain_charset_controller->({});
is($response->{headers}->{'Content-Type'}, 'text/plain; charset=asdf', 'The charset was correctly not appended to text/html.');

$response = $html_charset_controller->({});
is($response->{headers}->{'Content-Type'}, 'text/html; charset=asdf', 'The charset was correctly not appended to text/html.');

$response = $foo_bar_controller->({});
is($response->{headers}->{'Content-Type'}, 'foo/bar', 'The charset was correctly not appended to foo/bar.');
