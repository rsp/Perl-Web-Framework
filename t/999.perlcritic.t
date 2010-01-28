#!/usr/bin/env perl

use strict;
use warnings;

if (!require Test::Perl::Critic) {
    Test::More::plan(
        skip_all => "Test::Perl::Critic required for testing PBP compliance"
    );
}

use File::Spec::Functions ();
use Test::More;
plan skip_all => 'set TEST_PERLCRITIC to enable this test' unless $ENV{TEST_PERLCRITIC};

my $rcfile = File::Spec::Functions::catfile( 't', 'perlcriticrc' );
print($rcfile."\n");
Test::Perl::Critic->import( -profile => $rcfile );
Test::Perl::Critic::all_critic_ok();
