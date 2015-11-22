package GripControl;

use base 'Exporter';
our @EXPORT_OK = qw/websocket_control_message decode_websocket_events encode_websocket_events/;

use Carp qw/croak/;
use JSON;
use GripControl::WebSocketEvent;

sub websocket_control_message {
    my $type = shift;
    my $args = shift || {};

    my %args = %$args;
    $args{type} = $type;
    return encode_json(\%args);
}

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
            push @out, GripControl::WebSocketEvent->new($typeline);
        } else {
            my $etype = substr($typeline, 0, $at);
            my $clen = eval('0x' . substr($typeline, $at + 1));
            my $content = substr($body, $start, $clen);
            $start += $clen + 2;
            push @out, GripControl::WebSocketEvent->new($etype, $content);
        }
    }

    return @out;
}

sub encode_websocket_events {
    my @events = @_;

    my $out = '';
    foreach my $event (@events) {
        if (defined($event->content)) {
            my $content_length = hex(length($event->content));
            $out .= $event->type . ' ' . $content_length . "\r\n" . $event->content . "\r\n";
        } else {
            $out .= $event->type . "\r\n";
        }
    }
    return $out;
}

no Moo;
1;