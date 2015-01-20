# Public: Install Zookeeper and run as a persistent service
#
# Examples
#
#   include zookeeper
#
class zookeeper(
  $ensure      = undef,
  $enable      = undef,

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
  validate_string(
    $ensure,
    $host,
    $port,
    $package,
    $version,
    $servicename,
    $executable,
  )

  validate_absolute_path(
    $configdir,
    $datadir,
    $logdir,
    $logerror,
  )

  validate_bool(
    $enable,
  )

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


  ~>
  class { 'zookeeper::service':
    ensure      => $ensure,
    enable      => $enable,

    servicename => $servicename,
  }
}
