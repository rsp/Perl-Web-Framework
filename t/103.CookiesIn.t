#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 4;

BEGIN { use_ok('WebFramework::Controller::CookiesIn', qw()) };

my $cookie_controller;

# ---------

$ENV{HTTP_COOKIE} = '';

$cookie_controller = WebFramework::Controller::CookiesIn::wrapper(
    sub {
        my ($request) = @_;
        
        is(scalar(keys(%{$request->{cookies}})), 0, 'Check no cookies.');
        
        return {};
    }
);

$cookie_controller->({});


# ---------

$ENV{HTTP_COOKIE} = 'alpha=1.0; beta=test%20phrase';

$cookie_controller = WebFramework::Controller::CookiesIn::wrapper(
    sub {
        my ($request) = @_;
        
        is($request->{cookies}->{alpha}, '1.0', 'Check alpha cookie present and its value.');
        is($request->{cookies}->{beta}, 'test phrase', 'Check beta cookie present and decodes properly.');
        
        return {};
    }
);

$cookie_controller->({});
