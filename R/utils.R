library(dplyr)

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

  accepted_values_for_system <- c("network","s3")

  if (!storage_system %in% accepted_values_for_system){
    stop(storage_system,
         "is not an accepted argument, accepted values are: ",
         accepted_values_for_system
    )}


}


#' format standard errors file for publication
#'
#' @param df dataframe to format for standard errors publication
#' @param selected_period optional, if provided only that period will be processed YYYYMM format
#'
#' @return formatted dataframe
#' @export
format_se_for_publication <- function(df, selected_period=""){
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
      std_error_p_millions = SE.Total.winsorised_value,
      cov = CV.Total.winsorised_value,
      sample_var_p_millions = Total.winsorised_value,
    )
  # reset index column to clean numbering
  rownames(df_filtered) <- NULL
  return(df_filtered)
  # Unsure if this is needed at this point
  # df_filtered["margin_of_error"] = df_filtered$std_error*1.96
}

#' Format file name by appending run_id
#' 
#' @param config configuration list
#' @param file_name original file name
#' @param platform storage platform, either "s3" or "network"
#' @return formatted file name
#' @export
format_file_name <- function(config, file_name, platform) {
  formatted_path <- format_path(config, config$main_construction_output_path, platform)
  formatted_file_name <- paste0(formatted_path, file_name, "_", config$run_id, ".csv")
  return(formatted_file_name)
}

#' Format file path by adding s3 prefix if needed
#' 
#' @param config configuration list
#' @param path original file path
#' @param platform storage platform, either "s3" or "network"
#' @return formatted file path
#' @export
format_path <- function(config, path, platform = c("s3", "network")) {
  platform <- match.arg(platform)
  if (platform == "s3") {
    prefix <- paste0("s3a://", config$bucket, "/")
  } else {
    prefix <- ""
  }
  formatted_path <- paste0(prefix, path)
  return(formatted_path)
}

