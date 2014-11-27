# configure activemq package
class activemq::config {

  file {
    "${activemq::activemq_home}/conf/activemq.xml":
      ensure  => present,
      content => template('activemq/activemq.xml.erb'),
      require => Exec["Extract ${activemq::package}"];

    "${activemq::activemq_home}/lib/mysql-connector-java-5.1.33-bin.jar":
      ensure  => present,
      source  => 'puppet:///modules/activemq/mysql-connector-java-5.1.33-bin.jar',
      mode    => '0777',
      require => Exec["Extract ${activemq::package}"];
  }

  file { '/etc/init.d/activemq':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('activemq/activemq.init.erb');
  }
}
