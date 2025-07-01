#' Pre-process survey input data by merging with population counts and
#' calculating derived variables.
#'
#' @param input_data Data frame with survey input data. Must contain columns:
#'   period, cell, aweight, gweight, value, outlier_weight.
#' @param population_counts Data frame with population counts. Must contain
#'   columns: period, cell.
#'
#' @return Data frame with merged data and new columns: extcalweights,
#'   winsorised_value.
#'
#' @examples
#' # input_data <- read.csv("artifact/input/input_regen_test_data.csv")
#' # population_counts <- read.csv("artifact/input/regen_population_counts_test.csv")
#' # processed <- pre_process_data(input_data, population_counts)
#'
#' @export
pre_process_data <- function(input_data, population_counts) {

  # # Ensure 'cell' and 'period' are factors for both data frames
  input_data$cell <- as.factor(input_data$cell)
  input_data$period <- as.factor(input_data$period)
  population_counts$cell <- as.factor(population_counts$cell)
  population_counts$period <- as.factor(population_counts$period)

  input_data_with_counts <- merge(
    input_data,
    population_counts,
    by = c("period", "cell"),
    suffixes = c("", ""),
    all.x = TRUE
  )

  # Calculate extcalweights
  input_data_with_counts$extcalweights <-
    input_data_with_counts$aweight *
    input_data_with_counts$gweight

  # Calculate winsorised_value
  input_data_with_counts$winsorised_value <-
    input_data_with_counts$value *
    input_data_with_counts$outlier_weight

  return(input_data_with_counts)
}
