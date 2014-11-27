class activemq::service {
  service { 'activemq':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => [
      File["${activemq::activemq_home}/conf/activemq.xml"],
      File["${activemq::activemq_home}/lib/mysql-connector-java-5.1.33-bin.jar"],
      File['/etc/init.d/activemq'],
      ];
  }
}
