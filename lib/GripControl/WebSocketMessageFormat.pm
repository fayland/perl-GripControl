package GripControl::WebSocketMessageFormat;

use Moo;
use Mojo::Util qw(b64_encode);

has 'content';
has 'binary' => (default => sub { 0 });

sub name { 'ws-message' }
sub export {
    my $self = shift;

    my %out;
    if ($self->binary) {
        $out{'content-bin'} = b64_encode($self->content);
    } else {
        $out{'content'} = $self->content;
    }

    return wantarray ? %out : \%out;
}

no Moo;
1;