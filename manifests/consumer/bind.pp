#
# Only available for RPM repositories
#
define pulp::consumer::bind (
  $type   = 'rpm',
  $ensure = present,
  $repoid = $name
) {

  case $ensure {
    default: { err("unknown ensure value ${ensure}") }
    present: {
      exec { "pulp-consumer-bind-${repoid}":
        command => "pulp-consumer $type bind --repo-id ${repoid}",
        unless  => "/bin/grep \"name.*=.*${repoid}\" /etc/yum.repos.d/pulp.repo",
        path    => ['/usr/bin', '/bin'],
        require => Package['pulp-consumer-client'],
      }
    }
    absent: {
      exec { "pulp-consumer-unbind-${repoid}":
        command => "pulp-consumer $type unbind --repo-id ${repoid} --force",
        onlyif  => "/bin/grep \"name.*=.*${repoid}\" /etc/yum.repos.d/pulp.repo",
        path    => ['/usr/bin', '/bin'],
        require => Package['pulp-consumer-client'],
      }
    }
  }
}

