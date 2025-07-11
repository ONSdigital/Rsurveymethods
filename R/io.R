#' Wrapper csv reader for local or s3 data storage
#'
#' @param storage_system accepts local or s3
#' @param input_data_path full path of data
#'
#' @return df dataframe
#'
#' @examples run_hdfs(-get,"some/path/to.csv")
read_csv_wrapper <- function(storage_system,input_data_path){

  if (storage_system=="local"){

    df = read.csv(input_data_path)

  }

  if (storage_system=="s3"){

    #create directory to store data
    dir.create(file.path("temp_data"), showWarnings = FALSE)

    download_file_from_s3(input_data_path,"temp_data")

    temp_path = paste("temp_data",basename(input_data_path),sep="/")

    df = read.csv(temp_path)

    unlink("temp_data", recursive = TRUE)

  }

  return (df)
  }


#' Wrapper csv writer for local or s3 data storage
#'
#' @param storage_system accepts local or s3
#' @param input_data_path full path of data
#' @param file_name name of file to export

#'
#' @return df dataframe
#'
#' @examples run_hdfs(-get,"some/path/to.csv")
write_csv_wrapper <- function(df,storage_system,save_path,file_name){


  if (storage_system=="local"){

    write.csv(df, save_path, row.names = FALSE)

  }

  if (storage_system=="s3"){

    #create directory to write data locally
    dir.create(file.path("temp_data"), showWarnings = FALSE)

    temp_path = paste("temp_data",file_name,sep="/")

    write.csv(df, temp_path, row.names = FALSE)

    upload_file_to_s3(temp_path,save_path)

    unlink("temp_data", recursive = TRUE)

  }

  }
