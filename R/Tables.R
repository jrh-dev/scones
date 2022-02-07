#' Retrieve the names of available tables.
#'
#' @description A wrapper for `odbc::dbListTables()` which returns a character
#'  vector containing the names of tables in alphabetical order. The  function
#'  default returns the names of all visible tables within a connection. Users
#'  can specify a schema to limit the return to tables within that schema.
#'
#'  Users can use the "contains" argument to limit the table names returned to
#'  those with names containing a specified string.
#'
#' @param connection A DBIConnection object, as returned by `odbc::dbConnect()`
#'  and `Connect()`.
#'
#' @param schema A character string identifying a 'schema' for which the user
#'  wants to return the names of tables within that schema. Valid schema names
#'  can be identified using `Schemas()`.
#'
#' @param contains A character string to be matched in the names of tables
#'  available to the user, only schema with names containing the specified
#'  string will be returned. Case is ignored.
#'
#' @return A character vector of the names of tables accessible through the
#'  specified connection and/or schema.
#'
#' @examples
#'  \dontrun{
#'  conn <- Connect(name = "data_source_name")
#'
#'  Tables(conn)
#'  }
#'
#' @export
Tables <- function(connection, schema = NULL, contains = NULL) {

  out <- sort(odbc::dbListTables(connection, schema_name = schema))

  if (!is.null(contains)) {
    out <- out[grepl(contains, out, fixed = TRUE, ignore.case = TRUE)]
  }

  return(out)
}
