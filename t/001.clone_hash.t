#!/usr/bin/env perl

use strict;
use warnings;

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Foo-Bar.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 5;
BEGIN { use_ok('WebFramework::Utils::Hash', qw(clone_hash)) };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $key = 'a';
my $extra_key = 'b';
my $original_value = 1;
my $new_value = 2;
my $extra_value = 3;

my $alpha = {$key => $original_value};
my $beta = clone_hash($alpha);
$beta->{$key} = $new_value;
$alpha->{$extra_key} = $extra_value;

is($alpha->{$key}, $original_value, 'The value in the original hash changed.');
is($beta->{$key}, $new_value, 'The value in the cloned hash did not change.');
is($alpha->{$extra_key}, $extra_value, 'The value in the original hash was not set.');
is($beta->{$extra_key}, undef, 'The value in the cloned hash was set.');
