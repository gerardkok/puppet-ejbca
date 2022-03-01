function ejbca::database_driver_params(Ejbca::Database_driver $driver) >> Ejbca::Database_driver_params {
  case $driver {
    'mariadb': {
      {
        'database_name'                   => 'mysql',
        'driver_module_name'              => 'org.mariadb',
        'driver_module_source'            => 'https://downloads.mariadb.com/Connectors/java/connector-java-2.2.6/mariadb-java-client-2.2.6.jar',
        'driver_name'                     => 'org.mariadb.jdbc.Driver',
        'driver_xa_datasource_class_name' => 'org.mariadb.jdbc.MariaDbDataSource'
      }
    }
    'mysql': {
      {
        'database_name'                   => 'mysql',
        'driver_module_name'              => 'com.mysql',
        'driver_module_source'            => 'https://repo1.maven.org/maven2/mysql/mysql-connector-java/8.0.28/mysql-connector-java-8.0.28.jar',
        'driver_name'                     => 'com.mysql.jdbc.Driver',
        'driver_xa_datasource_class_name' => 'com.mysql.cj.jdbc.MysqlXADataSource'
      }
    }
    'postgresql': {
      {
        'database_name'                   => 'postgres',
        'driver_module_name'              => 'org.postgresql',
        'driver_module_source'            => 'https://jdbc.postgresql.org/download/postgresql-42.2.5.jar',
        'driver_name'                     => 'org.postgresql.Driver',
        'driver_xa_datasource_class_name' => 'org.postgresql.xa.PGXADataSource'
      }
    }
    default: {
      {
        'database_name'                   => 'h2',
        'driver_module_name'              => 'com.h2database.h2',
        'driver_module_source'            => 'https://repo1.maven.org/maven2/com/h2database/h2/1.3.175/h2-1.3.175.jar',
        'driver_name'                     => 'h2',
        'driver_xa_datasource_class_name' => 'org.h2.jdbcx.JdbcDataSource'
      }
    }
  }
}
