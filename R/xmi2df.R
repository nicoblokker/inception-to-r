#' @title xmi2df
#' @description extract annotations from inception export (provided as xmi)
#' @param xmi_file xmi-file as provided by inception export
#' @param key vector of keywords in questions (default set to 'custom' annotations)
#' @return returns dataframe with queried annotations
#' @examples
#' \dontrun{
#' xmi_files <- list.files(".", pattern = "\\.xmi$", recursive = T)
#' df <- xmi2df(xmi_files[1])
#' df <- xmi2df(xmi_files[1], c("custom", "Sentence"))
#' df <- purrr::map_df(xmi_files[1:3], xmi2df, key = c("custom", "Sentence"), .id = "file")
#' }
#' @export
#' @importFrom rlang {{

xmi2df <- function(xmi_file, key = "custom"){
          xmi_file_anno <-  xml2::read_xml(xmi_file)
          annotations <- xml2::xml_find_all(xmi_file_anno, make_query(keywords = key))
          if(length(annotations) > 0){
                    annotations_df <- purrr::map_df(annotations, ~c(xml2::xml_attrs(.x),
                                                                    "layer" = xml2::xml_name(.x),
                                                                    "text" = xml2::xml_text(.x),
                                                                    "xmi_file_name" = {{xmi_file}}))
                    if("sofa" %in% colnames(annotations_df)){
                              annotated_textspan <- xml2::xml_find_all(xmi_file_anno, "//*[contains(name(), ':Sofa')]") |> xml2::xml_attr("sofaString")
                              annotations_df$quote <- purrr::map2_chr(annotations_df$begin, annotations_df$end, ~substr(annotated_textspan, .x, .y))
                    }
                    return(annotations_df)
          }
}