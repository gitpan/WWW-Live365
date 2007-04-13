#!/usr/bin/perl

use warnings;
use strict;

use CGI;
use WWW::Live365;

my $q = CGI->new;

my $stream = $q->param('stream');
my $format = $q->param('format');

print_form() unless $stream;

my $stream_url = get_stream_url($stream);

# use client address, not CGI host
$stream_url = change_stream_client_ip($stream_url, $ENV{'REMOTE_ADDR'});

if ($format eq 'pls') {
	print <<"END_PLS";
Content-Type:application/x-download
Content-Disposition:attachment;filename=live365-$stream.pls

[playlist]
File1=$stream_url
Title1=$stream on Live365
Length1=-1
NumberOfEntries=1
Version=2
END_PLS

} elsif ($format eq 'm3u') {
	print <<"END_M3U";
Content-Type:application/x-download
Content-Disposition:attachment;filename=live365-$stream.m3u

#EXTM3U
#EXTINF:-1,$stream on Live365
$stream_url
END_M3U

} elsif ($format eq 'url') {
	start_html('Live365 Stream URL');
	print qq{<strong><a href="$stream_url">$stream on Live365</a></strong>\n};
	end_html();
}

# ---------------------------------------------------------------------------
# Script execution ends. Subroutines follow.
# ---------------------------------------------------------------------------

sub fail {
	my ($stream, $status) = @_;
	start_html('Scrape failed');

	print <<'END_HTML';
Couldn't get the stream "$stream": WWW::Mechanize said: $status.
END_HTML

	end_html();
	exit;
}

sub start_html {
	my $title = shift;

	print <<"END_HTML";
Content-Type: text/html

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
<title>$title</title>
</head>
<body>
<h1>$title</h1>
END_HTML

}

sub end_html {
	print "</body>\n</html>\n";
}

sub print_form {
	start_html('Live365 stream URL extractor');

	print <<'END_HTML';
<form action="" method="get">
<p>
Stream (Live365 member name): <input type="text" name="stream" size="30" /> <br />
Output format:
<input type="radio" name="format" value="pls" checked="checked" /> PLS file
<input type="radio" name="format" value="m3u" /> M3U file
<input type="radio" name="format" value="url" /> direct URL
<input type="submit" value="Go!" />
</p>
</form>
END_HTML

	end_html();
	exit;
}

__END__

=head1 NAME

live365.cgi - get Live365.com stream URLs and serve them as playlists

=head1 HOW TO USE

Put this script on a webserver. Chmod a+x or as appropriate. Open from your
browser. You'll be presented with a form. Enter a Live365 stream name and
choose whether you want to get a .PLS or .M3U playlist, or just a direct
link to the stream URL.

=head1 AUTHOR

Earle Martin <hex@cpan.org>

L<http://downlode.org/>

=head1 COPYRIGHTS AND LICENSE

Copyright 2007 Earle Martin. All rights reserved. This module is free software
and released under the same license as Perl itself. Live365.com is a trademark
of Live365.com, Inc.
