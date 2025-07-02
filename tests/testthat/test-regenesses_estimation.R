test_that("regenesses_estimation correct output" , {
  input_data <- data.frame(
    period = c(202201, 202201, 202201, 202201),
    cell_no = factor(c("100", "100", "200", "300")),
    reference = c(101, 102, 103, 104),
    questioncode = c(10, 10, 11, 12),
    design_weight = c(1.1, 1.0 , 0.8, 0.9),
    calibration_factor = c(1, 1, 1, 1),
    adjustedresponse = c(100, 200, 300, 400),
    outlier_weight = c(1, 0.5, 1, 0.5),
    population_count = c(2, 2, 1, 1),
    extcalweights = c(1.1, 1.0, 0.8, 0.9),
    winsorised_value = c(100, 100, 300, 200),
    univcts = c(1, 1, 1, 1),
    turnover = c(0, 200, 300, 400),
    size_band = c("1-5", "1-5", "6-10", "1-5"),
    frotover_converted_for_regen = c(1e-6, 200, 300, 400),
    stringsAsFactors = FALSE
  )

  output <- regenesses_estimation(input_data)

  # Test output items has expected columns:
  expected_cols_total_estimates <- c("questioncode", "Total.winsorised_value", "SE.Total.winsorised_value", "CV.Total.winsorised_value") # example
  expect_true(all(expected_cols_total_estimates %in% colnames(output)))

  # Test output data frames  the correct number of rows
  # Should equal number of unique question numbers
  expect_true(nrow(output) == 3)


})
