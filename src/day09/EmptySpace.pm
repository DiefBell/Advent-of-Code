# EmptySpace.pm

package EmptySpace;
use strict;
use warnings;
use parent 'DiskItem';  # This sets DiskItem as the parent class

# Constructor
sub new {
    my ($class, $size) = @_;
    
    # Call the parent class's constructor using SUPER::new
    my $self = $class->SUPER::new($size);  # Call the parent constructor
        
    # Return the object
    return $self;
}

# Deep copy method
sub deep_copy {
    my ($self) = @_;
    return EmptySpace->new($self->{size});
}

# Method for converting to array
sub to_array {
    my ($self) = @_;
    return (undef) x $self->{size};  # Return undef `size` times
}

# Method for converting to string
sub to_string {
    my ($self) = @_;
    return '.' x $self->{size};  # Return `size` many "."
}

# Method to resize the EmptySpace
sub resize {
    my ($self, $new_size) = @_;
    $self->{size} = $new_size;  # Change the size to the new value
}

1;
