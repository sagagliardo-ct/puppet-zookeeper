class zookeeper {
  include zookeeper::config
  include homebrew

  file { [
    $zookeeper::config::configdir,
    $zookeeper::config::datadir,
    $zookeeper::config::logdir
  ]:
    ensure => directory,
  }

  homebrew::formula { 'zookeeper':
    source => 'puppet:///modules/zookeeper/brews/zookeeper.rb',
    before => Package['boxen/brews/zookeeper'] ;
  }

  package { 'boxen/brews/zookeeper':
    ensure => $zookeeper::config::version,
    require => [
      File["${zookeeper::config::configdir}/zoo.cfg"],
      File["${zookeeper::config::configdir}/defaults"],
      File["${zookeeper::config::configdir}/default_log4j_properties"],
    ],
  }

  # Config Files

  file { "${zookeeper::config::configdir}/zoo.cfg":
    content => template('zookeeper/zoo.cfg'),
    require => File[$zookeeper::config::configdir],
  }

  file { "${zookeeper::config::configdir}/defaults":
    content => template('zookeeper/defaults'),
    require => File[$zookeeper::config::configdir],
  }

  file { "${zookeeper::config::configdir}/log4j.properties":
    content => template('zookeeper/default_log4j_properties'),
    require => File[$zookeeper::config::configdir],
  }

  # Shims for shell commands

  zookeeper::shim { "zkServer": }
  zookeeper::shim { "zkCli": }
  zookeeper::shim { "zkCleanup": }

  # Fire up our service

  file { '/Library/LaunchDaemons/dev.zookeeper.plist':
    content => template('zookeeper/dev.zookeeper.plist.erb'),
    group   => 'wheel',
    owner   => 'root',
    notify  => Service['dev.zookeeper'],
  }

  service { 'dev.zookeeper':
    ensure  => running,
    require => [
      File['/Library/LaunchDaemons/dev.zookeeper.plist'],
      Package['boxen/brews/zookeeper'],
    ],
  }

}