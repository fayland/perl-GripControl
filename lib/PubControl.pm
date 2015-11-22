package PubControl;

use Moo;

has 'clients' => (is => 'rw', default => sub { [] });


no Moo;
1;