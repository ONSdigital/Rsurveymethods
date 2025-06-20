#' Perform domain estimation using calibrated survey design
#'
#' @param input_data_with_counts Data frame with pre-processed survey data
#' @return A list with total and size-band estimates
#' @import ReGenesees
#' @export
#'
# Load package

library(ReGenesees)

regenesses_estimation <- function(input_data_with_counts) {
  # Ensure factors
  input_data_with_counts$cell <- as.factor(input_data_with_counts$cell)
  input_data_with_counts$calibration_group <- input_data_with_counts$cell

  print(input_data_with_counts)

  # Switch off contrasts for dummy encoding
  contrasts.off()

  # Set up the calibration object
  caldesign <- ext.calibrated(
    ids = ~ruref,
    weights = ~aweight,
    strata = ~cell,
    fpc = ~univcts,
    data = input_data_with_counts,
    weights.cal = ~extcalweights,
    calmodel = ~(turnover:calibration_group) - 1,
    sigma2 = ~turnover
  )

  # Calculate estimates, SEs, and CVs of Totals at overall and size-band level
  New_Total_estimates <- svystatTM(
    caldesign,
    ~winsorised_value,
    estimator = 'Total',
    vartype = c('se', 'cv'),
    by = ~question_no + period
  )

  New_Sizeb_estimates <- svystatTM(
    caldesign,
    ~winsorised_value,
    estimator = 'Total',
    vartype = c('se', 'cv'),
    by = ~size_band + question_no + period
  )

  return(list(
    total_estimates = New_Total_estimates,
    size_band_estimates = New_Sizeb_estimates
  ))
}
