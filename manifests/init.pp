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
  String $wildfly_version                               = $::ejbca::params::wildfly_version,
  String $user                                          = $::ejbca::params::user,
  String $group                                         = $::ejbca::params::group,
  Stdlib::Absolutepath $home                            = "/home/${user}",
  Stdlib::Httpurl $ejbca_source                         = $::ejbca::params::ejbca_source,
  String $ejbca_basename                                = basename($ejbca_source, '.zip'),
  Stdlib::Absolutepath $ejbca_install_dir               = "${home}/${ejbca_basename}",
  Ejbca::Database_driver $database_driver               = $::ejbca::params::database_driver,
  Ejbca::Database_driver_params $database_driver_params = ejbca::database_driver_params($database_driver),
  String $db                                            = $::ejbca::params::db,
  String $db_user                                       = $::ejbca::params::db_user,
  String $db_password                                   = $::ejbca::params::db_password,
  String $database_url                                  = ejbca::database_url($database_driver, $db),
  String $keystore_password                             = $::ejbca::params::keystore_password,
  String $organization                                  = $::ejbca::params::organization,
  String $country                                       = $::ejbca::params::country,
  String $superadmin_cn                                 = $::ejbca::params::superadmin_cn,
  String $superadmin_password                           = $::ejbca::params::superadmin_password,
  String $api_client_cert_filename                      = downcase($superadmin_cn),
  Stdlib::Absolutepath $api_client_cert_path            = "${ejbca_install_dir}/p12/${api_client_cert_filename}.p12",
  String $api_client_cert_password                      = $superadmin_password,
  Stdlib::Fqdn $vhost_name                              = $facts['fqdn'],
  Stdlib::Absolutepath $java_home                       = $::ejbca::params::java_home,
  String $java_xms                                      = $::ejbca::params::java_xms,
  String $java_xmx                                      = $::ejbca::params::java_xmx,
  String $java_opts                                     = $::ejbca::params::java_opts
) inherits ::ejbca::params {
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
