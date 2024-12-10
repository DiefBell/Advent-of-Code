package Disk;
sub new {
    my ($class) = @_;
    my $self = { items => [] };  # Array to hold DiskItems
    bless $self, $class;
    return $self;
}

sub add_item {
    my ($self, $item) = @_;
    push @{$self->{items}}, $item;  # Add DiskItem to the items array
}

sub to_array {
    my $self = shift;
    my @output;

    for my $item (@{$self->{items}}) {
        push @output, $item->to_array();  # Call to_array for each DiskItem
    }

    return @output;
}

1;
