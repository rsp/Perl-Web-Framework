#!/usr/bin/env perl

use strict;
use warnings;

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Foo-Bar.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 4;
BEGIN { use_ok('WebFramework::Utils::String', qw()) };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

is(WebFramework::Utils::String::guarantee_header_case('accEPT'), 'Accept', 'can fix header case.');
is(WebFramework::Utils::String::guarantee_header_case('content-tYpe'), 'Content-Type', 'can fix header case.');
is(WebFramework::Utils::String::guarantee_header_case('some-long-NAME-header'), 'Some-Long-Name-Header', 'can fix header case.');
