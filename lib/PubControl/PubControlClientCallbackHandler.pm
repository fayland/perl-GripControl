package PubControl::PubControlClientCallbackHandler;

use Moo;

has 'num_calls' => (is => 'rw');
has 'callback' => (is => 'rw');
has 'success' => (is => 'rw', defualt => sub { 1 });
has 'first_error_message' => (is => 'rw');

sub handler {
    my ($self, $success, $message) = @_;

    if ($self->success and not $success) {
        $self->success($success);
        $self->first_error_message($message);
    }

    $self->num_calls( $self->num_calls - 1 );
    if ($self->num_calls <= 0) {
        $self->callback->($self->success, $self->first_error_message);
    }
}

no Moo;
1;