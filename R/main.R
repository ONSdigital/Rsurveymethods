#' Main Function to run the project
#'
#' @param storage_system accepts local or s3
#' @param input_data_path file path of main dataframe
#' @param population_counts_path file path of population counts
#' @param output_path file path to save results
#'
#' @export
main <- function(storage_system,input_data_path, population_counts_path, output_path){

  check_storage_system_arg(storage_system)

  # load the input data
  input_data <-read_csv_wrapper(storage_system,input_data_path)
  population_counts <- read_csv_wrapper(storage_system,population_counts_path)

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


  output_df <- merge(
  input_data_with_counts,
  estimates,
  by = c("period", "questioncode")
)

  file_name <- create_rsurveymethods_file_name(input_data_path)

  write_csv_wrapper(output_df,storage_system,output_path,file_name)
  print("Process was succesful")
}

