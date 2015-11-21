package GripControl::GripControl;

use base 'Exporter';
our @EXPORT_OK = qw/decode_websocket_events/;

use Carp qw/croak/;
use GripControl::WebSocketEvent;

sub decode_websocket_events {
    my ($body) = @_;

    my @out;
    my $start = 0;
    while ($start < length($body)) {
        my $at = index($body, "\r\n", $start);
        if ($at == -1) {
            croak 'bad format';
        }
        my $typeline = substr($body, $start, $at - $start);
        $start = $at + 2;
        $at = index($typeline, ' ');
        if ($at == -1) {
            push @out, GripControl::WebSocketEvent->new(type => $typeline);
        } else {
            my $etype = substr($typeline, 0, $at);
            my $clen = eval('0x' . substr($typeline, $at + 1));
            my $content = substr($body, $start, $clen);
            $start += $clen + 2;
            push @out, GripControl::WebSocketEvent->new(
                type => $etype,
                content => $content
            );
        }
    }

    return @out;
}

no Moo;
1;