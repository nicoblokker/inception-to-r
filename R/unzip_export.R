#' @title unzip_export
#' @description unzips files exported from inception (creates local files; use with caution)
#' @param path_to_export set path to where the xmi-files are stored
#' @param overwrite should existing unzipped files be unzipped again (defaults to FALSE)
#' @param recursive should files from sub-folders also be unzipped (defaults to FALSE)
#' @return unzips files locally and provides list with paths to extracted files
#' @examples
#' \dontrun{
#' unzip_export(path_to_export = ".")
#' }
#' @export

unzip_export <- function(path_to_export = ".", overwrite = FALSE, recursive = FALSE){
          annotated_docs <- list.files(path_to_export, recursive = recursive)
          annotated_docs <- annotated_docs[grepl("webanno|inception\\d+", annotated_docs)]
          doc_names <- list()
          for(i in seq_along(annotated_docs)){
                    path <- paste0(path_to_export, "\\", annotated_docs[i])
                    out <- gsub("webanno.*?$|inception.*?$", "extracted", path)
                    doc_names[[i]] <- utils::unzip(path, exdir = out, overwrite = overwrite) |> (\(.) {.[!grepl("TypeSystem", .)]})()
          }
          if(length(doc_names) > 0){
                    message("extraction complete...")
          } else {
                    message("no valid documents found")
          }
          doc_names_complete <- unlist(doc_names)
}
