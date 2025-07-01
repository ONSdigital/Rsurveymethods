#' Read input data
#'
#' @param input_path Filepath to input data.
#'
#' @return DataFrame.
#'
#' @export
read_input_data <- function(input_path) {
  data <- read.csv(input_path)
  return(data)
}
