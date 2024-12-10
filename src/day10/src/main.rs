use std::fs::File;
use std::io::{self, BufRead};
use std::io::BufReader;

fn main() -> io::Result<()> {
    // Open the file for reading
    let file = File::open("input.sample.txt")?;
    let reader = BufReader::new(file);

    // Iterate through each line in the file
    for line in reader.lines() {
        let line = line?;  // Handle each line, returning an error if needed

        // Split the line into characters, and then parse each character as an integer
        let parsed_line: Vec<i32> = line.chars()  // Convert the line to characters
            .filter_map(|c| c.to_digit(10))   // Filter and map each character to a digit
            .map(|d| d as i32)  // Convert from u32 to i32
            .collect();  // Collect into a vector of integers

        // Print out the parsed line (sub-array of integers for each line)
        println!("{:?}", parsed_line);
    }

    Ok(())
}
