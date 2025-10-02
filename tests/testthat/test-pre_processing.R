test_that("pre_processing correct output", {
  input_data <- data.frame(
    reference = c(101, 102, 103, 104),
    questioncode = c(11, 11, 11, 11),
    cell_no = c("100", "100", "200", "300"),
    period = c(202201, 202201, 202201, 202201),
    design_weight = c(1.1, 1.0 , 0.8, 0.9),
    calibration_factor = c(1, 1, 1, 1),
    adjustedresponse = c(100, 200, 300, 400),
    outlier_weight = c(1, 0.5, 1, 0.5),
    frotover = c(0, 100, 200, 300),
    stringsAsFactors = FALSE
  )

  population_counts <- data.frame(
    cell_no = c("100", "200", "300"),
    period = c(202201, 202201, 202201),
    count = c(2, 1, 1),
    stringsAsFactors = FALSE
  )

  output_data <- pre_process_data(input_data, population_counts)

  # Unit test will fail if period and cell not string, not sure if this
  # is something to do with merge in function?
  expected_output <- data.frame(
    reference = c(101, 102, 103, 104),
    questioncode = c(11, 11, 11, 11),
    cell_no = c("100", "100", "200", "300"),
    period = c(202201, 202201, 202201, 202201),
    design_weight = c(1.1, 1.0 , 0.8, 0.9),
    calibration_factor = c(1, 1, 1, 1),
    adjustedresponse = c(100, 200, 300, 400),
    outlier_weight = c(1, 0.5, 1, 0.5),
    frotover = c(0, 100, 200, 300),
    extcalweights = c(1.1, 1.0, 0.8, 0.9),
    winsorised_value = c(0.000100, 0.000100, 0.000300, 0.000200),
    frotover_converted_for_regen = c(1e-6, 100, 200, 300),
    count = c(2, 2, 1, 1),
    stringsAsFactors = FALSE
  )

  # Reorder columns and ensure types match
  expected_output <- expected_output[, names(output_data)]
  for (col in names(output_data)) {
    if (is.factor(output_data[[col]])) {
      output_data[[col]] <- as.character(output_data[[col]])
    }
    if (is.factor(expected_output[[col]])) {
      expected_output[[col]] <- as.character(expected_output[[col]])
    }
  }

  expect_equal(output_data, expected_output)
})
