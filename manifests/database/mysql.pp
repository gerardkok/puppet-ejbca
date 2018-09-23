# @summary Install MySQL or MariaDB, and create a database
#
# @example
#   include ejbca::database::mysql
class ejbca::database::mysql {
  include ejbca

  if $ejbca::database_driver == 'mariadb' {
    $client_package_name = 'mariadb-client'
    $server_package_name = 'mariadb-server'
    $server_service_name = 'mysql'
    $override_options    =  {
      mysqld => {
        'log-error' => '/var/log/mysql/mariadb.log',
        'pid-file'  => '/var/run/mysqld/mysqld.pid'
      },
      mysqld_safe => {
        'log-error' => '/var/log/mysql/mariadb.log'
      }
    }
  } else {
    $client_package_name = undef
    $server_package_name = undef
    $server_service_name = undef
    $override_options = {}
  }

  $server_override_options = merge($ejbca::mysql_server_override_options, $override_options)

  class {
    'mysql::server':
      package_name            => $server_package_name,
      service_name            => $server_service_name,
      root_password           => $ejbca::mysql_root_password,
      remove_default_accounts => true,
      override_options        => $server_override_options;

    'mysql::client':
      package_name => $client_package_name;
  }

  mysql::db {
    $ejbca::db:
      user     => $ejbca::db_user,
      password => $ejbca::db_password,
      host     => 'localhost',
      grant    => ['CREATE', 'ALTER', 'SELECT', 'UPDATE', 'INSERT', 'DELETE', 'REFERENCES'],
      charset  => 'utf8',
      collate  => 'utf8_general_ci';
  }
}
