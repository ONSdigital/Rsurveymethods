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

