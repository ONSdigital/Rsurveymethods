test_that("regenesses_estimation correct output" , {
  input_data <- data.frame(
    period = c("202201", "202201", "202201", "202201"),
    cell = c("100", "100", "200", "300"),
    ruref = c(101, 102, 103, 104),
    question_no = c(10, 11, 12, 13),
    aweight = c(1.1, 1.0 , 0.8, 0.9),
    gweight = c(1, 1, 1, 1),
    value = c(100, 200, 300, 400),
    outlier_weight = c(1, 0.5, 1, 0.5),
    count = c(2, 2, 1, 1),
    extcalweights = c(1.1, 1.0, 0.8, 0.9),
    winsorised_value = c(100, 100, 300, 200),
    univcts = c(1, 1, 1, 1),
    turnover = c(100, 200, 300, 400),
    size_band = c(1-5, 6-10, 6-10, 1-5),
    stringsAsFactors = FALSE
  )

  print(regenesses_estimation(input_data))

})
