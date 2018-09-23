# @summary Configure Wildfly
#
# @example
#   include ejbca::wildfly::config
class ejbca::wildfly::config {
  include ejbca

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
  ~> Wildfly::Reload['reload after adding remoting']

  wildfly::resource {
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
  ~> Wildfly::Reload['reload after adding remoting']

  wildfly::system::property {
    [ 'org.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH',
      'org.apache.catalina.connector.CoyoteAdapter.ALLOW_BACKSLASH',
      'org.apache.catalina.connector.USE_BODY_ENCODING_FOR_QUERY_STRING' ]:
      value => 'true'; # lint:ignore:quoted_booleans

    'org.apache.catalina.connector.URI_ENCODING':
      value => 'UTF-8';
  }
  ~> Wildfly::Reload['reload after adding remoting']

  ejbca::wildfly::interface {
    'http':
      port => 8080;

    'httpspub':
      port => 8442;

    'httpspriv':
      port => 8443;
  }
  ~> Wildfly::Reload['reload after adding remoting']

  wildfly::reload {
    'reload after adding remoting': ;
  }
}
