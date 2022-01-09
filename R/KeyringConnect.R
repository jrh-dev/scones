#' Connect to an ODBC DBMS with credentials retrieved from the system
#'  credential store using the {keyring} package.
#'
#' @description Wrapper for `odbc::dbconnect()`, designed to make connecting to
#'  an ODBC DBMS as simple as possible whilst using credentials retrieved from
#'  the system credential store using the {keyring} package. Can be used in a
#'  non-interactive R session.
#'
#'  The function does not handle keyring unlocking. When used in an interactive
#'  session the user will be prompted to enter the keyring password. Otherwise,
#'  appropriate code should be executed to unlock the keyring before calling the
#'  function where required.
#'
#'  The system default keyring can be used, or any other named keyring. A key is
#'  defined by a service name and a password, however, an additional "username"
#'  variable can also be stored and is required by this function.
#'
#'  For users looking to enter credentials manually, please use `Connect()`.
#'
#' @importFrom keyring key_list key_get
#'
#' @param keyring_name Character vector specifying the name of the keyring to be
#'  used. Value can be NULL, in which case the system default keyring will be
#'  used.
#'
#' @param service_name Character vector specifying the service name of the key
#'  to be used.
#'
#' @param dsn Character string specifying the data source name. The names of
#'  data sources available to the user can be retrieved using the
#'  `ListDataSources()` function.
#'
#' @param driver Character string specifying the name of a driver to be used.
#'
#' @param host Character string specifying the host name.
#'
#' @param port Character string specifying  the port number.
#'
#' @examples
#'  \dontrun{
#'  conn <- KeyringConnect(
#'  "my_keyring_name", "my_service_name", "data_source_name"
#'  )
#'  }
#'
#' @export
KeyringConnect <- function(keyring_name = NULL, service_name = NULL, dsn= NULL,
                           driver = NULL, host = NULL, port = NULL) {

  requireNamespace("keyring")

  if (is.null(service_name)) {
    stop("service_name argument cannot be NULL. For manual credential entry try Connect()")
  }

  return(
    odbc::dbConnect(
      odbc::odbc(),
      dsn = dsn,
      driver = driver,
      host = host,
      port = port,
      uid = keyring::key_list(keyring = keyring_name, service = service_name)$username,
      pwd = keyring::key_get(keyring = keyring_name, service = service_name)
    )
  )
}
