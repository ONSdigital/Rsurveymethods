library(ReGenesees)

#' Perform domain estimation using calibrated survey design
#'
#' @param input_data_with_counts Data frame with pre-processed survey data
#' @return A list with total and size-band estimates
#' @import ReGenesees

regenesses_estimation <- function(input_data_with_counts) {

  print(paste("Running regenesses for period:", unique(input_data_with_counts$period)))

  input_data_with_counts$cell_no <- droplevels(input_data_with_counts$cell_no)

  # sigma2 needs to have only positive values, using frotover_converted_for_regen
  # we replaced 0s with a very small number

  caldesign <- ext.calibrated(
    ids = ~reference,
    weights = ~design_weight,
    strata = ~cell_no,
    fpc = ~population_count,
    data = input_data_with_counts,
    weights.cal = ~extcalweights,
    calmodel = ~(frotover_converted_for_regen:cell_no) - 1,
    sigma2 = ~frotover_converted_for_regen
  )

  # Calculate estimates, SEs, and CVs of Totals at overall and size-band level
  New_Total_estimates <- svystatTM(
    caldesign,
    ~winsorised_value,
    estimator = 'Total',
    vartype = c('se', 'cv'),
    by = ~questioncode
  )

  return(New_Total_estimates)
}