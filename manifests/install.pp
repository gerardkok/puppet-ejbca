# @summary Install EJBCA
# @example
#   include ejbca::install
class ejbca::install {
  include ejbca

  group {
    $ejbca::group:
      ensure => present;
  }

  user {
    $ejbca::user:
      ensure => present,
      gid    => $ejbca::group,
      shell  => '/bin/bash',
      home   => $ejbca::home;
  }

  file {
    $ejbca::home:
      ensure => directory,
      owner  => $ejbca::user,
      group  => $ejbca::group,
      mode   => '0755';
  }

  package {
    'unzip':
      ensure => present;
  }
  -> archive {
    "/var/cache/${ejbca::ejbca_basename}.zip":
      provider     => 'wget',
      source       => $ejbca::ejbca_source,
      extract      => true,
      extract_path => $ejbca::home,
      user         => $ejbca::user,
      group        => $ejbca::group,
      creates      => $ejbca::ejbca_install_dir,
      cleanup      => true,
      require      => File[$ejbca::home];
  }

  package {
    'ant':
      ensure => 'present';
  }
}
