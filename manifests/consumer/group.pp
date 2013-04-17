define pulp::consumer::group (
  $type    = 'rpm',
  $ensure  = 'present',
  $groupid = $name) {

  case $ensure {
    default: { err("unknown ensure value ${ensure}") }
    present: {
      exec { "pulp-consumergroup-create-${groupid}":
        command => "/usr/bin/pulp-admin $type consumer group create --group-id ${groupid}",
        unless  => "test \"$(/usr/bin/pulp-admin $type consumer group list | grep Id | grep -o ${groupid} )\" = \"${groupid}\" ",
        require => Package['pulp-admin-client'],
      }
    }
    absent: {
      exec { "pulp-consumergroup-delete-${groupid}":
        command => "/usr/bin/pulp-admin $type consumer group delete --group-id ${groupid}",
        onlyif  => "test \"$(/usr/bin/pulp-admin $type consumer group list | grep Id | grep -o ${groupid} )\" = \"${groupid}\" ",
        require => Package['pulp-admin-client'],
      }
    }
  }
}

