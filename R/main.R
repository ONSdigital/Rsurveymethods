rm(list = ls())
# Load the functions
source("R/config.R")
source("R/input_functions.R")
source("R/pre_processing.R")
source("R/regenesses_estimation.R")
source("R/export_results.R")


# Main Function to run the project
main <- function(input_data_path, population_counts_path){

  # load the input data
  input_data <- read_input_data(input_data_path)
  population_counts <- read_input_data(population_counts_path)

  # pre-process the input data
  input_data_with_counts <- pre_process_data(input_data, population_counts)

  # todo: Placeholder for estimation
  estimates <- list(
    total_estimates = data.frame(
      winsorised_value = input_data_with_counts$winsorised_value,
      size_band = input_data_with_counts$size_band,
      question_no = input_data_with_counts$question_no
    ),
    size_band_estimates = data.frame(
      size_band = input_data_with_counts$size_band,
      question_no = input_data_with_counts$question_no
    )
  )

  export_results(
    input_data_with_counts,
    estimates,
    PROCESSED_DATA_FILE
  )
}

# call the main function
main(INPUT_DATA_FILE, POPULATION_COUNTS_FILE)
