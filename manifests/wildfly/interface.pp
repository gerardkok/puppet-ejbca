# @summary Create a Wildfly interface and socket-binding
#
# @example
#   ejbca::wildfly::interface { 'namevar': }
define ejbca::wildfly::interface(
  String $interface = $title,
  Integer $port     = undef
) {
  include ejbca

  wildfly::resource {
    "/interface=${interface}":
      content => {
        'inet-address' => '0.0.0.0'
      };

    "/socket-binding-group=standard-sockets/socket-binding=${interface}":
      content => {
        'port'      => $port,
        'interface' => $interface
      };
  }
}
