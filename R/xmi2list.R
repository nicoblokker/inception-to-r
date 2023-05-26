#' @title xmi2list
#' @description extract text and possibly annotations from inception export (provided as xmi) 
#' @param xmi_file xmi-file as provided by inception export
#' @param key vector of keywords in questions (default set to 'custom' annotations)
#' @return returns dataframe with queried annotations
#' @examples
#' \dontrun{
#' xmi_files <- list.files(".", pattern = "\\.xmi$", recursive = T)
#' df <- purrr::map_df(files, purrr::possibly(xmi2list, data.frame(text = NULL)), .id = "id")
#' @export
#' @importFrom rlang {{
#' @importFrom magrittr "%>%"

xmi2list <- function(xmi_file, key = "custom"){
          xmi_file_anno <-  xml2::read_xml(xmi_file)
          annotated_textspan <- xml2::xml_find_all(xmi_file_anno, "//*[contains(name(), ':Sofa')]") |> xml2::xml_attr("sofaString") 
          text <- data.frame(xmi_file_name = xmi_file, text = annotated_textspan)
          annotations <- xml2::xml_find_all(xmi_file_anno, make_query(keywords = key))
          if(length(annotations) > 0){
                    annotations_df <- purrr::map_df(annotations, ~c(xml2::xml_attrs(.x),
                                                                    "layer" = xml2::xml_name(.x),
                                                                    "text" = xml2::xml_text(.x),
                                                                    "xmi_file_name" = {{xmi_file}}))
                    if("sofa" %in% colnames(annotations_df)){
                              annotations_df$quote <- purrr::map2_chr(annotations_df$begin, annotations_df$end, ~substr(annotated_textspan, .x, .y))
                    }
                    df <- annotations_df %>% tidyr::nest(annotations = -xmi_file_name) %>% dplyr::left_join(text, .)
                    return(df)
          } else {
                    text$annotations <- list("no annotations")
                    return(text)
          }
}
