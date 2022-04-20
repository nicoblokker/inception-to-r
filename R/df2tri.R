#' @title df2tri
#' @description transforms (wide) `dataframe` into (long) edgelists to work with `igraph`
#' @param df the dataframe
#' @param node_columns node-columns as vector
#' @param edge_columns edge-columns as vector. First edge-column should equal edge-weight
#' @return returns edgelist
#' @details code based on function `df2nmode` from mardyR package
#' @examples
#' df <- data.frame(from = 1:4,
#'                  to = c("a", "b", "b", "a"),
#'                  frame = paste0("f", 4:1),
#'                  time = paste0("t", c(1,1,2,2)),
#'                  weight = 1,
#'                  stringsAsFactors = FALSE)
#'
#' df2tri(df, node_columns = 1:4, edge_columns = 5)
#' @export

df2tri <- function(df, node_columns, edge_columns){
          do.call(rbind, lapply(1:nrow(df), function(x) data.frame(cbind(t(utils::combn(df[x, node_columns], 2)), df[x, c(edge_columns)]))))
}
