#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 2;

BEGIN { use_ok('WebFramework::Controller', qw(controller)) };

# I don't want to repeat all the tests that are in the other 
# wrappers. Just make sure that the controller can actually
# load and run in the most basic sens.

my $env_controller = controller(
    sub {
        my ($request) = @_;

        ok(1, 'check the controller actually ran.');

        return {};
    }
);

push(@INC, File::Spec::Functions::catdir('t', 'Test-App', 'lib'));
my $request = {'controller' => 'Test::App::main'};
my $result;
$result = $env_controller->($request);
