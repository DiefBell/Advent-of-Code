# Step 1: Read the file
# input_file <- "input.txt"
input_file <- "input.sample.txt"
lines <- readLines(input_file)

height -> length(lines)
width -> length(lines[1])

# Step 2: Split lines by spaces
split_lines <- strsplit(lines, " ")

# Step 3: Flatten the list of split lines into a single character vector
all_words <- unlist(split_lines)

# Step 4: Concatenate all words back into a single string
input_string <- paste(all_words, collapse = "")

# Initialize an empty list (dictionary)
antenna_locations <- list()

# Loop through the string to find digits and letters
for (i in 1:nchar(input_string)) {
  char <- substr(input_string, i, i)  # Get each character
  
  # Check if the character is a digit or letter
  if (grepl("[0-9A-Za-z]", char)) {
    # If the key doesn't exist in the dictionary, create an empty vector for it
    if (!char %in% names(antenna_locations)) {
      antenna_locations[[char]] <- integer(0)  # Initialize an empty integer vector
    }
    # Append the current index (i) to the vector for this character
    antenna_locations[[char]] <- c(antenna_locations[[char]], i)
  }
}

# Print the result
print(antenna_locations)