type Ejbca::Database_driver_params = Struct[
  {
    database_name                   => Enum['db2', 'derby', 'h2', 'informix', 'ingres', 'mssql', 'mysql', 'oracle', 'postgres', 'sybase'],
    driver_module_name              => String,
    driver_module_source            => Variant[Pattern[/^\./], Pattern[/^file:\/\//], Pattern[/^puppet:\/\//], Stdlib::Httpurl],
    driver_name                     => String,
    driver_xa_datasource_class_name => String
  }
]
