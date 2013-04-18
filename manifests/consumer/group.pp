define pulp::consumer::group (
  $type    = 'rpm',
  $ensure  = present,
  $groupid = $name
) {

  case $ensure {
    default: { err("unknown ensure value ${ensure}") }
    present: {
      exec { "pulp-consumergroup-create-${groupid}":
        command => "pulp-admin $type consumer group create --group-id ${groupid}",
        unless  => "test \"$(pulp-admin $type consumer group list | grep Id | grep -o ${groupid} )\" = \"${groupid}\" ",
        path    => ['/usr/bin', '/bin'],
        require => Package['pulp-admin-client'],
      }
    }
    absent: {
      exec { "pulp-consumergroup-delete-${groupid}":
        command => "pulp-admin $type consumer group delete --group-id ${groupid}",
        onlyif  => "test \"$(pulp-admin $type consumer group list | grep Id | grep -o ${groupid} )\" = \"${groupid}\" ",
        path    => ['/usr/bin', '/bin'],
        require => Package['pulp-admin-client'],
      }
    }
  }
}

