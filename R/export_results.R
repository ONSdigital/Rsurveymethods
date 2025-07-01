#' Export merged survey results to CSV
#'
#' @param input_data_with_counts Data frame with pre-processed survey data
#' @param size_band_estimates Data frame with size-band level estimates
#' @param output_file Path to output CSV file
#' @usage NULL
#' @return None. Writes merged data to CSV.
#'

export_results <- function(input_data_with_counts, estimates, output_file) {

  # Extract directory from the output file path
  outdir <- dirname(output_file)

  # Create directory if it doesn't exist
  if (!dir.exists(outdir)) {
    dir.create(outdir, recursive = TRUE)
  }

  output_df <- merge(
    input_data_with_counts,
    estimates,
    by = c("period", "questioncode")
  )

  write.csv(output_df, output_file, row.names = FALSE)
  
}
