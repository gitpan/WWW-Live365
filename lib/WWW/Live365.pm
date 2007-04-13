package WWW::Live365;

use warnings;
use strict;

our $VERSION = '0.11';

use base qw(Exporter);
our @EXPORT = qw(get_stream_url change_stream_client_ip);

use WWW::Mechanize;

sub get_stream_url {
	my $stream = shift;

	print_form() unless $stream;

	my $mech = WWW::Mechanize->new;

	# Secret agent man, secret agent man
	# They've given you a number and taken away your name
	$mech->agent_alias('Windows IE 6');

	my $player_url = "http://www.live365.com/cgi-bin/mini.cgi?membername=$stream&site=live365&station_status=OK&isPro=N";

	my $response = $mech->get($player_url);

	die "Couldn't get player page for stream '$stream': " . $mech->status unless $mech->success;

	my $raw = $mech->content;

	my ($stationID)   = $raw =~ /var stationID\s+= "(.*?)"/;
	my ($token)       = $raw =~ /var token\s+= "(.*?)"/;
	my ($play_params) = $raw =~ /var play_params.*?auth=(.*?)&member/;

	my ($sid) = $mech->cookie_jar->as_string =~ /SaneID=(.*?);/;

	my $stream_url = "http://www.live365.com/play/$stationID?auth=$play_params&tag=live365&token=$token&sid=$sid&lid=eng-gbr&from=pls";

	$stream_url;
}

sub change_stream_client_ip {
	my ($stream_url, $ip) = @_;
	
	eval { require Regexp::Common; };
	
	unless ($@) {
        	use Regexp::Common qw(net);
        	die "'$ip' is not a valid IP address." unless $ip =~ /$RE{net}{IPv4}/;
	}
	
	$stream_url =~ s/sid=(.*?)-/sid=$ip-/;
	
	$stream_url;
}

1;

__END__

=head1 NAME

WWW::Live365 - get Live365.com audio stream URLs

=head1 DESCRIPTION

This module allows you to easily obtain the direct URL of a Live365.com MP3
stream to listen to it in your MP3 player instead being forced to go through
the popup player on their site (which tries to stop you listening to it if
you close the popup window).

=head1 SYNOPSIS

    use WWW::Live365;
    
    # I was listening to the ambient stream from zzzone.net while I wrote this module.
    my $stream_url = get_stream_url('doctorzz'); 
    
    change_stream_client_ip($stream_url, $my_ip_address);
    
=head1 METHODS

=head2 C<get_stream_url()>

    my $stream_url = get_stream_url('doctorzz');
    
Does what it says on the tin. This method has to retrieve a page from live365.com
in order to get some parameters, one of which is the IP address of the machine
requesting the page. They may check this against another one of the parameters,
which is a unique identifier, so you will probably want to run the stream URL
through the next method.

=head2 C<change_stream_client_ip()>

    my $fixed_stream_url = change_stream_client_ip($stream_url, '127.0.0.1');

This method alters the stream URL to appear as if it was requested from a certain
IP address, probably that of the machine your MP3 player is on. If you have
L<Regexp::Common> installed, this method will check your IP string is a valid IP
address, and die if it is not.

=head1 AUTHOR

Earle Martin <hex@cpan.org>

L<http://downlode.org/Code/Perl/>

=head1 COPYRIGHTS

Copyright 2007 Earle Martin. All rights reserved.

Live365.com is a trademark of Live365.com, Inc.

=head1 LICENSE

This module is free software and released under the same license as Perl itself.