class zookeeper::config {
  require boxen::config

  $version    = '3.4.5-boxen1'

  $configdir  = "${boxen::config::configdir}/zookeeper"
  $datadir    = "${boxen::config::datadir}/zookeeper"
  $logdir     = "${boxen::config::logdir}/zookeeper"

  $executable = "${boxen::config::homebrewdir}/bin/zkServer"

  $logerror   = "${logdir}/error.log"
  $port       = 12181
}
