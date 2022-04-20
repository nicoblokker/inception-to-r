#' @title select_ns
#' @description simple wrapper function to extract and print all names of namespaces from xmi-file
#' @param xmi_file path to xmi-file
#' @return returns vector with names
#' @examples
#' \dontrun{
#' xmi_file <- unzip_export()
#' select_ns(xmi_file)
#' }
#' @export

select_ns <- function(xmi_file){
          xml2::read_xml(xmi_file) |> xml2::xml_ns() |> names()
}
