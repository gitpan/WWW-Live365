#!/usr/bin/perl

use warnings;
use strict;

use Net::Ping;
use Test::More tests => 3;

use WWW::Live365;

my $reachable = Net::Ping->new('external')->ping('www.live365.com');

my $stream;

SKIP: {
	skip 'live365.com is unreachable, is there a connection?', 1 unless $reachable;
	eval { $stream = get_stream_url('doctorzz'); };
	is( $@, '', 'construct stream URL' );
}

eval "require Regexp::Common";

SKIP: {
	skip 'Regexp::Common not installed', 1 if $@;
	eval { $stream = change_stream_client_ip($stream, 'Fred'); };
	like( $@, qr/'Fred' is not a valid IP address/, 'detect invalid IP address' );
}
	
eval "use Test::Without::Module qw(Regexp::Common)";
eval { $stream = change_stream_client_ip($stream, 'Fred'); };
unlike( $@, qr/'Fred' is not a valid IP address/, "don't check IP validity without Regexp::Common" );
