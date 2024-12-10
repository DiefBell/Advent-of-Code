#!/usr/bin/perl
use strict;
use warnings;

use lib '.';           # Add the current directory to @INC if necessary
use Disk;              # Disk class
use DiskFile;          # DiskFile class
use EmptySpace;        # EmptySpace class
use DiskItem;          # DiskItem class

# File path
my $file_path = 'input.txt';

# Open the file
open(my $fh, '<', $file_path) or die "Cannot open file: $!";

# Read the first line
my $line = <$fh>;

# Close the file
close($fh);

# Remove any trailing newline or whitespace
chomp($line);

# Create a Disk object
my $disk = Disk->new();

# File index counter
my $file_index = 0;

# Parse the input string and populate the Disk
for my $index (0 .. length($line) - 1) {
    my $char = substr($line, $index, 1);
    my $size = int($char);

    if ($index % 2 == 0) {
        $disk->add_item(DiskFile->new($size, $file_index++));
    } else {
        $disk->add_item(EmptySpace->new($size));
    }
}

# Call the part_one function to process the disk and calculate the checksum
part_one($disk);

# Define the part_one function
sub part_one {
    my ($disk) = @_;

    my @items = $disk->to_array();

    my $start_index = 0;
    my $end_index = $#items;  # $#items gives the last index

    while ($start_index < $end_index) {
        my $start = $items[$start_index];
        my $end = $items[$end_index];

        if(defined($start)) {
            $start_index++;
            next;
        }
        if(!defined($end)) {
            $end_index--;
            next;
        }
        $items[$start_index] = $end;
        $items[$end_index] = undef;
        $start_index++;
        $end_index--;
    }

    my $checksum = 0;  # Initialize the total sum

    # Iterate over the array, stopping when we encounter 'undef'
    for my $index (0 .. $#items) {
        # If we encounter 'undef', exit the loop
        last if !defined($items[$index]);

        # Multiply the value at the index by the index and add it to the total
        $checksum += $items[$index] * $index;
    }

    print "Total sum: $checksum\n";
}
