# @summary Install database
#
# @example
#   include ejbca::database
class ejbca::database {
  include ejbca

  if $ejbca::manage_database {
    case $ejbca::database_driver {
      'mariadb', 'mysql': { contain ejbca::database::mysql }
      'postgresql': { contain ejbca::database::postgresql }
      default: {} # use h2; no database setup needed
    }
  }
}
