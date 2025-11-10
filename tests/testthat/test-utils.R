df <- data.frame(
  questioncode = c(101, 102, 103, 104, 101, 102, 103, 104),
  period = c(202201, 202201, 202201, 202201, 202202, 202202, 202202, 202202),
  SE.Total.winsorised_value = c(1.5, 2.5, 3.5, 4.5, 1.0, 2.0, 3.0, 4.0),
  CV.Total.winsorised_value = c(0.1, 0.2, 0.3, 0.4, 0.1, 0.2, 0.3, 0.4),
  Total.winsorised_value = c(15, 25, 35, 45, 10, 20, 30, 40)
)


test_that("test format_se_for_publication formats file correctly (no period given)", {
  df_actual <- format_se_for_publication(df)

  # Read in the file and compare to expected
  expect_true(all(df_actual$period == 202202))

  df_expected =
    data.frame(
      questioncode = c(101, 102, 103, 104),
      period = c(202202, 202202, 202202, 202202),
      std_error_p_millions = c(1.0, 2.0, 3.0, 4.0),
      cov= c(0.1, 0.2, 0.3, 0.4),
      sample_var_p_millions = c(10, 20, 30, 40)
    )
  expect_equal(df_actual, df_expected)

})


test_that("test format_se_for_publication formats file correctly period (period given) ", {
  df_actual <- format_se_for_publication(df, "202201")

  # Read in the file and compare to expected
  expect_true(all(df_actual$period == 202201))

  df_expected =
    data.frame(
      questioncode = c(101, 102, 103, 104),
      period = c(202201, 202201, 202201, 202201),
      std_error_p_millions = c(1.5, 2.5, 3.5, 4.5),
      cov = c(0.1, 0.2, 0.3, 0.4),
      sample_var_p_millions = c(15, 25, 35, 45)
    )
  expect_equal(df_actual, df_expected)

})


test_that("test format filename returns correct output (network)", {
  run_id <- 1
  config <- list(
    output_path = "output/",
    bucket = "not_used"
  )
  formatted_path <- format_file_name(config, "test", run_id, platform="network")

  expect_equal(formatted_path, "output/test_1.csv")
})

test_that("test format filename returns correct output (s3)", {
  run_id <- 1  
  config <- list(
    output_path = "output/",
    bucket = "used"
    )
  formatted_path <- format_file_name(config, "test", run_id, platform = "s3")

  expect_equal(formatted_path, "s3a://used/output/test_1.csv")
})

test_that("test format path returns correct output (network)", {
  config <- list(
    output_path = "output/",
    bucket = "not_used"
  )
  formatted_path <- format_path(config, config$output_path, platform="network")

  expect_equal(formatted_path, "output/")
})

test_that("test format path returns correct output (s3)", {
  config <- list(
    output_path = "output/",
    bucket = "used"
  )
  formatted_path <- format_path(config, config$output_path, platform="s3")

  expect_equal(formatted_path, "s3a://used/output/")
})

test_that("test error when platform is not s3 or network", {
  config <- list(
    output_path = "output/",
    bucket = "used"
  )
  expect_error(
    format_path(config, config$output_path, platform = "local")
  )
})