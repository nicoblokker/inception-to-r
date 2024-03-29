% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/unzip_export.R
\name{unzip_export}
\alias{unzip_export}
\title{unzip_export}
\usage{
unzip_export(folder, overwrite = FALSE, recursive = FALSE)
}
\arguments{
\item{folder}{set path to folder in which the xmi-files are stored}

\item{overwrite}{should existing unzipped files be unzipped again (defaults to FALSE)}

\item{recursive}{should files from sub-folders also be unzipped (defaults to FALSE)}
}
\value{
unzips files locally and provides list with paths to extracted files
}
\description{
unzips files exported from inception (creates local files; use with caution)
}
\examples{
\dontrun{
unzip_export(folder = "export")
}
}
