#' Retrieve the names of available fields in a table.
#'
#' @description Fast return of the names of all visible fields in the specified
#'  table in the correct order.
#'
#' @param connection A DBI Connection object, as returned by `odbc::dbConnect()`
#'  and `Connect()`.
#'
#' @param schema A character vector specifying the name of a schema. Valid
#'  schema names can be identified by running `Schemas()` and noting rows with
#'  "type" "schema".
#'
#' @param table A character vector specifying the name of a table. Valid
#'  table names can be identified by running `Tables()`.
#'
#' @return A character vector containing the names of all visible fields in the
#'  specified table in the correct order.
#'
#' @examples
#'  \dontrun{
#'  conn <- Connect("data_source_name")
#'
#'  Fields(conn, "my_schema", "my_table_name")
#'  }
#'
#' @export
Fields <- function(connection, schema, table) {
  return(
    names(
      odbc::dbGetQuery(
        connection,
        paste0("SELECT * FROM ", schema, ".", table, " WHERE FALSE")
      )
    )
  )
}
