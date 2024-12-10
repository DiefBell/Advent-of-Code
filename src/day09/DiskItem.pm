package DiskItem;

sub new {
    my ($class, $size) = @_;
    my $self = { size => $size };
    bless $self, $class;
    return $self;
}

# Placeholder for to_array
sub to_array {
    die "to_array method must be implemented in subclass";
}

1;  # Return true at the end of the module
