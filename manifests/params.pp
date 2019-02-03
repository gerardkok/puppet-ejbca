# @summary Default parameter values
#
# @example
#   include ejbca::params
class ejbca::params {
  $wildfly_version = '10.1.0'
  $user = 'ejbca'
  $group = 'ejbca'
  $home = "/home/${user}"
  $ejbca_source = 'https://sourceforge.net/projects/ejbca/files/ejbca6/ejbca_6_10_0/ejbca_ce_6_10_1_2.zip'
  $ejbca_basename = basename($ejbca_source, '.zip')
  $ejbca_install_dir = "${home}/${ejbca_basename}"
  $database_driver = 'h2'
  $db = 'ejbca'
  $db_user = 'ejbca'
  $db_password = 'ejbca'
  $keystore_password = 'serverpwd'
  $organization = 'EJBCA Sample'
  $country = 'SE'
  $superadmin_cn = 'SuperAdmin'
  $superadmin_password = 'ejbca'
  $api_client_cert_filename = downcase($superadmin_cn)
  $api_client_cert_path = "${ejbca_install_dir}/p12/${api_client_cert_filename}.p12"
  $api_client_cert_password = $superadmin_password
  $vhost_name = $facts['fqdn']
  $java_xms = '2048m'
  $java_xmx = '2048m'
  $java_opts = '-Djava.net.preferIPv4Stack=true'
}
