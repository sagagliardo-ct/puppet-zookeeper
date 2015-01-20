
class zookeeper::config(
  $ensure       = undef,

  $host         = undef,
  $port         = undef,

  $configdir    = undef,
  $datadir      = undef,
  $logdir       = undef,
  $logerror     = undef,

  $servicename  = undef,
  $executable   = undef,
) {
  $dir_ensure = $ensure ? {
    present => directory,
    default => absent,
  }

  if $::operatingsystem == 'Darwin' {
    include boxen::config

    file {
      "${boxen::config::envdir}/zookeeper.sh":
        ensure => absent ;

      "/Library/LaunchDaemons/${servicename}.plist":
      ensure   => $ensure,
      content  => template('zookeeper/dev.zookeeper.plist.erb'),
      group    => 'wheel',
      owner    => 'root' ;
    }

    ->
    boxen::env_script { 'zookeeper':
    ensure   => $ensure,
    content  => template('zookeeper/env.sh.erb'),
    priority => 'lower',
    }
  }

  file {
    [
      $configdir,
      $datadir,
      $logdir
    ]:
      ensure => $dir_ensure;

    "$configdir/zoo.cfg":
      ensure  => $ensure,
      content => template('zookeeper/zoo.cfg');

    "${configdir}/log4j.properties":
      ensure  => $ensure,
      content => template('zookeeper/default_log4j_properties');
  }

}
