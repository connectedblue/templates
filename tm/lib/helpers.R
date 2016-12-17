
# Function to sample a text file dataset and read in a subset of lines
# returns the subset
# slect_pcent is the percentage of the overall file size to sample (won't be exact - this is fed into
# the rbinom function to determine a coin flip distribution)

sample_file <- function(full_dataset, select_pcent) {
        
        # read full_dataset
        full_data <- readLines(full_dataset)
        
        file_lines <- length(full_data)
        
        lines_to_extract <- rbinom(n=file_lines, size=1, prob=select_pcent)
        extract_indexes <- which(lines_to_extract %in% 1)
        
        output<- full_data[extract_indexes]
        
        
        output
} 

# Function to remove testing files from current testing set
# if we want to force a re-generation next time load.project
# is run (maybe because new training data is added or the
# sample percent has changed).  
#
# This is to be run manually when needed

reset_testing <- function () {
        unlink(config$testing_dir, recursive = TRUE)
}

