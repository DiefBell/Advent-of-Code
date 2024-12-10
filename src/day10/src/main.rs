use std::collections::HashSet;
use std::fs::File;
use std::io::{self, BufRead};
use std::io::BufReader;

#[derive(Debug, Clone, Hash, PartialEq, Eq)]
struct Coord {
    x: usize,
    y: usize,
}

fn get_neighbours(coord: &Coord, array: &Vec<Vec<i32>>) -> Vec<Coord> {
    let mut neighbours = Vec::new();

    // Get the number of rows and columns in the 2D array
    let num_rows = array.len();
    let num_cols = array[0].len();

    // Check the coordinate above (y-1)
    if coord.y > 0 {
        neighbours.push(Coord { x: coord.x, y: coord.y - 1 });
    }

    // Check the coordinate below (y+1)
    if coord.y < num_rows - 1 {
        neighbours.push(Coord { x: coord.x, y: coord.y + 1 });
    }

    // Check the coordinate to the left (x-1)
    if coord.x > 0 {
        neighbours.push(Coord { x: coord.x - 1, y: coord.y });
    }

    // Check the coordinate to the right (x+1)
    if coord.x < num_cols - 1 {
        neighbours.push(Coord { x: coord.x + 1, y: coord.y });
    }

    neighbours
}

/**
 * Traverse the grid from the given coord.
 * Returns true if this coord eventually leads to a peak.
 * 
 * Any peaks found are stored in peaks_for_trailhead.
 */
fn traverse(
    coord: &Coord,
    grid: &Vec<Vec<i32>>,
    peaks_for_trailhead: &mut HashSet<Coord>  // Use mutable reference
) -> bool {
    let height = grid[coord.y][coord.x];
    if height >= 9 {
        // Insert without checking if it already exists
        peaks_for_trailhead.insert(coord.clone());
        return true;
    }

    // Get the neighbours of the current coordinate
    let neighbours = get_neighbours(coord, grid);

    // Filter the neighbours where their height is exactly one more than the current height
    let valid_neighbours: Vec<Coord> = neighbours.into_iter()
        .filter(|neighbour| grid[neighbour.y][neighbour.x] == height + 1)
        .collect();

    // Exit early if there are no valid neighbours
    if valid_neighbours.is_empty() {
        return false;
    }

	let mut peak_found = false;
    // Iterate over the valid neighbours, recursively traversing them
    for neighbour in valid_neighbours {
        // Call traverse without parentheses around the if condition
        if traverse(&neighbour, grid, peaks_for_trailhead) {
            peak_found = true;
        }
    }

    peak_found
}

fn main() -> io::Result<()> {
    // Open the file for reading
    // let file = File::open("input.sample.txt")?;
    let file = File::open("input.txt")?;
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

    // Find all trailheads (nodes with a height of 0)
    let mut trailheads: Vec<Coord> = Vec::new();

    // Iterate over the 2D array
    for (y, row) in array.iter().enumerate() {
        for (x, &value) in row.iter().enumerate() {
            if value == 0 {
                trailheads.push(Coord { x, y });
            }
        }
    }

	println!("Number of trailheads: {}", trailheads.len());

    let mut total_count = 0;
    
    // Iterate over the list of trailheads and process each one
    for coord in &trailheads {
		let mut peaks_for_trailhead: HashSet<Coord> = HashSet::new();
        traverse(coord, &array, &mut peaks_for_trailhead);
		total_count += peaks_for_trailhead.len();
    }

    println!("Total valid routes: {}", total_count);

    Ok(())
}
