# scones - Simple CONEctionS

<!-- badges: start -->
[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)
[![R-CMD-check](https://github.com/jrh-dev/scones/workflows/R-CMD-check/badge.svg)](https://github.com/jrh-dev/scones/actions)
<!-- badges: end -->

The package provides helpful functions to simplify creating ODBC connections and performing data extraction, acting as a wrapper for the performant [odbc](https://github.com/r-dbi/odbc) package.

The package is currently under development and is available as a pre-release.

### Who is this package for?
The package has been designed for users, particuarly those working in analytical roles, who need to extract data from a SQL database accessible with ODBC drivers. The package provides limited functionality in comparison to [odbc](https://github.com/r-dbi/odbc), but aims to be simpler to use, requiring less specific knowledge of database infrastructure, and requiring users to specify only a minimal number of arguments.

The package is primarily intended for use in situations where users are extracting data with SELECT queries. It has been specifically designed with users performing exploratory analyses in interactive sessions in mind. More advanced operations such as writing to a database are outwith the scope of the package and users are recommended to consider using the [odbc](https://github.com/r-dbi/odbc) package directly.

## Prerequsites
Drivers and connection setup at system level should be completed in line with the OS being used. The exact drivers required and process to be followed will vary by OS and guidance is readily available online.

## Installation
### R
```
# install from github
library(devtools)
devtools::install_github("jrh-dev/scones")

# install from tar.gz
install.packages(path_to_file, repos = NULL, type="source")
```

## Usage
### List Available Data Sources
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
### Connecting to a Database
The `Connect()` function allows users to connect to a database.  Where authentication is required through credential entry, the user will receive prompts.  Credential capture is automatically handled by the [rstudioaopi](https://github.com/rstudio/rstudioapi) by default, thus requiring rstudio. The default method of credential capture is intended to discourage unsafe practices such as credentials being passed as plain text or stored in R scripts; howver, users can also pass usernames and passwords directly as function arguments.

#### With Configuration Files
Where ODBC configuration files are in place, users can connect to a database using `Connect()` and specifying a  data source name (dsn) .  Users can explore valid dsn's available to them before attempting to establish a connecting with the `DataSources()` function.
```
library(scones)

# To receive prompts for login credentials
Connect(dsn = "a_data_source_name")

# To connect without login credentials
Connect(dsn = "a_data_source_name", auth_prompt = FALSE)

# To connect whilst passing credentials as arguments (example using keyring R package)
Connect(dsn = "a_data_source_name", uid = "user_name",
        pwd = keyring::key_get("service_name, "user_name", "keyring_name"))
```
### List Available Schemas
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

### List Available Tables
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

### List Available Columns
`Columns()` retrieve the names of available columns in a specified table. Both the table name, and the name of the appropriate schema must be provided. Valid schema and table names can be retrieved using the `Schemas()` and `Tables()` functions. 
```
library(scones)

conn <- Connect(dsn = "a_data_source_name")

Columns(conn, schema = "a_schema_name",  table = "a_table_name")
```

### Querying
`Query()` allows users to submit a SQL query and return the results as a data.frame. The function is only suitable for SELECT type queries. More advanced functionality is provided by the [odbc](https://github.com/r-dbi/odbc) package, including write functionality. 
```
library(scones)

conn <- Connect(dsn = "a_data_source_name")

Query(conn, "SELECT * FROM dbo.a_named_table")
```

### Closing a Connection
Users should always close a connection once finished working with it.
```
library(scones)

conn <- Connect(dsn = "a_data_source_name")

Disconnect(conn)
```
