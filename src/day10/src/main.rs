use std::collections::HashSet;
use std::fs::File;
use std::io::{self, BufRead};
use std::io::BufReader;

#[derive(Debug, Hash, Eq, PartialEq, Clone)]
struct Coord {
    x: usize,
    y: usize,
}

fn get_neighbours(coord: &Coord, array: &Vec<Vec<i32>>) -> Vec<Coord> {
    let mut neighbors = Vec::new();

    // Get the number of rows and columns in the 2D array
    let num_rows = array.len();
    let num_cols = array[0].len();

    // Check the coordinate above (y-1)
    if coord.y > 0 {
        neighbors.push(Coord { x: coord.x, y: coord.y - 1 });
    }

    // Check the coordinate below (y+1)
    if coord.y < num_rows - 1 {
        neighbors.push(Coord { x: coord.x, y: coord.y + 1 });
    }

    // Check the coordinate to the left (x-1)
    if coord.x > 0 {
        neighbors.push(Coord { x: coord.x - 1, y: coord.y });
    }

    // Check the coordinate to the right (x+1)
    if coord.x < num_cols - 1 {
        neighbors.push(Coord { x: coord.x + 1, y: coord.y });
    }

    neighbors
}

fn traverse(coord: &Coord, array: &Vec<Vec<i32>>, visited: &mut HashSet<Coord>) -> u32 {
    // Get the height of the current coordinate
    let height = array[coord.y][coord.x];
    
    // If we reached the height 9, return 1 to count this path
    if height >= 9 {
        return 1;
    }

    // Check if the coordinate has been visited, and if so, return 0 (don't count it again)
    if visited.contains(coord) {
        return 0;
    }

    // Mark the current coordinate as visited
    visited.insert(coord.clone());

    // Get the neighbors of the current coordinate
    let neighbors = get_neighbours(coord, array);

    // Filter the neighbors where their height is exactly one more than the current height
    let valid_neighbours: Vec<Coord> = neighbors.into_iter()
        .filter(|neighbor| array[neighbor.y][neighbor.x] == height + 1)
        .collect();

    // Exit early if there are no valid neighbors
    if valid_neighbours.is_empty() {
        return 0;
    }

    // Initialize the count
    let mut count = 0;

    // Iterate over the valid neighbors, recursively traversing them
    for neighbor in valid_neighbours {
        // Recurse and add the result to the count
        count += traverse(&neighbor, array, visited);
    }

    count    
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

    // Iterate over the 2D array to find the trailheads (cells with height 0)
    for (y, row) in array.iter().enumerate() {
        for (x, &value) in row.iter().enumerate() {
            if value == 0 {
                trailheads.push(Coord { x, y });
            }
        }
    }

    let mut total_count = 0;

    // Iterate over the list of zero positions and count the valid routes
    for coord in &trailheads {
        let mut visited = HashSet::new(); // Reset visited for each trailhead
        total_count += traverse(coord, &array, &mut visited);
    }

    println!("Number of valid routes: {}", total_count);

    Ok(())
}
