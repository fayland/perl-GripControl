use Test::More;
use Test::Exception;
use GripControl qw/decode_websocket_events encode_websocket_events/;
use GripControl::WebSocketEvent;

my @events = decode_websocket_events("OPEN\r\nTEXT 5\r\nHello" .
                "\r\nTEXT 0\r\n\r\nCLOSE\r\nTEXT\r\nCLOSE\r\n");
is scalar(@events), 6;
is $events[0]->type, 'OPEN';
is $events[0]->content, undef;
is $events[1]->type, 'TEXT';
is $events[1]->content, 'Hello';
is $events[2]->type, 'TEXT';
is $events[2]->content, '';
is $events[3]->type, 'CLOSE';
is $events[3]->content, undef;
is $events[4]->type, 'TEXT';
is $events[4]->content, undef;
is $events[5]->type, 'CLOSE';
is $events[5]->content, undef;

@events = decode_websocket_events("OPEN\r\n");
is @events, 1;
is $events[0]->type, 'OPEN';
is $events[0]->content, undef;

@events = decode_websocket_events("TEXT 5\r\nHello\r\n");
is @events, 1;
is $events[0]->type, 'TEXT';
is $events[0]->content, 'Hello';

throws_ok { decode_websocket_events("TEXT 5"); } qr/bad format/;
throws_ok { decode_websocket_events("OPEN\r\nTEXT"); } qr/bad format/;

# test encode_websocket_events as well
my $events = encode_websocket_events(
                GripControl::WebSocketEvent->new("TEXT", "Hello"),
                GripControl::WebSocketEvent->new("TEXT", ""),
                GripControl::WebSocketEvent->new("TEXT")
            );
is $events, "TEXT 5\r\nHello\r\nTEXT 0\r\n\r\nTEXT\r\n";
$events = encode_websocket_events(GripControl::WebSocketEvent->new("OPEN"));
is $events, "OPEN\r\n";

done_testing();