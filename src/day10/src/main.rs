use std::fs::File;
use std::io::{self, BufRead};
use std::io::BufReader;

#[derive(Debug)]
struct Coord {
    x: usize,
    y: usize,
}

fn main() -> io::Result<()> {
    // Open the file for reading
    let file = File::open("input.sample.txt")?;
    let reader = BufReader::new(file);

    let mut array: Vec<Vec<i32>> = Vec::new();

    // Iterate through each line in the file
    for line in reader.lines() {
        let line = line?;  // Handle each line, returning an error if needed

        // Split the line into characters, and then parse each character as an integer
        let parsed_line: Vec<i32> = line.chars()  // Convert the line to characters
            .filter_map(|c| c.to_digit(10))   // Filter and map each character to a digit
            .map(|d| d as i32)  // Convert from u32 to i32
            .collect();  // Collect into a vector of integers

        // Add parsed line to the 2D array
        array.push(parsed_line);
    }

	let mut trailheads: Vec<Coord> = Vec::new();

    // Iterate over the 2D array
    for (y, row) in array.iter().enumerate() {
        for (x, &value) in row.iter().enumerate() {
            if value == 0 {
                trailheads.push(Coord { x, y });
            }
        }
    }

    // Print out the positions of the zeros
    println!("{:?}", trailheads);

    Ok(())
}
