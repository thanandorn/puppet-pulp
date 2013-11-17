#
# Only RPM Consumer Supported
#
define pulp::consumer::group::members (
  $ensure  = 'present',
  $groupid = $name,
  $type    = 'rpm',
  $consumerid,
) {

  case $ensure {
    default: { err("unknown ensure value ${ensure}") }
    present: {
      exec { "pulp-consumergroup-${groupid}-add-${consumerid}" :
        command => "pulp-admin $type consumer group members add \
                    --group-id ${groupid} --consumer-id ${consumerid}",
        unless  => "test \"$(pulp-admin $type consumer group list \
                    | grep -A3 \"Id.*${groupid}\" \
                    | grep -o ${consumerid} )\" = \"${consumerid}\" ",
        path    => ['/usr/bin', '/bin'],
        require => Package['pulp-admin-client'],
      }
    }
    absent: {
      exec { "pulp-consumergroup-${groupid}-remove-${consumerid}" :
        command => "pulp-admin $type consumer group members remove \
                    --group-id ${groupid} --consumer-id ${consumerid}",
        onlyif  => "test \"$(pulp-admin $type consumer group list \
                    | grep -A3 \"Id.*${groupid}\" \
                    | grep -o ${consumerid} )\" = \"${consumerid}\" ",
        path    => ['/usr/bin', '/bin'],
        require => Package['pulp-admin-client'],
      }
    }
  }
}
