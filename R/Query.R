#' Retrieve the result of a SQL query as a data frame.
#'
#' @description A Wrapper for `odbc::dbGetQuery()`. Returns the result of a
#' query as a data frame. The function is suitable for SELECT queries only.
#'
#' @param connection A DBIConnection object, as returned by `odbc::dbConnect()`
#' and `Connect()`.
#'
#' @param sql_query A character string containing SQL.
#'
#' @return A character vector of all visible fields in the specified
#'   table in the correct order.
#'
#' @examples
#'  \dontrun{
#'  conn <- Connect("data_source_name")
#'
#'  Query(conn, "SELECT * FROM xx.yyy")
#'  }
#'
#' @export
Query <- function(connection, sql_query) {
  return(odbc::dbGetQuery(connection, sql_query))
}
