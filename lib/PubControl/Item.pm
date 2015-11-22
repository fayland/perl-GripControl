package PubControl::Item;

use Moo;

has id => (is => 'rw');
has prev_id => (is => 'rw');
has formats => (is => 'rw', default => sub { [] });

sub export {
    my $self = shift;

    my @format_types;
    foreach my $format (@{$self->formats}) {
        my $format_class_name = ref $format;
        if (grep { $_ eq $format_class_name } @format_types) {
            croak "Multiple $format_class_name format classes specified";
        }
        push @format_types, $format;
    }

    my %out;
    if (defined $self->id) {
        $out{'id'} = $self->id;
    }
    if (defined $self->prev_id) {
        $out{'prev_id'} = $self->prev_id;
    }
    foreach my $format (@{$self->formats}) {
        $out{ $format->name } = $format->export;
    }
    return wantarray ? %out : \%out;
}

no Moo;
1;