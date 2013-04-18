define pulp::repo (
  $feedurl  = undef,
  $ensure   = present,
  $mirror   = true,
  $type     = 'rpm',
  $time     = '01:00:00',
  $interval = 'P5D'
) {

  case $ensure {
    default: { err("unknown ensure value ${ensure}") }
    present: {
      case $mirror {
        default: { err("unknown mirror value ${mirror}") }
        true: {
          exec { "pulp-${type}-repo-create-${name}":
            command => "pulp-admin ${type} repo create --repo-id ${name} --feed $feedurl \
                        && pulp-admin ${type} repo sync schedules create --repo-id ${name} -s \"$(date +%Y-%m-%d)T${time}Z/${interval}\" \
                        && pulp-admin ${type} repo sync run --repo-id ${name} --bg",
            unless  => "pulp-admin ${type} repo update --repo-id ${name} --description \"Last checked by Puppet on $(date)\"",
            path    => ['/usr/bin', '/bin'],
            require => Package['pulp-admin-client'],
          }
        }
        false: {
          exec { "pulp-${type}-repo-create-${name}":
            command => "pulp-admin ${type} repo create --repo-id ${name}",
            unless  => "pulp-admin ${type} repo update --repo-id ${name} --description \"Last checked by Puppet on $(date)\"",
            path    => ['/usr/bin', '/bin'],
            require => Package['pulp-admin-client'],
          }
        }
      }
    }
    absent: {
      exec { "pulp-${type}-repo-delete-${name}":
        command => "pulp-admin ${type} repo delete --repo-id ${name}",
        onlyif  => "pulp-admin ${type} repo update --repo-id ${name} --description \"Last checked by Puppet on $(date)\"",
        path    => ['/usr/bin', '/bin'],
        require => Package['pulp-admin-client'],
      }
    }
  }
}
