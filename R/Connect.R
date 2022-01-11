#' Connect to an ODBC DBMS with secure authentication input prompts.
#'
#' @description Wrapper for `odbc::dbconnect()`, designed to make connecting to
#'  an ODBC DBMS as simple as possible. The function is suitable for use in an
#'  interactive RStudio session where the user will receive prompts to enter
#'  credentials if required.
#'
#'  Credentials are handled securely using the {rstudioapi}. For users looking
#'  to retrieve credentials from the system credential store using the {keyring}
#'  package, please use `KeyringConnect()`.
#'
#'  Where ODBC configuration files are in place, users need only supply the
#'  {dsn} argument to connect to a database.
#'
#' @importFrom rstudioapi showPrompt askForPassword
#'
#' @param dsn Character string specifying the data source name (used
#'  interchangeably to specify database name when ODBC configuration files are
#'  not in place for the desired connection). The names of valid data sources
#'  available to the user can be retrieved using the `ListDataSources()`
#'  function.
#'
#' @param driver Character string specifying the name of a driver to be used.
#'  default is `odbc::odbc()`.
#'
#' @param trusted Logical value, use `TRUE` when the connection does not require
#'  a username or password. The default, `FALSE`, will prompt the user for
#'  credentials.
#'
#' @examples
#'  \dontrun{
#'  conn <- Connect("data_source_name")
#'  }
#'
#' @export
Connect <- function(dsn = NULL, driver = odbc::odbc(), trusted = FALSE, ...) {
  
  requireNamespace("rstudioapi")
  
  return(
    odbc::dbConnect(
      drv = driver,
      dsn = dsn,
      uid = if (!trusted) {
        rstudioapi::showPrompt("Username", "Enter username", default = "")
      } else {
        NULL
      },
      pwd = if (!trusted) {
        rstudioapi::askForPassword("Enter password")
      } else {
        NULL
      }
    )
  )
}
