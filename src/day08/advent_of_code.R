input_file <- "input.txt"
# input_file <- "input.sample.txt"
lines <- readLines(input_file)

height <- length(lines)
width <- nchar(lines[1])

# Split lines by spaces
split_lines <- strsplit(lines, " ")

# Flatten the list of split lines into a single character vector
all_words <- unlist(split_lines)

# Concatenate all words back into a single string
input_string <- paste(all_words, collapse = "")

# Initialize an empty list to store antenna locations
antenna_locations <- list()

# Loop through the string to find digits and letters
for (i in 1:nchar(input_string)) {
  char <- substr(input_string, i, i)  # Get each character
  
  # Check if the character is a digit or letter
  if (grepl("[0-9A-Za-z]", char)) {
    if (!char %in% names(antenna_locations)) {
      antenna_locations[[char]] <- integer(0)  # Initialize an empty vector
    }
    antenna_locations[[char]] <- c(antenna_locations[[char]], i)
  }
}

# Function to convert 1D index to 2D coordinates
index_to_coords <- function(index, width) {
  y <- ceiling(index / width)  # Row (y) is based on index divided by width
  x <- ((index - 1) %% width) + 1  # Column (x) is based on index mod width
  return(c(x, y))  # Return coordinates as (x, y)
}

# Function to check if extending the line goes off the edge
check_if_off_edge <- function(index1, index2, width, height) {
  coords1 <- index_to_coords(index1, width)
  coords2 <- index_to_coords(index2, width)

  # Calculate the distance in x and y directions
  dx <- coords2[1] - coords1[1]
  dy <- coords2[2] - coords1[2]
  
  # Extend the line by the same distance again
  extended_x <- coords2[1] + dx
  extended_y <- coords2[2] + dy
  
  # Check if the extended coordinates are out of bounds
  return(extended_x < 1 || extended_x > width || extended_y < 1 || extended_y > height)
}

# Initialize antinodes array
antinodes <- c()

# Iterate over each character's indices in antenna_locations
for (char in names(antenna_locations)) {
  indices <- antenna_locations[[char]]  # Get indices for the current character

  # Generate all pairs of indices
  index_pairs <- combn(indices, 2)
  
  # Process each index pair
  for (i in 1:ncol(index_pairs)) {
    pair <- index_pairs[, i]

    # Calculate new indices for the extensions
    index_up <- (2 * pair[2]) - pair[1]
    index_down <- (2 * pair[1]) - pair[2]

    # Check if upward extension goes off the edge
    if (!check_if_off_edge(pair[1], pair[2], width, height) && index_up > 0) {
      antinodes <- c(antinodes, index_up)  # Add positive index
    }

    # Check if downward extension goes off the edge
    if (!check_if_off_edge(pair[2], pair[1], width, height) && index_down > 0) {
      antinodes <- c(antinodes, index_down)  # Add positive index
    }
  }
}

# Print the length of unique antinodes
cat("\nNumber of unique antinode locations:", length(unique(antinodes)), "\n")
