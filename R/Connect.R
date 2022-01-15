#' Connect to an ODBC DBMS with secure authentication input prompts.
#'
#' @description Wrapper for `odbc::dbconnect()`, designed to make connecting to
#'  an ODBC DBMS as simple as possible. The function is suitable for use in an
#'  interactive RStudio session where the user will receive prompts to enter
#'  credentials if required.
#'
#'  By default, credentials are captured and handled securely using the
#'  {rstudioapi}. Users can alternatively set the "auth_prompt" argument to
#'  `FALSE` and pass "uid", and "pwd" arguments specifying the username and
#'  password respectively. When users choose to use the "uid", and "pwd"
#'  arguments they are strongly encouraged to use {keyring} or similar and not
#'  to pass credentials as plain text.
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
#' @param auth_prompt Logical value. The default, `TRUE`, will prompt the user
#'  to enter a username and password. When `FALSE` the user must supply the
#'  username and password as arguments "uid" (username) and "pwd" (password)
#'  unless credentials are not required, in which case the 'trusted' argument
#'  should be set to `TRUE`.
#'
#'  When users choose to use the "uid", and "pwd" arguments they are strongly
#'  encouraged to use the {keyring} package or a similar solution and not to
#'  pass credentials as plain text.
#'
#' @param ... Additional arguments to pass to odbc::dbConnect.
#'  See \link[odbc]{dbConnect,OdbcDriver-method} for further details.
#'
#' @examples
#'  \dontrun{
#'  conn <- Connect("data_source_name")
#'  }
#'
#' @export
Connect <- function(dsn = NULL, driver = odbc::odbc(), trusted = FALSE,
                    auth_prompt = TRUE, ...) {

  if (auth_prompt) {
    requireNamespace("rstudioapi")
  } else if (!(hasArg("uid") & hasArg("pwd")) & !(trusted)) {
    stop("Args 'uid' & 'pwd' required when 'auth_prompt' is FALSE and 'trusted' is FALSE.")
  }

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
      },
      ...
    )
  )
}
