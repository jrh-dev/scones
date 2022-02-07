#' Retrieve the names and types of all visible objects within a connection or
#'  catalog.
#'
#' @description Returns a data.frame containing the name and type of all visible
#'  objects within a connection. Where the user wants to return the details of
#'  objects within a specific catalog, the catalog argument can be used.
#'
#'  Ttypical usage is to identify available schema. Users can use the
#'  "contains" argument to limit the rows returned to those with names
#'  containing a specified string.
#'
#' @param connection A DBI Connection object, as returned by `odbc::dbConnect()`
#'  and `Connect()`.
#'
#' @param catalog A character string identifying a 'catalog' object for which
#'  the user wants to return the details of objects within that catalog. Valid
#'  catalog names can be identified using `Schemas()`.
#'
#' @param contains A character string to be matched in the names of objects
#'  available to the user, only objects with names containing the specified
#'  string will be returned. Case is ignored.
#'
#' @return A data.frame containing the name and type of all visible objects
#'  within a specified connection and/or catalog.
#'
#' @examples
#'  \dontrun{
#'  conn <- Connect(name = "data_source_name")
#'
#'  Schemas(conn)
#'  }
#'
#' @export
Schemas <- function(connection, catalog = NULL, contains = NULL) {

  if (is.null(catalog)) {
    out <- odbc::odbcListObjects(connection)
  } else {
    out <- odbc::odbcListObjects(connection, catalog)
  }

  if (!is.null(contains)) {
    out <- out[grepl(contains, out$name, fixed = TRUE, ignore.case = TRUE),]
  }

  return(out)
}
