# @summary Configure EJBCA
#
# @example
#   include ejbca::config
class ejbca::config {
  include ejbca

  file {
    "${ejbca::ejbca_install_dir}/conf/database.properties":
      ensure  => 'present',
      owner   => $ejbca::user,
      group   => $ejbca::group,
      mode    => '0644',
      content => epp('ejbca/database.properties');

    "${ejbca::ejbca_install_dir}/conf/ejbca.properties":
      ensure => 'present',
      owner  => $ejbca::user,
      group  => $ejbca::group,
      mode   => '0644',
      source => 'puppet:///modules/ejbca/ejbca.properties';

    "${ejbca::ejbca_install_dir}/conf/web.properties":
      ensure  => 'present',
      owner   => $ejbca::user,
      group   => $ejbca::group,
      mode    => '0644',
      content => epp('ejbca/web.properties');

    "${ejbca::ejbca_install_dir}/conf/install.properties":
      ensure  => 'present',
      owner   => $ejbca::user,
      group   => $ejbca::group,
      mode    => '0644',
      content => epp('ejbca/install.properties');
  }
  -> exec {
    'ant clean build':
      user    => $ejbca::user,
      path    => '/usr/bin:/bin',
      cwd     => $ejbca::ejbca_install_dir,
      timeout => 0,
      creates => "${ejbca::ejbca_install_dir}/dist/ejbca.ear";
  }
  -> wildfly::deployment {
    'ejbca.ear':
      source => "file://${ejbca::ejbca_install_dir}/dist/ejbca.ear";
  }
  -> exec {
    'ant runinstall':
      user    => $ejbca::user,
      path    => '/usr/bin:/bin',
      cwd     => $ejbca::ejbca_install_dir,
      creates => "${ejbca::ejbca_install_dir}/p12/superadmin.p12";
  }
  -> exec {
    'ant deploy-keystore':
      user    => $ejbca::user,
      path    => '/usr/bin:/bin',
      cwd     => $ejbca::ejbca_install_dir,
      creates => '/opt/wildfly/standalone/configuration/keystore/keystore.jks';
  }
  -> wildfly::resource {
    '/core-service=management/security-realm=SSLRealm':
      content => {};
  }
  -> wildfly::resource {
    '/core-service=management/security-realm=SSLRealm/server-identity=ssl':
      content => {
        'keystore-path'     => '/opt/wildfly/standalone/configuration/keystore/keystore.jks',
        'keystore-password' => $ejbca::keystore_password,
        'alias'             => $ejbca::vhost_name
      };

    '/core-service=management/security-realm=SSLRealm/authentication=truststore':
      content => {
        'keystore-path'     => '/opt/wildfly/standalone/configuration/keystore/truststore.jks',
        'keystore-password' => 'changeit'
      };
  }
  ~> wildfly::reload {
    'reload after adding SSLRealm':
      retries => $ejbca::wildfly_reload_retries,
      wait    => $ejbca::wildfly_reload_wait;
  }
  -> wildfly::resource {
    '/subsystem=undertow/server=default-server/https-listener=httpspriv':
      content => {
        'socket-binding' => 'httpspriv',
        'security-realm' => 'SSLRealm',
        'verify-client'  => 'REQUIRED',
        'max-parameters' => 2048
      };

    '/subsystem=undertow/server=default-server/https-listener=httpspub':
      content => {
        'socket-binding' => 'httpspub',
        'security-realm' => 'SSLRealm',
        'max-parameters' => 2048
      };

    '/subsystem=undertow/server=default-server/http-listener=http':
      content => {
        'socket-binding'  => 'http',
        'redirect-socket' => 'httpspriv'
      };
  }
  ~> wildfly::reload {
    'reload after adding listeners':
      retries => $ejbca::wildfly_reload_retries,
      wait    => $ejbca::wildfly_reload_wait;
  }
}
