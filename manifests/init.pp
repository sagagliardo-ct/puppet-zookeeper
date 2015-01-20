# Public: Install Zookeeper and run as a persistent service
#
# Examples
#
#   include zookeeper
#
class zookeeper(
  $ensure      = undef,

  $host        = undef,
  $port        = undef,

  $configdir   = undef,
  $datadir     = undef,
  $logdir      = undef,
  $logerror    = undef,

  $package     = undef,
  $version     = undef,

  $servicename = undef,
  $executable  = undef,
){
  if $::operatingsystem == 'Darwin' {
    homebrew::formula { 'zookeeper': }
    ->
    Package[$package]
  }

  class { 'zookeeper::config':
    ensure      => $ensure,

    host        => $host,
    port        => $port,

    configdir   => $configdir,
    datadir     => $datadir,
    logdir      => $logdir,
    logerror    => $logerror,

    servicename => $servicename,
    executable  => $executable,
  }

  ~>
  package { $package:
    ensure  => $version,

    alias => 'zookeeper'
  }


  file { "${configdir}/defaults":
    content => template('zookeeper/defaults'),
    require => File[$configdir],
  }


  # Shims for shell commands

  zookeeper::shim { 'zkServer': }
  zookeeper::shim { 'zkCli': }
  zookeeper::shim { 'zkCleanup': }

  # Fire up our service
  service { $servicename:
    ensure  => running,
  }

}
