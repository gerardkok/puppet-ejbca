# @summary Configure Wildfly
#
# @example
#   include ejbca::wildfly::config
class ejbca::wildfly::config {
  include ejbca

  if $ejbca::add_datasource {
    wildfly::datasources::datasource {
      'ejbcads':
        config  => {
          'driver-name'                    => $ejbca::database_driver_params['driver_name'],
          'connection-url'                 => $ejbca::database_url,
          'jndi-name'                      => 'java:/EjbcaDS',
          'user-name'                      => $ejbca::db_user,
          'password'                       => $ejbca::db_password,
          'use-ccm'                        => true,
          'validate-on-match'              => true,
          'background-validation'          => false,
          'prepared-statements-cache-size' => 50,
          'share-prepared-statements'      => true,
          'min-pool-size'                  => 5,
          'max-pool-size'                  => 150,
          'pool-prefill'                   => true,
          'transaction-isolation'          => 'TRANSACTION_READ_COMMITTED',
          'check-valid-connection-sql'     => 'select 1;'
        },
        require => Wildfly::Datasources::Driver['database driver'],
        notify  => Wildfly::Reload['reload after adding datasource'];
    }
  }

  wildfly::config::module {
    $ejbca::database_driver_params['driver_module_name']:
      source       => $ejbca::database_driver_params['driver_module_source'],
      dependencies => ['javax.api', 'javax.transaction.api'];
  }
  -> wildfly::datasources::driver {
    'database driver':
      driver_name                     => $ejbca::database_driver_params['driver_name'],
      driver_module_name              => $ejbca::database_driver_params['driver_module_name'],
      driver_xa_datasource_class_name => $ejbca::database_driver_params['driver_xa_datasource_class_name'];
  }
  ~> wildfly::reload {
    'reload after adding datasource':
      retries => $ejbca::wildfly_reload_retries,
      wait    => $ejbca::wildfly_reload_wait;
  }
  -> wildfly::resource {
    '/subsystem=remoting/http-connector=http-remoting-connector':
      content => {
        'connector-ref'  => 'remoting',
        'security-realm' => 'ApplicationRealm'
      };

    '/socket-binding-group=standard-sockets/socket-binding=remoting':
      content => {
        'port' => 4447
      };

    '/subsystem=undertow/server=default-server/http-listener=remoting':
      content => {
        'socket-binding' => 'remoting'
      };

    '/subsystem=webservices':
      content => {
        'wsdl-host'           => 'jbossws.undefined.host',
        'modify-wsdl-address' => true
      };

    [ '/subsystem=undertow/server=default-server/http-listener=default',
      '/subsystem=undertow/server=default-server/https-listener=https',
      '/socket-binding-group=standard-sockets/socket-binding=https' ]:
      ensure => 'absent';
  }
  ~> wildfly::reload {
    'reload after configuring remoting':
      retries => $ejbca::wildfly_reload_retries,
      wait    => $ejbca::wildfly_reload_wait;
  }
  -> wildfly::system::property {
    [ 'org.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH',
      'org.apache.catalina.connector.CoyoteAdapter.ALLOW_BACKSLASH',
      'org.apache.catalina.connector.USE_BODY_ENCODING_FOR_QUERY_STRING' ]:
      value => 'true'; # lint:ignore:quoted_booleans

    'org.apache.catalina.connector.URI_ENCODING':
      value => 'UTF-8';
  }
  ~> wildfly::reload {
    'reload after configuring protocol behaviour':
      retries => $ejbca::wildfly_reload_retries,
      wait    => $ejbca::wildfly_reload_wait;
  }
  -> ejbca::wildfly::interface {
    'http':
      port => 8080;

    'httpspub':
      port => 8442;

    'httpspriv':
      port => 8443;
  }
  ~> wildfly::reload {
    'reload after configuring interfaces':
      retries => $ejbca::wildfly_reload_retries,
      wait    => $ejbca::wildfly_reload_wait;
  }
}
