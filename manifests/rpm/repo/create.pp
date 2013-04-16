define pulp::rpm::repo::create ($feedurl, $time="01:00:00", $interval="P5D") {

  exec { "pulp-admin-rpm-repo-create-${name}":
    command => "/usr/bin/pulp-admin rpm repo create --repo-id ${name} --feed $feedurl \
                && /usr/bin/pulp-admin rpm repo sync schedules create --repo-id ${name} -s \"$(date +%Y-%m-%d)T${time}Z/${interval}\" \
                && /usr/bin/pulp-admin rpm repo sync run --repo-id ${name} --bg",
    unless  => "/usr/bin/pulp-admin rpm repo update --repo-id ${name} --description \"Last checked by Puppet on $(date)\"",
    require => Package['pulp-admin-client'],
  }
}
