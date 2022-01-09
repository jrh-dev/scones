#' Close an active connection to an ODBC DBMS.
#'
#' @description A wrapper for `odbc::dbDisconnect()`; closes a DB connection, as
#' created by `odbc::dbConnect()` or `Connect()`.
#'
#' @param connection A DBI Connection object, as returned by `odbc::dbConnect()`
#' or `Connect()`.
#'
#' @examples
#'  \dontrun{
#'  conn <- Connect("data_source_name")
#'
#'  Disconnect(conn)
#'  }
#'
#' @export
Disconnect <- function(connection){
  odbc::dbDisconnect(connection)
}
