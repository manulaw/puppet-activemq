# Class: activemq
#
# This module manages ActiveMQ
#
# Sample Usage:
# node default {
#   class {'activemq': }
# }

class activemq(
  $version    = '5.10.0',
  $base_dir   = '/opt',
  $owner      = 'activemq',
  $group      = 'activemq',
  $webconsole = false,
) {

  $package       = "apache-activemq-${version}-bin.tar.gz"
  $activemq_home = "${base_dir}/apache-activemq-${version}"

  class { 'activemq::package': }

  class { 'activemq::config':
    notify => Class['activemq::service'],
  }

  class { 'activemq::service':
    require => Class['activemq::package'],
  }
}
