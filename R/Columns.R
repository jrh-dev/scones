#' Retrieve the names of available columns in a table.
#'
#' @description Fast return of the names of all visible columns in the specified
#'  table in the correct order.
#'
#' @importFrom methods hasArg
#'
#' @param connection A DBI Connection object, as returned by `odbc::dbConnect()`
#'  and `Connect()`.
#'
#' @param schema A character vector specifying the name of a schema. Valid
#'  schema names can be identified using `Schemas()`.
#'
#' @param table A character vector specifying the name of a table. Valid
#'  table names can be identified using `Tables()`.
#'
#' @return A character vector containing the names of all visible columns in the
#'  specified table in the correct order.
#'
#' @examples
#'  \dontrun{
#'  conn <- Connect(name = "data_source_name")
#'
#'  Columns(conn, "my_schema", "my_table_name")
#'  }
#'
#' @export
Columns <- function(connection, schema, table) {
  return(
    names(
      odbc::dbGetQuery(
        connection,
        paste0("SELECT * FROM ", schema, ".", table, " WHERE FALSE")
      )
    )
  )
}
