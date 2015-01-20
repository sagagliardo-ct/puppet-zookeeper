# Internal: service for zookeeper


class zookeeper::service(
  $ensure      = undef,

  $servicename = undef,
  $enable      = undef,
  ) {
    $real_ensure = $ensure? {
      present => running,
      default => stopped
    }

    service { $servicename:
      ensure => $real_ensure,
      enable => $enable,
      alias  => 'zookeeper'
    }
  }
