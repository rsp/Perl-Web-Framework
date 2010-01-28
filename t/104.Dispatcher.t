#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 5;

BEGIN { use_ok('WebFramework::Dispatcher', qw(dispatcher)) };

# ---------

my $some_where_controller_body = 'some_where_controller responding';
my $some_where_else_controller_body = 'some_where_else_controller responding';
my $catch_all_controller_body = 'catch_all_controller responding';

my $some_where_controller = sub {
    
    return {
        body => $some_where_controller_body,
    };
};

my $some_where_else_controller = sub {
    
    return {
        body => $some_where_else_controller_body,
    };
};

my $catch_all_controller = sub {
    
    return {
        body => $catch_all_controller_body,
    };
};

my $main = WebFramework::Dispatcher::dispatcher([
    {'method' => qr{GET}  , 'path' => qr{^/some-where$}      , 'controller' => $some_where_controller      },
    {'method' => qr{POST} , 'path' => qr{^/some-where-else$} , 'controller' => $some_where_else_controller },
    {                                                          'controller' => $catch_all_controller       },
]);

# ----------

my $response;

$ENV{REQUEST_METHOD} = 'GET';
$ENV{PATH_INFO} = '/some-where';
$response = $main->({});
is($response->{body}, $some_where_controller_body, 'some_where_controller called.');

$ENV{REQUEST_METHOD} = 'POST';
$ENV{PATH_INFO} = '/some-where-else';
$response = $main->({});
is($response->{body}, $some_where_else_controller_body, 'some_where_else_controller called.');

$ENV{REQUEST_METHOD} = 'POST';
$ENV{PATH_INFO} = '/some-where';
$response = $main->({});
is($response->{body}, $catch_all_controller_body, 'catch_all_controller called.');

$ENV{REQUEST_METHOD} = 'GET';
$ENV{PATH_INFO} = '/some-where-else';
$response = $main->({});
is($response->{body}, $catch_all_controller_body, 'catch_all_controller called.');
