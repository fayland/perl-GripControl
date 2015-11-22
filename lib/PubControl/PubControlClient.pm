package PubControl::PubControlClient;

use Moo;
use Mojo::Util qw(b64_encode);
use Mojo::JWT;

has uri => (is => 'rw');
has auth_basic_user => (is => 'rw');
has auth_basic_pass => (is => 'rw');
has auth_jwt_claim => (is => 'rw');
has auth_jwt_key => (is => 'rw');

sub BUILDARGS {
    my ( $class, @args ) = @_;

    if (@args == 1) { # only uri
        unshift @args, 'uri';
    }

    return { @args };
}

sub set_auth_basic {
    my ($self, $username, $password) = @_;

    $self->auth_basic_user($username);
    $self->auth_basic_pass($password);
}

sub set_auth_jwt {
    my ($self, $claim, $key) = @_;

    $self->auth_jwt_claim($claim);
    $self->auth_jwt_key($key);
}

sub publish {
    my ($self, $channel, $item) = @_;

    my %export = $item->export;
    $export{channel} = $channel;

}

sub _gen_auth_header {
    my $self = shift;

    if ($self->auth_basic_user) {
        return 'Basic ' . b64_encode($self->auth_basic_user . ':' . $self->auth_basic_user, '');
    } elsif ($self->auth_jwt_claim) {
        my $claim = $self->auth_jwt_claim;
        if (not exists $claim->{exp}) {
            $claim->{exp} = time() + 3600;
        }
        my $jwt = Mojo::JWT->new(claims => $claim, secret => $self->auth_jwt_key)->encode;
        return 'Bearer ' . $jwt;
    }
}


no Moo;
1;