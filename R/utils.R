#' Run an hdfs command as hdfs dfs arg1 arg2
#'
#' @param ... arguments to run
#'
#' @return r command status
#' @export
run_hdfs <- function(...) {

  cmd_args <- rbind("dfs",...)

  r <- system2("hdfs", args = cmd_args)

  # Status 0 is success

  full_cmd_command <- paste("hdfs",paste(cmd_args,collapse = ' '),sep=" ")

  if (r == 0){
    print(paste0(
      "Running command: ",
      full_cmd_command,
      " was succesful."
    ))
  }
  else (print(paste0(
      "Running command: ",
      full_cmd_command,
      " had status ",r)))

  return (r)
  }

#' Download file from AWS S3 locally
#'
#' @param input_full_path_s3 AWS S3 path where data are stored
#' @param local_path path to local storage
#'
#' @return None
#' @export
download_file_from_s3 <- function(input_full_path_s3,local_path){

  print(paste("Downloading",basename(input_full_path_s3)))

  run_hdfs("-get",input_full_path_s3,local_path)
  }

#' Upload file to AWS S3
#'
#' @param local_full_path path to file
#' @param save_path_s3 path to S3
#'
#' @return None
#' @export
upload_file_to_s3 <- function(local_full_path,save_path_s3){

  print(paste("Uploading",basename(local_full_path)))

  run_hdfs("-put",local_full_path,save_path_s3)
  }

#' Appends Rsurveymethods and version in file name
#'
#' @param input_data_path full path name
#'
#' @return filename
#' @export
create_rsurveymethods_file_name <- function(input_data_path){

  version <- packageVersion("Rsurveymethods")

  filename = paste("Rsurveymethods",version,basename(input_data_path),sep="_")

  return (filename)
  }


#' Check if storage system argument is valid
#'
#' @param storage_system input argument to check
#'
#' @return None
#' @export
check_storage_system_arg <- function(storage_system){

  accepted_values_for_system <- c("local","s3")

  if (!storage_system %in% accepted_values_for_system){
    stop(storage_system,
         "is not an accepted argument, accepted values are: ",
         accepted_values_for_system
    )}


}


#' format standard errors file for publication
#'
#' @param df dataframe to format for standard errors publication
#' @param storage_system should be local or s3
#' @param output_path directory to output formatted df
#' @param selected_period optional, if provided only that period will be processed YYYYMM format
#'
#' @return r command status
#' @export
format_se_for_publication <- function(df, storage_system, output_path,selected_period=""){
  # Filtering to only include most recent period
  if (selected_period == "") {
    selected_period <- max(df$period)
  }
  df_filtered <- df[df$period == selected_period, ]
  # Ordering questions in specific order requested by business area
  question_order <- list(290, 201, 211, 221, 231, 241, 242, 202, 212, 222, 232, 243)
  df_filtered <- df_filtered[order(match(df_filtered$questioncode, question_order)), ]

  df_filtered <- df_filtered %>%
    dplyr::rename(
      std_error_p_thousands = SE.Total.winsorised_value,
      cov = CV.Total.winsorised_value,
      sample_var_p_thousands = Total.winsorised_value,
    )
  # Unsure if this is needed at this point
  # df_filtered["margin_of_error"] = df_filtered$std_error*1.96
  filename <- paste0("standard_errors_formatted_for_publication_period_", selected_period, ".csv")
  write_csv_wrapper(df_filtered, storage_system, output_path, filename)
}

