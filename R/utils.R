#' Run an hdfs command as hdfs dfs arg1 arg2
#'
#' @param ... arguments to run
#'
#' @return r command status
#'
#' @examples run_hdfs(-get,"some/path/to.csv")
run_hdfs <- function(...) {

  cmd_args <- rbind("dfs",...)

  r <- system2("hdfs", args = cmd_args)

  # Status 0 is success

  full_cmd_command <- paste("hdfs",paste(cmd_args,collapse = ' '))

  if (r != 0){
    print("I am here")
    #stop("Running command:",
     #    full_cmd_command,
    #     "failed"
    #  )
  }
  return (r)
  }

#' Download file from AWS S3 locally
#'
#' @param AWS S3 bucket where data are stored
#' @param hdfs_path path to file within bucket
#' @param file_name base file name
#' @param local_path path to local storage
#'
#' @return None
#' @export
#'
#' @examples download_file_from_s3(
#' "s3a://a-bucket-name/folder1/subfolder1/base_name.csv",
#' "local_folder1")

download_file_from_s3 <- function(input_full_path_s3,local_path){

  # Error handling via status output in run_hdfs
  run_hdfs(c("-get",input_full_path_s3,local_path))

  print(paste("Downloading",basename(input_full_path_s3), "was succesful."))

  }

#' Upload file to AWS S3
#'
#' @param local_full_path path to file
#' @param save_path_s3 path to S3
#'
#' @return None
#' @export
#'
#' @examples download_file_from_s3(
#' "local_folder1/base_name.csv",
#' "s3a://a-bucket-name/folder1/subfolder1")
upload_file_to_s3 <- function(local_full_path,save_path_s3){


  # Error handling via status output in run_hdfs
  run_hdfs(c("-put",local_full_path,save_path_s3))

  print(paste("Uploading",basename(local_full_path), "was succesful."))

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

