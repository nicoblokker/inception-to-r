#' @title make_query
#' @description chains several namespaces or layers into xpath-query
#' @param keywords vector of keywords in questions
#' @return returns string of query
#' @examples
#' make_query(c("custom", "Sentence"))
#' @noRd

make_query <- function(keywords){
          query <- vector()
          for (i in keywords) {
                    query[i] <- paste0("contains(name(),", "'", i, "')") 
                    query2 <- paste(query, collapse = " or ")
                    query3 <- paste0("//*[", query2,  "]")
          }
          return(query3)
}
