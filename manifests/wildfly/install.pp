# @summary Install Wildfly
#
# @example
#   include ejbca::wildfly::install
class ejbca::wildfly::install {
  include java
  include ejbca

  class {
    'wildfly':
      version           => $ejbca::wildfly_version,
      install_source    => "https://download.jboss.org/wildfly/${ejbca::wildfly_version}.Final/wildfly-${ejbca::wildfly_version}.Final.tar.gz",
      install_cache_dir => '/var/cache',
      java_home         => '/usr/lib/jvm/java-8-openjdk-amd64',
      java_xms          => $ejbca::java_xms,
      java_xmx          => $ejbca::java_xmx,
      java_opts         => $ejbca::java_opts,
      manage_user       => false,
      user              => $ejbca::user,
      group             => $ejbca::group;
  }
}
