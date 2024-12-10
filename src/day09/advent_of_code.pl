#!/usr/bin/perl
use strict;
use warnings;

use lib '.';           # Add the current directory to @INC if necessary
use Disk;              # Disk class
use DiskFile;          # DiskFile class
use EmptySpace;        # EmptySpace class
use DiskItem;          # DiskItem class

use Time::HiRes qw(gettimeofday);

# File path
my $file_path = 'input.txt';
# my $file_path = 'input.sample.txt';

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

my $disk_string = $disk->to_string();
# print "Parsed disk: $disk_string\n";

# Define the part_one function, takes a more functional approach
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

    print "Part one checksum: $checksum\n";
}

# Part two, more object-oriented
sub part_two {
	my ($original_disk) = @_;
	my $disk = $original_disk->deep_copy();

	# Iterate while there are unmoved DiskFiles
	for (my $last_unmoved_index = $disk->get_last_unmoved_disk_file_index();
		$last_unmoved_index != -1;
		$last_unmoved_index = $disk->get_last_unmoved_disk_file_index()) {

		# Get the DiskFile at the last unmoved index
		my $last_unmoved_disk_file = $disk->{items}[$last_unmoved_index];

		# Get the first empty space that fits before the last unmoved DiskFile
		my @empty_spaces = $disk->get_empty_spaces();
		my $first_empty_space_that_fits = undef;
		for my $i (0 .. $last_unmoved_index - 1) {
			my $item = $disk->{items}[$i];
			if($item->isa("DiskFile")) {
				next;
			}
			if($item->{size} >= $last_unmoved_disk_file->{size}) {
				$first_empty_space_that_fits = $item;
				last;
			}
		}

		# Overwrite the EmptySpace with the DiskFile
		$disk->overwrite($first_empty_space_that_fits, $last_unmoved_disk_file);

		# # Print the current state of the disk
		# my $disk_string = $disk->to_string();
		# print "The disk is: $disk_string\n";
	}

	my $checksum = $disk->checksum();
	print "Part two checksum: $checksum\n";
}


########## MAIN CODE ###########
my $start_time = gettimeofday();
part_one($disk);
my $end_time = gettimeofday();
my $duration = $end_time - $start_time;
print "Part one took $duration seconds to run.\n";

$start_time = gettimeofday();
part_two($disk);
$end_time = gettimeofday();
$duration = $end_time - $start_time;
print "Part two took $duration seconds to run.\n";
