#' Retrieve the names of data sources available to the user.
#'
#' @description A wrapper for `odbc::odbcListDataSources()` which returns a
#'  character vector of the names of data sources available to the user. Users
#'  can choose to return only data sources with names containing a specific
#'  pattern by using the "contains" argument.
#'
#'  The data source names (dsn) returned are suitable for use in the "name"
#'  argument of `Connect()` function.
#'
#' @param contains A character string to be matched in the names of data sources
#'  available to the user, only data sources with names containing the specified
#'  string will be returned. Case is ignored.
#'
#' @return A character vector of the names of data sources available to the
#'  user.
#'
#' @examples
#'  \dontrun{
#'  DataSources()
#'
#'  DataSources(contains = "patient")
#'  }
#'
#' @export
DataSources <- function (contains = NULL) {
  dsn <- as.vector(as.matrix(odbc::odbcListDataSources()[1]))
  if (!is.null(contains)) {
    dsn <- dsn[grepl(contains, dsn, ignore.case = TRUE)]
  }
  return(dsn)
}
