#' @title originalxmi2df
#' @description extract original text from xmi files prepared for INCEpTION
#' @param xmi_file xmi-file used for imprting data into INCEpTION
#' @param key vector of keywords in questions (default set to 'custom' annotations)
#' @return returns dataframe with queried CAS fields
#' @examples
#' \dontrun{
#' xmi_files <- list.files(".", pattern = "\\.xmi$", recursive = T)
#' df <- originalxmi2df(xmi_files[1])
#' df <- originalxmi2df(xmi_files[1], c("custom", "Sentence"))
#' df <- purrr::map_df(xmi_files[1:3], originalxmi2df, key = c("custom", "Sentence"), .id = "file")
#' }
#' @export
#' @importFrom rlang {{

originalxmi2df <- function(xmi_file, key = "custom"){
          xmi_file_anno <-  xml2::read_xml(xmi_file)
          annotations <- xml2::xml_find_all(xmi_file_anno, make_query(keywords = key))
          if(length(annotations) > 0){
                    annotations_df <- purrr::map_df(annotations, ~c(xml2::xml_attrs(.x),
                                                                    "layer" = xml2::xml_name(.x),
                                                                    "text" = xml2::xml_text(.x),
                                                                    "xmi_file_name" = {{xmi_file}}))
                    if("sofa" %in% colnames(annotations_df)){
                              annotated_textspan <- xml2::xml_find_all(xmi_file_anno, "//*[contains(name(), ':Sofa')]") |> xml2::xml_attr("sofaString")
                              annotations_df$atext <- annotated_textspan
                    }
                    return(annotations_df)
          }
}
