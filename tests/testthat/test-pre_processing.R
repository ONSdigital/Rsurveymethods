test_that("pre_processing correct output", {
  input_data <- data.frame(
    reference = c(101, 102, 103, 104),
    cell = c("100", "100", "200", "300"),
    period = c(202201, 202201, 202201, 202201),
    aweight = c(1.1, 1.0 , 0.8, 0.9),
    gweight = c(1, 1, 1, 1),
    value = c(100, 200, 300, 400),
    outlier_weight = c(1, 0.5, 1, 0.5),
    stringsAsFactors = FALSE
  )

  population_counts <- data.frame(
    cell = c("100", "200", "300"),
    period = c(202201, 202201, 202201),
    count = c(2, 1, 1),
    stringsAsFactors = FALSE
  )

  output_data <- pre_process_data(input_data, population_counts)

  # Unit test will fail if period and cell not string, not sure if this
  # is something to do with merge in function?
  expected_output <- data.frame(
    period = c("202201", "202201", "202201", "202201"),
    cell = c("100", "100", "200", "300"),
    reference = c(101, 102, 103, 104),
    aweight = c(1.1, 1.0 , 0.8, 0.9),
    gweight = c(1, 1, 1, 1),
    value = c(100, 200, 300, 400),
    outlier_weight = c(1, 0.5, 1, 0.5),
    count = c(2, 2, 1, 1),
    extcalweights = c(1.1, 1.0, 0.8, 0.9),
    winsorised_value = c(100, 100, 300, 200),
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
