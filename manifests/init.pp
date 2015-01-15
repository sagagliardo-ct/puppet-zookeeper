# Public: Install Zookeeper and run as a persistent service
#
# Examples
#
#   include zookeeper
#
class zookeeper(
  $version     = undef,

  $port        = undef,

  $configdir   = undef,
  $datadir     = undef,
  $logdir      = undef,
  $logerror    = undef,

  $executable  = undef,
){
  include boxen::config

  file { [
    $configdir,
    $datadir,
    $logdir
  ]:
    ensure => directory,
  }

  package { 'boxen/brews/zookeeper':
    ensure => absent,
  }

  package { 'zookeeper':
    ensure  => $version,
    require => [
      File["$configdir/zoo.cfg"],
      File["$configdir/defaults"],
      File["$configdir/log4j.properties"],
    ],
  }

  # Config Files

  file { "$configdir/zoo.cfg":
    content => template('zookeeper/zoo.cfg'),
    require => File[$configdir],
  }

  file { "$configdir/defaults":
    content => template('zookeeper/defaults'),
    require => File[$configdir],
  }

  file { "$configdir/log4j.properties":
    content => template('zookeeper/default_log4j_properties'),
    require => File[$configdir],
  }

  file { "${boxen::config::envdir}/zookeeper.sh":
    content => template('zookeeper/env.sh.erb')
  }

  # Shims for shell commands

  zookeeper::shim { 'zkServer': }
  zookeeper::shim { 'zkCli': }
  zookeeper::shim { 'zkCleanup': }

  # Fire up our service

  file { '/Library/LaunchDaemons/dev.zookeeper.plist':
    content => template('zookeeper/dev.zookeeper.plist.erb'),
    group   => 'wheel',
    owner   => 'root',
    require => Package['zookeeper'],
    notify  => Service['dev.zookeeper'],
  }

  service { 'dev.zookeeper':
    ensure  => running,
  }

}
