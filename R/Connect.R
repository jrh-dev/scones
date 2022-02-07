#' Connect to an ODBC DBMS.
#'
#' @description Wrapper for `odbc::dbconnect()`, designed to make connecting to
#'  an ODBC DBMS as simple as possible.
#'
#'  By default, credentials are captured and handled securely using the
#'  {rstudioapi}. Users can alternatively set the "auth_prompt" argument to
#'  `FALSE` and pass "uid", and "pwd" arguments specifying the username and
#'  password respectively.
#'
#' @importFrom rstudioapi showPrompt askForPassword
#'
#' @param auth_prompt Logical value. The default, `TRUE`, will prompt the user
#'  to enter a username and password. When `FALSE` the user must supply the
#'  username and password as arguments "uid" (username) and "pwd" (password)
#'  unless credentials are not required.
#`
#` @param driver Specify a DBMS driver, the default when not
#'  specified is `odbc::odbc()`.
#`
#` @param ds_name Character string specifying the data source name. The names of
#'  valid data sources available to the user can be retrieved using the
#'  `ListDataSources()` function.
#'
#' @param ... Additional arguments to pass to `odbc::dbConnect()`.
#'  Common arguments include;
#'  driver The ODBC driver name.
#'
#'  * `server` Character string specifying the name of a host.
#'  * `database` Character string specifying the name of a database.
#'  * `uid` Character string specifying a username for database authentication.
#'     By default the function will prompt the user to enter a value.
#'  * `pwd` Character string specifying a username for database authentication.
#'     By default the function will prompt the user to enter a value.
#'
#'  See \link[odbc]{dbConnect,OdbcDriver-method} for further details of
#'   acceptable arguments.
#'
#' @examples
#'  \dontrun{
#'  conn <- Connect("data_source_name")
#'  }
#'
#' @export
Connect <- function(auth_prompt = TRUE, driver = NULL, ds_name <- NULL, ...) {
  
  if (is.null(driver)) {
    driver <- odbc::odbc()
  } else {
    driver <- driver
  }
  
  if (auth_prompt) {
    requireNamespace("rstudioapi")
    
    if (hasArg("uid") | hasArg("pwd")) {
      stop("Arguments 'uid' & 'pwd' should not be passed when 'auth-prompt' is TRUE.")
    }
    
    out <- odbc::dbConnect(
      drv = driver,
      dsn = ds_name,
      uid = rstudioapi::showPrompt("Username", "Enter username", default = ""),
      pwd = rstudioapi::askForPassword("Enter password"),
      ...
    )
  } else {
    out <- odbc::dbConnect(
      drv = driver,
      dsn = ds_name,
      ...
    )
  }
  return(out)
}
