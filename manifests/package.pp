class activemq::package {

  file {
    $activemq::local_package_dir:
      ensure => directory;

    $activemq::base_dir:
      ensure => directory;

    "${activemq::local_package_dir}/${activemq::package}":
      ensure  => present,
      source  => "puppet:///modules/activemq/${activemq::package}",
      require => File[$activemq::local_package_dir];
  }

  exec {

    "Extract ${activemq::package}":
      command => "/bin/tar xvfz ${activemq::local_package_dir}/${activemq::package}",
      cwd     => $activemq::base_dir,
      unless  => "/usr/bin/test -d ${activemq::activemq_home}/conf",
      creates => "${activemq::activemq_home}/conf",
      require =>  [
        File[$activemq::base_dir],
        File["${activemq::local_package_dir}/${activemq::package}"],
        ];

    'Setting permission for activemq':
      command   => "/bin/chown -R ${activemq::owner}:${activemq::group} ${activemq::activemq_home};
                    /bin/chmod -R 755 ${activemq::activemq_home}",
      cwd       => $activemq::base_dir,
      logoutput => 'on_failure',
      timeout   => 0,
      require   => Exec["Extract ${activemq::package}"];
  }
}
