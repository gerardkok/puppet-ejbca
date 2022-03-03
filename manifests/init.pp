# @summary Installs and configures EJBCA
#
# @example Minimal usage
#   include ejbca
#
# @param wildfly_version
#   The version of Wildfly to use.
# @param user
#   The user Wildfly runs as.
# @param group
#   The group Wildfly runs as.
# @param home
#   The home directory of [user](#user), as an absolute path.
# @param ejbca_source
#   The url to download the EJBCA source from.
# @param ejbca_basename
#   The basename of the source, without extension
# @param ejbca_install_dir
#   The absolute path to the directory the EJBCA source is unpacked to.
# @param database_driver
#   The name of the database driver EJBCA will use.
# @param database_driver_params
#   The parameters required to add the [database driver](#database_driver) to Wildfly, as a hash.
# @param db
#   The name of the EJBCA database.
# @param db_user
#   The database user to access the EJBCA db.
# @param db_password
#   The password for the [database user](#db_user).
# @param database_url
#   The url to access the [EJBCA database](#db).
# @param keystore_password
#   The password protecting the Java keystore.
# @param organization
#   Your organization.
# @param country
#   Your country.
# @param superadmin_cn
#   CN of the EJBCA SuperAdmin end entity.
# @param superadmin_password
#   Password for the EJBCA SuperAdmin end entity.
# @param api_client_cert_filename
#   The filename of the certificate that grants access to the EJBCA API.
# @param api_client_cert_path
#   Absolute path to a certificate that grants access to the EJBCA API.
# @param api_client_cert_password
#   Password protecting the certificate that grants access to the EJBCA API.
# @param vhost_name
#   Name of the virtual host that EJBCA will use.
# @param java_home
#   Absolute path to JAVA_HOME
# @param java_xms
#   Value of the -Xms Java parameter
# @param java_xmx
#   Value of the -Xmx Java parameter
# @param java_opts
#   Additional options to use with Java.
class ejbca (
  String $wildfly_version                               = '10.1.0',
  String $user                                          = 'ejbca',
  String $group                                         = 'ejbca',
  Stdlib::Absolutepath $home                            = "/home/${user}",
  Stdlib::Httpurl $ejbca_source                         = 'https://sourceforge.net/projects/ejbca/files/ejbca6/ejbca_6_15_2_6/ejbca_ce_6_15_2_6.zip',
  String $ejbca_basename                                = basename($ejbca_source, '.zip'),
  Stdlib::Absolutepath $ejbca_install_dir               = "${home}/${ejbca_basename}",
  Ejbca::Database_driver $database_driver               = 'h2',
  Ejbca::Database_driver_params $database_driver_params = ejbca::database_driver_params($database_driver),
  String $db                                            = 'ejbca',
  String $db_user                                       = 'ejbca',
  String $db_password                                   = 'ejbca',
  String $database_url                                  = ejbca::database_url($database_driver, $db),
  String $keystore_password                             = 'serverpwd',
  String $organization                                  = 'EJBCA Sample',
  String $country                                       = 'SE',
  String $superadmin_cn                                 = 'SuperAdmin',
  String $superadmin_password                           = 'ejbca',
  String $api_client_cert_filename                      = downcase($superadmin_cn),
  Stdlib::Absolutepath $api_client_cert_path            = "${ejbca_install_dir}/p12/${api_client_cert_filename}.p12",
  String $api_client_cert_password                      = 'ejbca',
  Stdlib::Fqdn $vhost_name                              = $facts['fqdn'],
  Stdlib::Absolutepath $java_home                       = '/usr/lib/jvm/java-8-openjdk-amd64',
  String $java_xms                                      = '2048m',
  String $java_xmx                                      = '2048m',
  String $java_opts                                     = '-Djava.net.preferIPv4Stack=true',
  Boolean $add_datasource                               = false,
  Integer $wildfly_reload_retries                       = 4,
  Integer $wildfly_reload_wait                          = 30
) {
  contain ejbca::wildfly::install
  contain ejbca::wildfly::config
  contain ejbca::install
  contain ejbca::config
  contain ejbca::api_config

  Class['ejbca::install']
  -> Class['ejbca::wildfly::install']
  -> Class['ejbca::wildfly::config']
  -> Class['ejbca::config']
  -> Class['ejbca::api_config']
}
