#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 8;
use Test::Exception;
use File::Spec::Functions ();

BEGIN { use_ok('WebFramework::Controller::TemplateOut', qw()) };

my $template_controller = WebFramework::Controller::TemplateOut::wrapper(
    sub {
        my ($request) = @_;
        
        return {
            'template' => 'hello.html.tt',
            'stash'    => {
                'name' => 'world',
            },
        };
    }
);

my $bad_extension_controller = WebFramework::Controller::TemplateOut::wrapper(
    sub {
        my ($request) = @_;
        
        return {
            'template' => 'hello.abcdeg.tt',
            'stash'    => {
                'name' => 'world',
            },
        };
    }
);

my $bad_extension_with_content_type_controller = WebFramework::Controller::TemplateOut::wrapper(
    sub {
        my ($request) = @_;
        
        return {
            'headers'  => {
                'Content-Type' => 'alpha/bet',  
            },
            'template' => 'hello.abcdefg.tt',
            'stash'    => {
                'name' => 'world',
            },
        };
    }
);

my $default_templates_path_controller = WebFramework::Controller::TemplateOut::wrapper(
    sub {
        my ($request) = @_;
        
        return {
            'template' => 'index.html.tt',
        };
    }
);


my $response;

$ENV{'TT.INCLUDE_PATH'} = File::Spec::Functions::catdir('t', 'files');

$response = $template_controller->({});
is($response->{body}, 'hello, world', 'A basic template response.');
is($response->{headers}->{'Content-Type'}, 'text/html; charset=utf-8', 'The Content-Type header was set.');
ok(!(defined($response->{template})), 'The template key was deleted.');
ok(!(defined($response->{stash})), 'The stash key was deleted.');

dies_ok(sub{$bad_extension_controller->({})}, 'controller that uses bad file extension dies.');

$response = $bad_extension_with_content_type_controller->({});
is($response->{body}, 'hello, world', 'specifying Content-Type header overcomes unknown file extension.');

delete($ENV{'TT.INCLUDE_PATH'});
push(@INC, File::Spec::Functions::catdir('t', 'Test-App', 'lib'));
$response = $default_templates_path_controller->({'controller' => 'Test::App::main'});
is($response->{body}, 'this is the index page', 'A template was found in the default templates directory.');
