# @summary Configure access to the EJBCA API
#
# @example
#   include ejbca::api_config
class ejbca::api_config {
  include ejbca

  $ejbcaws_config = {
    'client_certificate_path' => $ejbca::api_client_cert_path,
    'client_certificate_password' => $ejbca::api_client_cert_password
  }

  package {
    ['gcc', 'git', 'make', 'zlib1g-dev']:
      ensure => 'present';
  }
  -> package {
    'savon':
      ensure   => 'present',
      provider => 'puppet_gem';
  }

  file {
    '/etc/puppetlabs/puppet/ejbcaws.yaml':
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => to_yaml($ejbcaws_config);
  }
}
