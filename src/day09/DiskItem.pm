# DiskItem.pm
package DiskItem;

use strict;
use warnings;

sub new {
    my ($class, $size) = @_;
    my $self = {
        size => $size,
    };
    bless $self, $class;
    return $self;
}

sub get_size {
    my ($self) = @_;
    return $self->{size};  # Return the size, it can be overridden in subclasses
}

# Method for converting to array
sub to_array {
    my ($self) = @_;
    die "Method 'to_array' must be implemented in the subclass.";
}

# Method for converting to string
sub to_string {
    my ($self) = @_;
    die "Method 'to_string' must be implemented in the subclass.";
}

# Abstract deep_copy method that should be overridden by subclasses
sub deep_copy {
    die "Method 'deep_copy' must be implemented in the subclass.";
}

1;
