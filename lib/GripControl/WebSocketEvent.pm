package GripControl::WebSocketEvent;

use Moo;

has 'type' => (is => 'rw');
has 'content' => (is => 'rw');

no Moo;
1;