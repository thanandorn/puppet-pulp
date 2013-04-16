define pulp::repo (
  $feedurl  = undef,
  $ensure   = present,
  $mirror   = true,
  $type     = 'rpm',
  $time     = '01:00:00',
  $interval = 'P5D') {

  case $ensure {
    default: { err("unknown ensure value ${ensure}") }
    present: {
      case $mirror {
        default: { err("unknown mirror value ${mirror}") }
        true: {
          exec { "pulp-${type}-repo-create-${name}":
            command => "/usr/bin/pulp-admin ${type} repo create --repo-id ${name} --feed $feedurl \
                        && /usr/bin/pulp-admin ${type} repo sync schedules create --repo-id ${name} -s \"$(date +%Y-%m-%d)T${time}Z/${interval}\" \
                        && /usr/bin/pulp-admin ${type} repo sync run --repo-id ${name} --bg",
            unless  => "/usr/bin/pulp-admin ${type} repo update --repo-id ${name} --description \"Last checked by Puppet on $(date)\"",
            require => Package['pulp-admin-client'],
          }
        }
        false: {
          exec { "pulp-${type}-repo-create-${name}":
            command => "/usr/bin/pulp-admin ${type} repo create --repo-id ${name}",
            unless  => "/usr/bin/pulp-admin ${type} repo update --repo-id ${name} --description \"Last checked by Puppet on $(date)\"",
            require => Package['pulp-admin-client'],
          }
        }
      }
    }
    absent: {
      exec { "pulp-${type}-repo-delete-${name}":
        command => "/usr/bin/pulp-admin ${type} repo delete --repo-id ${name}",
        onlyif  => "/usr/bin/pulp-admin ${type} repo update --repo-id ${name} --description \"Last checked by Puppet on $(date)\"",
        require => Package['pulp-admin-client'],
      }
    }
  }
}
