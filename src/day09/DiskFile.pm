# DiskFile.pm

package DiskFile;
use strict;
use warnings;
use parent 'DiskItem';  # This sets DiskItem as the parent class

# Constructor
sub new {
    my ($class, $size, $id) = @_;
    
    # Call the parent class's constructor using SUPER::new
    my $self = $class->SUPER::new($size);  # Initialize size using DiskItem's constructor
    
    # Add additional attributes for DiskFile
    $self->{id} = $id;
    $self->{moved} = 0;  # Initialize moved flag
    
    # Return the object
    return $self;
}

# Deep copy method
sub deep_copy {
    my ($self) = @_;
    return DiskFile->new($self->{size}, $self->{id});
}

# Method to sort DiskFiles by their ID in descending order
sub get_sorted_disk_files {
    my ($self) = @_;
    
    # Get all the DiskFiles
    my @disk_files = $self->get_disk_files();
    
    # Sort by 'id' in descending order
    my @sorted_disk_files = sort { $b->{id} <=> $a->{id} } @disk_files;
    
    return @sorted_disk_files;
}

# Method for converting to array
sub to_array {
    my ($self) = @_;
    return ($self->{id}) x $self->{size};  # Repeat ID `size` times
}

# Method for converting to string
sub to_string {
    my ($self) = @_;
    return ($self->{id}) x $self->{size};  # Repeat ID `size` times as string
}

# Method to get the 'moved' flag
sub moved {
    my ($self) = @_;
    return $self->{moved};  # Return the value of the 'moved' flag
}

# Method to set the 'moved' flag
sub set_moved {
    my ($self, $value) = @_;
    $self->{moved} = $value;  # Set the 'moved' flag to the given value
}

sub checksum {
    my ($self, $disk_position) = @_;
    my $checksum = 0;

    # Iterate over the size of the DiskFile
    for my $i (0 .. $self->{size} - 1) {
        # Increment checksum by DiskFile's ID * (disk_position + loop index)
        $checksum += $self->{id} * ($disk_position + $i);
    }

    return $checksum;
}

1;
