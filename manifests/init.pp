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
    notify      => Service['zookeeper'],
  }

  ~>
  class { 'zookeeper::package':
    ensure    => $ensure,

    package   => $package,
    version   => $version,
    configdir => $configdir,
  }


  # Fire up our service
  ~>
  service { $servicename:
    ensure  => running,
    alias   => 'zookeeper',
  }

}
