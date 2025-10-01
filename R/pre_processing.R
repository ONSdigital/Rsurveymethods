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


pre_process_data <- function(input_data, population_counts) {

  # # Ensure 'cell' and 'period' are factors for both data frames
  input_data$cell_no <- as.factor(input_data$cell_no)
  population_counts$cell_no <- as.factor(population_counts$cell_no)

  # replacing 0 with a small number, it will throw error if frotover is 0
  input_data["frotover_converted_for_regen"] <- input_data["frotover"]
  input_data[, "frotover_converted_for_regen"][input_data[, "frotover_converted_for_regen"] == 0] <- 1e-6


  input_data_with_counts <- merge(
    input_data,
    population_counts,
    by = c("period", "cell_no"),
    suffixes = c("", ""),
    all.x = TRUE
  )

  # Calculate extcalweights
  input_data_with_counts$extcalweights <-
    input_data_with_counts$design_weight *
    input_data_with_counts$calibration_factor

  # Calculate winsorised_value
  input_data_with_counts$winsorised_value <-
    input_data_with_counts$adjustedresponse *
    input_data_with_counts$outlier_weight

  print("converting winsorised_value into £000's")
  input_data_with_counts$winsorised_value = input_data_with_counts$winsorised_value / 1000


  return(input_data_with_counts)
}
