#!/usr/bin/perl
use strict;
use warnings;

# File path
# my $file_path = 'input.sample.txt';
my $file_path = 'input.txt';

# Open the file
open(my $fh, '<', $file_path) or die "Cannot open file: $!";

# Read the first line
my $line = <$fh>;

# Close the file
close($fh);

# Remove any trailing newline or whitespace
chomp($line);

# Array to hold drive items
my @items;

# File index
my $file_index = 0;

# Iterate over every character in the string
for my $index (0 .. length($line) - 1) {
    my $char = substr($line, $index, 1);  # Get the character at position $index
    my $size = int($char);  # Convert the character to an integer
    
    # Use $file_index for even positions and undef for odd positions
    my $value = $index % 2 == 0 ? $file_index++ : undef;

    # Push $value into @items, $size times
    for(1..$size) {
        push @items, $value;
    }
}

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
