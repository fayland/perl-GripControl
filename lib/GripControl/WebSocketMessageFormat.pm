package GripControl::WebSocketMessageFormat;

use Moo;
use MIME::Base64;

has 'content';
has 'binary' => (default => sub { 0 });

sub name { 'ws-message' }
sub export {
    my $self = shift;

    my %out;
    if ($self->binary) {
        $out{'content-bin'} = encode_base64($self->content);
    } else {
        $out{'content'} = $self->content;
    }

    return wantarray ? %out : \%out;
}

no Moo;
1;