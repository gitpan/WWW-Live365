#!/usr/bin/perl

use warnings;
use strict;

use Net::Ping;
use Test::More tests => 2;

use WWW::Live365;

my $reachable = Net::Ping->new('external')->ping('www.live365.com');

my $stream;

SKIP: {
	skip 'live365.com is unreachable, is there a connection?', 1 unless $reachable;
	eval { $stream = get_stream_url('doctorzz'); };
	is( $@, '', 'stream URL was received' );
}

eval {
	require Regexp::Common;
};

SKIP: {
	skip 'Regexp::Common not installed', 1 if $@;
	eval { $stream = change_stream_client_ip($stream, 'Fred'); };
	like( $@, qr/'Fred' is not a valid IP address/, 'invalid IP addresses detected' );
}
