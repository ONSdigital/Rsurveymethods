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
  
  print("Pre processing completed")
  
  print("Running regenesses, contrasts are off to get dummy encoding of matrix")

  #Switch off so get dummy encoding of matrix
  
  contrasts.off()
  
  # split apply combine, regenesses_estimation must be applied to one period 
  # at a time
  split_by_period <- split(input_data_with_counts,input_data_with_counts$period)
  
  list_of_dfs <-lapply(split_by_period,regenesses_estimation)
  
  print("Combining estimates")
  estimates <- dplyr::bind_rows(list_of_dfs,.id = "period")
   
  print("Merging estimates to source dataframe")
  
  export_results(
    input_data_with_counts,
    estimates,
    PROCESSED_DATA_FILE
  )
  
  print("Process was succesful")
}

