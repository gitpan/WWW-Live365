#!/usr/bin/perl

use warnings;
use strict;

use Test::More tests => 1;

eval "use Test::Pod::Coverage";
plan skip_all => "Test::Pod::Coverage required for testing POD coverage" if $@;

pod_coverage_ok( 'WWW::Live365', 'POD coverage' );
