# Creates a shim wrapper script for the Zookeeper executables

define zookeeper::shim() {
  require zookeeper::config

  $libexec = "${boxen::config::homebrewdir}/Cellar/zookeeper/${zookeeper::config::version}/libexec"

  file { "${boxen::config::homebrewdir}/bin/${name}":
    content => template('zookeeper/shim_script'),
    mode    => '0755',
    owner   => $::boxen_user,
    group   => staff,
    require => Package['zookeeper']
  }
}
