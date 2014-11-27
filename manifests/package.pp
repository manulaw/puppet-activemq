class activemq::package {

  file {
    $local_package_dir:
      ensure => directory;

    $activemq::base_dir:
      ensure => directory;

#    "${local_package_dir}/${activemq::package}":
#      ensure  => present,
#      source  => "puppet:///modules/activemq/${activemq::package}",
#      require => File[$local_package_dir];
  }

  exec {
    'Download activemq package':
      path      => '/opt/java/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      cwd       => $local_package_dir,
      unless    => "test -f ${local_package_dir}/${activemq::package}",
      command    => "wget -q ${package_repo}/${activemq::package}",
      logoutput => 'on_failure',
      creates   => "${local_package_dir}/${activemq::package}",
      require   => File[$local_package_dir];

    "Extract ${activemq::package}":
      path    => '/opt/java/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      cwd     => $activemq::base_dir,
      unless  => "test -d ${activemq::activemq_home}/conf",
      command => "tar xvfz ${local_package_dir}/${activemq::package}",
      creates => "${activemq::activemq_home}/conf",
      require =>  [
        File[$activemq::base_dir],
        Exec['Download activemq package'],
        ];

    "Setting permission for activemq":
      path      => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
      cwd       => $activemq::base_dir,
      command   => "chown -R ${activemq::owner}:${activemq::group} ${activemq::activemq_home};
                    chmod -R 755 ${activemq::activemq_home}",
      logoutput => 'on_failure',
      timeout   => 0,
      require   => Exec["Extract ${activemq::package}"];
  }
}
