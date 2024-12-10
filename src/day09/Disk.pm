# Disk.pm

package Disk;
use strict;
use warnings;

# Constructor
sub new {
    my ($class) = @_;
    my $self = {
        items => [],  # Array to hold items (DiskItems)
    };
    bless $self, $class;
    return $self;
}

# Add an item to the disk
sub add_item {
    my ($self, $item) = @_;
    push @{ $self->{items} }, $item;
}

# Method for getting all items as an array
sub to_array {
    my ($self) = @_;
    my @array;
    for my $item (@{$self->{items}}) {
        push @array, $item->to_array();
    }
    return @array;
}

# Method for getting all items as a single string
sub to_string {
    my ($self) = @_;
    my $string = "";
    for my $item (@{$self->{items}}) {
        $string .= $item->to_string();
    }
    return $string;
}

# Method to create a deep copy of the Disk
sub deep_copy {
    my ($self) = @_;
    my $new_disk = Disk->new();  # Create a new empty Disk object

    # Deep copy each item in the original disk
    for my $item (@{ $self->{items} }) {
        my $copied_item = $item->deep_copy();  # Assuming each item has a deep_copy method
        $new_disk->add_item($copied_item);
    }

    return $new_disk;
}

# Method to return all the EmptySpace items
sub get_empty_spaces {
    my ($self) = @_;
    my @empty_spaces = grep { $_->isa('EmptySpace') } @{$self->{items}};
    return @empty_spaces;
}

sub get_disk_files {
    my ($self) = @_;
    my @disk_files = grep { $_->isa('DiskFile') } @{$self->{items}};
    return @disk_files;
}

# Method to get the last unmoved DiskFile
sub get_last_unmoved_disk_file {
    my ($self) = @_;

    # Loop through the items in reverse order
    for (my $i = $#{$self->{items}}; $i >= 0; $i--) {
        my $item = $self->{items}[$i];

        # If the item is a DiskFile and is not moved, return it
        if (ref($item) eq 'DiskFile' && !$item->{moved}) {
            return $item;
        }
    }

    # If no unmoved DiskFile is found, return undef
    return undef;
}

# Method to overwrite EmptySpace with a DiskFile
sub overwrite {
    my ($self, $empty_space, $disk_file) = @_;

    # If EmptySpace is undef, flag the DiskFile as moved and exit
    if (!defined($empty_space)) {
        $disk_file->set_moved(1);
        return;
    }

    # Check if DiskFile's size is greater than EmptySpace's size
    if ($disk_file->{size} > $empty_space->{size}) {
        die "DiskFile size is greater than EmptySpace size!";
    }

    # Move the DiskFile to in front of the EmptySpace
    my $index = -1;
    my $empty_index = -1;
    for my $i (0 .. $#{$self->{items}}) {
        if ($self->{items}[$i] == $empty_space) {
            $empty_index = $i;
        }
        if ($self->{items}[$i] == $disk_file) {
            $index = $i;
        }
    }

    if ($index == -1 || $empty_index == -1) {
        die "DiskFile or EmptySpace not found in Disk!";
    }

    # Remove the DiskFile from its current position (if any) and add it before EmptySpace
    splice(@{$self->{items}}, $index, 1);
    splice(@{$self->{items}}, $empty_index, 0, $disk_file);

    # Decrease the EmptySpace's size by the DiskFile's size
    $empty_space->{size} -= $disk_file->{size};

    # If EmptySpace's size goes down to zero, remove it from @items
    if ($empty_space->{size} == 0) {
        splice(@{$self->{items}}, $empty_index, 1);
    }
}

sub checksum {
    my ($self) = @_;
    my $disk_position = 0;
    my $checksum = 0;

    # Iterate over each item in the @items array
    for my $item (@{$self->{items}}) {

        # If the item is a DiskFile, add its checksum to the total
        if ($item->isa('DiskFile')) {
            $checksum += $item->checksum($disk_position);
        }

        # Increment the disk position by the size of the DiskItem
        $disk_position += $item->get_size();
    }

    return $checksum;
}

1;
