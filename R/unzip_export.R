#' @title unzip_export
#' @description unzips files exported from inception (creates local files; use with caution)
#' @param path path of the folder that contains the Inception export
#' @param folder name of the folder withing the Inception export, in which the xmi files with the annotations are stored
#' @param overwrite should existing unzipped files be unzipped again (defaults to FALSE)
#' @param recursive should files from sub-folders also be unzipped (defaults to FALSE)
#' @return unzips files locally in the subfolder "extracted" and provides list with paths to extracted files
#' @examples
#' \dontrun{
#' unzip_export(path = "NameOfExportFolder", folder = "annotation")
#' }
#' @export

unzip_export <- function(path, folder, overwrite = FALSE, recursive = FALSE){
          path_to_import <- paste0(path, "/", folder)
          path_to_export <- paste0(path, "/extracted")
          annotated_docs <- list.files(path_to_import, recursive = recursive) %>% grep(pattern = "INITIAL_CAS.zip", invert = T, value = T)
          doc_names <- list()
          for(i in seq_along(annotated_docs)){
                    out = gsub("(\\w+).xmi/(\\w+).zip", perl = TRUE, replacement = "\\1/\\2", annotated_docs[i])
                    doc_names[[i]] <- utils::unzip(paste0(path_to_import, "/", annotated_docs[i]), list = T)
                    utils::unzip(paste0(path_to_import, "/", annotated_docs[i]), exdir = paste0(path_to_export, "/", out), overwrite = overwrite)
          }
          if(length(doc_names) > 0){
                    message("extraction complete...")
          } else {
                    message("no valid documents found")
          }
          doc_names_complete <- unlist(doc_names)
}
