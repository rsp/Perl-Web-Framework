#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 8;
use Test::Exception;

BEGIN { use_ok('WebFramework::Controller::RedirectOut', qw()) };

my $permanent_status = 301;
my $temporary_status = 302;
my $redirect_path = '/some/path/location';

# used to check that the redirect wrapper will clobber anything 
# set by an inner wrapper.
sub other_wrapper {
    my ($inner_controller) = @_;
    
    return sub {
        my ($request) = @_;
      
        my $response = $inner_controller->($request);
        $response->{status} = '999 bad status';
        $response->{headers}->{Location} = '/the/wrong/place';
        return $response;
    };
}

my $permanent_controller = WebFramework::Controller::RedirectOut::wrapper(
    sub {
        my ($request) = @_;
        
        return {
            $permanent_status => $redirect_path,
        };
    }
);

my $temporary_controller = WebFramework::Controller::RedirectOut::wrapper(other_wrapper(
    sub {
        my ($request) = @_;
        
        return {
            $temporary_status => $redirect_path,
        };
    }
));

my $double_set_controller = WebFramework::Controller::RedirectOut::wrapper(
    sub {
        my ($request) = @_;
        
        return {
            $permanent_status => '/bad/path/permanent',
            $temporary_status => '/bad/path/temporary',
        };
    }
);

my $response;

$response = $permanent_controller->({});
like($response->{status}, qr{^$permanent_status ?}, 'The status was set.');
is($response->{headers}->{Location}, $redirect_path, 'The location header was set.');
ok(!exists($response->{$permanent_status}), 'The response property was deleted');

$response = $temporary_controller->({});
like($response->{status}, qr{^$temporary_status ?}, 'The status was set.');
is($response->{headers}->{Location}, $redirect_path, 'The location header was set.');
ok(!exists($response->{$temporary_status}), 'The response property was deleted');

dies_ok(sub{$double_set_controller->({})}, 'controller that sets two redirects is bad');
