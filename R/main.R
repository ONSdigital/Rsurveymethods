main <- function(config_path) {
  config <- jsonlite::fromJSON(config_path)

  run_id <- readLines(config$run_id_path, warn = FALSE)
  formatted_input_data_path <- format_file_name(config$input_data_path, run_id)
  formatted_population_counts_path <- format_file_name(config$population_counts_path, run_id)

  run_regenesess(
    storage_system = config$storage_system,
    input_data_path = formatted_input_data_path,
    population_counts_path = formatted_population_counts_path,
    output_path = config$output_path,
    selected_period = config$selected_period,
    run_id = run_id,
    debug_mode = config$debug_mode
  )
}

format_file_name <- function(file_name, run_id) {
  file_name <- paste0(file_name, "_", run_id, ".csv")
  return(file_name)
}

#' Main Function to run the project
#'
#' @param storage_system accepts local or s3
#' @param input_data_path file path of main dataframe
#' @param population_counts_path file path of population counts
#' @param output_path file path to save results
#' @param selected_period optional, if provided only that period will be processed YYYYMM format
#'
#' @export
run_regenesess <- function(storage_system = c("network", "s3"),input_data_path, population_counts_path, output_path, run_id, debug_mode, selected_period=""){
  storage_system <- match.arg(storage_system)
  # load the input data
  input_data <-read_csv_wrapper(storage_system,input_data_path)
  if (selected_period != "") {
    # Filter input data if a given period is provided, otherwise run all periods.
    input_data <- input_data[input_data$period == selected_period,]
  }
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

  split_by_period_qnumber <- split(input_data_with_counts, list(input_data_with_counts$period, input_data_with_counts$questioncode))


  print("Combining estimates")
  estimates <- dplyr::bind_rows(list_of_dfs,.id = "period")
  formatted_df = format_se_for_publication(estimates, selected_period)
  print("Standard errors formatted for publication")

  filename <- paste0("standard_errors_publication_period_", selected_period, "_", run_id, ".csv")
  write_csv_wrapper(formatted_df, storage_system, output_path, filename)
  print("Standard errors saved")


  if (debug_mode) {
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
}
