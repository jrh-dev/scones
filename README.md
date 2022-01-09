# scones - Simple CONEctionS

The package aims to provide helpful functions to simplify creating ODBC connections and data extraction. The implementation utilises the [odbc](https://github.com/r-dbi/odbc) package.  The package is currently under development and is available as a pre-release.

#### Who is this package for?
The package was designed for analysts who need to extract data from a database with ODBC drivers. The package provides much more limited functionality than [odbc](https://github.com/r-dbi/odbc) but aims to be simpler to use, requiring less specific knowledge of database infrastructure and requiring only minimal arguments.

Use of the package is intended for situations where users are extracting data with SELECT queries and it was specifically designed with use in interactive or exploratory analyses in mind. More advanced operations and writing to a database are outwith the scope of the package and would be covered by the use of the [odbc](https://github.com/r-dbi/odbc)  package directly.

#### Prerequsites
Drivers and connection setup at system level should be completed in line with the OS being used. The exact drivers required and process to be followed will vary by OS and guidance is readily available online.

#### Installation
##### R
```
# install from tar.gz
install.packages(path_to_file, repos = NULL, type="source")
```
#### List Available  Data Sources
To retrieve the names of data sources available to the user.
```
library(scones)

DataSources()
```
To filter the retrieved names to those containing a keyword (non case sensitive). 
```
library(scones)

DataSources(contains = "patient")
```
#### Connecting to a Database
The `Connect()` function allows users to connect to a database.  Where authentication is required through credential entry, the user will receive prompts.  Credential capture is handled by the  [rstudioaopi](https://github.com/rstudio/rstudioapi) , thus requiring rstudio. The lack of alternate methods of credential entry are designed to encourage details been passed as plain text or stored R scripts. 

Where the user intends to retrieve credentials from  the system credential store, the `KeyringConnect()` function is available which uses the [keyring]("https://github.com/r-lib/keyring") package to do so in a secure manner. This method is well suited to use within automated processes.

##### With Configuration Files

Where ODBC configuration files are in place, users can connect to a database using `Connect()` and by specifying a  data source name (dsn) .  Valid dsn's can be retrieved before attempting to establish a connecting with the `DataSources()` function.
```
library(scones)

# To receive prompts for login credentials
Connect(dsn = "a_data_source_name")

# To connect without login credentials
Connect(dsn = "a_data_source_name", trusted = TRUE)
```
##### Without Configuration Files
Where ODBC configuration files are not in place, users can connect to a database using `Connect()` with additional arguments . 
```
library(scones)

Connect(dsn = "a_data_source_name",
        driver =  "PostgreSQL Driver",
        host = "127.0.0.1",
        port = "6123")
```
##### Using Stored Credentials
Users can connect to a database whilst using credentials retrieved from the system credential store with `KeyringConnect()`. The function used the [keyring]("https://github.com/r-lib/keyring") package. A key is typically defined A key typically consists of a service name and a password, however, an additional "username" variable can also be stored and must be present to use this function.

The function does not handle keyring unlocking. When used in an interactive session and the keyring is locked at the point where the function is called the user will be prompted to enter the keyring password. Otherwise,  appropriate code should be executed to unlock the keyring before calling the function (if required).
```
library(scones)

KeyringConnect(keyring_name = "my_keys, service_name = "LDAP", dsn= NULL)
```

### Usage
The other package functions require a connection as created by `Connect()`, `KeyringConnect()`, or a comparable function from the [odbc](https://github.com/r-dbi/odbc)  package.

#### List Available Schemas
`Schemas()` returns a data.frame containing the names and types of all visible objects within a connection. 
```
library(scones)

conn <- Connect(dsn = "a_data_source_name")

Schemas(conn)
```
 To see objects within a specified catalog.
```
Schemas(conn, catalog = "a_catalog_name")
```
To filter the retrieved rows to those where the name column contains a keyword (non case sensitive). 
```
Schemas(conn, contains = "patient")
```

#### List Available Tables
`Tables()` retrieves the names of available tables.
```
library(scones)

conn <- Connect(dsn = "a_data_source_name")

Tables(conn)
```
 To see tables within a specified schema. Valid schema names can be retrieved using the `Schemas()`  function.
```
Tables(conn, schema = "a_schema_name")
```
To filter the retrieved names to those containing a keyword (non case sensitive). 
```
Tables(conn, contains = "admissions")
```

#### List Available Fields/Columns
`Fields()` retrieve the names of available fields/columns in a specified table. Both the table name, and the name of the appropriate schema must be provided. Valid schema and table names can be retrieved using the `Schemas()`  and  `Tables()` functions. 
```
library(scones)

conn <- Connect(dsn = "a_data_source_name")

Fields(conn, schema = "a_schema_name",  table = "a_table_name")
```

#### Querying
`Query()` allows users to submit a SQL query and return the results as a data.frame. The function is only suitable for SELECT type queries. More advanced functionality is provided by the [odbc](https://github.com/r-dbi/odbc)  package including write functionality. 
```
library(scones)

conn <- Connect(dsn = "a_data_source_name")

Query(conn, "SELECT * FROM dbo.a_named_table")
```

#### Closing a Connection
Users should always close a connection once finished working with it.
```
library(scones)

conn <- Connect(dsn = "a_data_source_name")

Disconnect(conn)
```