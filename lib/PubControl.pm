package PubControl;

use Moo;

has 'clients' => (is => 'rw', default => sub { [] });


sub add_client {
    my ($self, $client) = @_;

    my @clients = @{ $self->clients };
    push @clients, $client;
    $self->clients( [@clients] );
}

sub remove_all_clients {
    (shift)->clients([]);
}

sub publish {
    my ($self, $channel, $item) = @_;

    foreach my $client (@{ $self->clients }) {
        $client->publish($channel, $item);
    }
}

no Moo;
1;