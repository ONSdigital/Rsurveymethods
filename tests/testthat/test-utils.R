df <- data.frame(
  questioncode = c(101, 102, 103, 104, 101, 102, 103, 104),
  period = c(202201, 202201, 202201, 202201, 202202, 202202, 202202, 202202),
  SE.Total.winsorised_value = c(1.5, 2.5, 3.5, 4.5, 1.0, 2.0, 3.0, 4.0),
  CV.Total.winsorised_value = c(0.1, 0.2, 0.3, 0.4, 0.1, 0.2, 0.3, 0.4),
  Total.winsorised_value = c(15, 25, 35, 45, 10, 20, 30, 40)
)


test_that("test format_se_for_publication formats file correctly (no period given)", {
  dir.create("temp")
  format_se_for_publication(df, "local", "temp")
  files <- list.files("temp")

  expect_setequal(files, c("standard_errors_formatted_for_publication_period_202202.csv"))

  # Read in the file and compare to expected
  df_actual <- read.csv(file.path("temp", "standard_errors_formatted_for_publication_period_202202.csv"))
  expect_true(all(df_actual$period == 202202))

  df_expected =
    data.frame(
      questioncode = c(101, 102, 103, 104),
      period = c(202202, 202202, 202202, 202202),
      std_error_p_thousands = c(1.0, 2.0, 3.0, 4.0),
      cov= c(0.1, 0.2, 0.3, 0.4),
      sample_var_p_thousands = c(10, 20, 30, 40)
    )
  expect_equal(df_actual, df_expected)

  unlink("temp", recursive = TRUE)
})


test_that("test format_se_for_publication formats file correctly period (period given) ", {
  dir.create("temp")
  format_se_for_publication(df, "local", "temp","202201")
  files <- list.files("temp")

  expect_setequal(files, c("standard_errors_formatted_for_publication_period_202201.csv"))

  # Read in the file and compare to expected
  df_actual <- read.csv(file.path("temp", "standard_errors_formatted_for_publication_period_202201.csv"))
  expect_true(all(df_actual$period == 202201))

  df_expected =
    data.frame(
      questioncode = c(101, 102, 103, 104),
      period = c(202201, 202201, 202201, 202201),
      std_error_p_thousands = c(1.5, 2.5, 3.5, 4.5),
      cov = c(0.1, 0.2, 0.3, 0.4),
      sample_var_p_thousands = c(15, 25, 35, 45)
    )
  expect_equal(df_actual, df_expected)

  unlink("temp", recursive = TRUE)
})
