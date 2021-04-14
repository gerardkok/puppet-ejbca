# @summary Default parameter values
#
# @example
#   include ejbca::params
class ejbca::params {
  $wildfly_version = '10.1.0'
  $user = 'ejbca'
  $group = 'ejbca'
  $ejbca_source = 'https://sourceforge.net/projects/ejbca/files/ejbca6/ejbca_6_15_2_6/ejbca_ce_6_15_2_6.zip'
  $database_driver = 'h2'
  $db = 'ejbca'
  $db_user = 'ejbca'
  $db_password = 'ejbca'
  $keystore_password = 'serverpwd'
  $organization = 'EJBCA Sample'
  $country = 'SE'
  $superadmin_cn = 'SuperAdmin'
  $superadmin_password = 'ejbca'
  $java_home = '/usr/lib/jvm/java-8-openjdk-amd64'
  $java_xms = '2048m'
  $java_xmx = '2048m'
  $java_opts = '-Djava.net.preferIPv4Stack=true'
}
