package GripControl::WebSocketEvent;

use Moo;

has 'type' => (is => 'rw');
has 'content' => (is => 'rw');

sub BUILDARGS {
    my ( $class, @args ) = @_;

    if (@args == 1) { # only type
        unshift @args, 'type';
    } elsif (@args == 2 and not (grep { $args[0] eq $_ } ('type', 'content')) ) {
        @args = ('type', $args[0], 'content', $args[1]);
    }

    return { @args };
}

no Moo;
1;