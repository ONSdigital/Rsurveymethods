test_that("export_results writes merged data to CSV correctly", {
  # 1. Create mock input_data_with_counts data frame
  input_data_with_counts <- data.frame(
    question_no = 1:3,
    size_band = c("A", "B", "C"),
    count = c(10, 20, 30),
    stringsAsFactors = FALSE
  )

  # 2. Create mock size_band_estimates list with total_estimates data frame
  size_band_estimates <- list(
    total_estimates = data.frame(
      question_no = 1:3,
      size_band = c("A", "B", "C"),
      estimate = c(100, 200, 300),
      stringsAsFactors = FALSE
    )
  )

  # create temp file for output
  output_file <- tempfile(fileext = ".csv")

  # run function
  export_results(input_data_with_counts, size_band_estimates, output_file)

  # create expected output
  output_data <- read.csv(output_file, stringsAsFactors = FALSE)
  expected_output <- data.frame(
    size_band = c("A", "B", "C"),
    question_no = 1:3,
    count = c(10, 20, 30),
    estimate = c(100, 200, 300),
    stringsAsFactors = FALSE
  )

  # test output and expected match
  expect_equal(output_data, expected_output)

  # remove temp file
  unlink(output_file)
})
