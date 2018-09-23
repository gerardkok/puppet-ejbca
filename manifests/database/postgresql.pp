# @summary Install PostgresQL and create a database
# @example
#   include ejbca::database::postgresql
class ejbca::database::postgresql {
  include ejbca

  class { 'postgresql::server':
  }

  postgresql::server::db {
    $ejbca::db:
      user     => $ejbca::db_user,
      password => postgresql_password($ejbca::db_user, $ejbca::db_password);
  }
}
