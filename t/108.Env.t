#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 7;
use Test::Exception;
use Config;
use File::Spec::Functions qw(catdir);

BEGIN { use_ok('WebFramework::Controller::Env', qw()) };

my $env_controller = WebFramework::Controller::Env::wrapper(
    sub {
        my ($request) = @_;

        is($ENV{DEPLOYMENT}, 'development', 'check a default configuration parameter.');
        is($ENV{AN_APP_ENV_PARAM}, 'an app env param', 'check an app environment parameter.');
        is($ENV{A_DEVELOPMENT_PARAM}, 'a development param', 'check an app development environment parameter.');
        is($ENV{AN_EXTRA_PARAM}, 'the final value', 'check an extra environment parameter.');
        is($ENV{TOP_PARAM}, 'asdf', 'that previous environment parameters make it through.');

        return {};
    }
);

push(@INC, File::Spec::Functions::catdir('t', 'Test-App', 'lib'));
my $request = {'controller' => 'Test::App::main'};
my $result;

$ENV{DEPLOYMENT} = 'asdf';
dies_ok(sub{$env_controller->($request)}, 'bad DEPLOYMENT value should cause error because deployment config will not be found.');
delete($ENV{DEPLOYMENT});

$ENV{TOP_PARAM} = 'asdf';
$ENV{ENV_FILES} = catdir('t', 'files', 'extra_config_2.pl') . $Config{path_sep} . catdir('t', 'files', 'extra_config_1.pl');
$result = $env_controller->($request);
delete($ENV{TOP_PARAM});
delete($ENV{ENV_FILES});
