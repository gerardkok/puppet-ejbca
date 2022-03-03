function ejbca::database_url(Ejbca::Database_driver $driver, String $db) >> String {
  case $driver {
    'mariadb', 'mysql5', 'mysql8': { "jdbc:mysql://127.0.0.1:3306/${db}?characterEncoding=UTF-8" }
    'postgresql': { "jdbc:postgresql://127.0.0.1/${db}" }
    default: { 'jdbc:h2:~/ejbcadb;DB_CLOSE_DELAY=-1' }
  }
}
