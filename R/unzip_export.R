#' @title unzip_export
#' @description unzips files exported from inception (creates local files; use with caution)
#' @param folder set path to folder in which the xmi-files are stored
#' @param overwrite should existing unzipped files be unzipped again (defaults to FALSE)
#' @param recursive should files from sub-folders also be unzipped (defaults to FALSE)
#' @return unzips files locally and provides list with paths to extracted files
#' @examples
#' \dontrun{
#' unzip_export(folder = "export")
#' }
#' @export

unzip_export <- function(folder, overwrite = FALSE, recursive = FALSE){
          annotated_docs <- list.files(folder, recursive = recursive)
          annotated_docs <- annotated_docs[!grepl("INITIAL_CAS", annotated_docs) & grepl("annotation\\W|curation\\W", annotated_docs)]
          doc_names <- list()
          for(i in seq_along(annotated_docs)){
                    path <- file.path(folder,  annotated_docs[i])
                    out <- file.path(gsub("(\\w+)\\.?\\w+$", "", annotated_docs[i]), "extracted")
                    doc_names[[i]] <- utils::unzip(path, exdir = out, overwrite = overwrite) |> (\(.) {.[!grepl("TypeSystem", .)]})()
          }
          if(length(doc_names) > 0){
                    message("extraction complete...")
          } else {
                    message("no valid documents found")
          }
          doc_names_complete <- unlist(doc_names)
}
