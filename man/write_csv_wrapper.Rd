% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/io.R
\name{write_csv_wrapper}
\alias{write_csv_wrapper}
\title{Wrapper csv writer for local or s3 data storage}
\usage{
write_csv_wrapper(df, storage_system, save_path, file_name)
}
\arguments{
\item{df}{dataframe to export}

\item{storage_system}{accepts local or s3}

\item{save_path}{full path of data}

\item{file_name}{name of file to export}
}
\value{
df dataframe
}
\description{
Wrapper csv writer for local or s3 data storage
}
