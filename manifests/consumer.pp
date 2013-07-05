class pulp::consumer (
  $pulpserver_host = 'localhost',
  $admin_login     = 'admin',
  $admin_passwd,
) {

  $packagelist = [
    'pulp-consumer-client',
    'pulp-puppet-handlers',
    'pulp-rpm-consumer-extensions',
    'pulp-rpm-handlers'
  ]

  package { $packagelist:
    ensure  => installed,
  }

  file { "/etc/pulp/consumer/consumer.conf":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('pulp/consumer.conf.erb'),
    require => Package[$packagelist],
    notify  => Service['goferd'],
  }

  exec { 'pulp-consumer-register':
    command => "pulp-consumer -u $admin_login -p $admin_passwd register \
                --consumer-id $::hostname --display-name $::fqdn",
    creates => '/etc/pki/pulp/consumer/consumer-cert.pem',
    path    => ['/usr/bin', '/bin'],
    require => [
      Package[$packagelist],
      File['/etc/pulp/consumer/consumer.conf']
    ],
  }

  service { 'goferd':
    ensure  => running,
    enable  => true,
    require => [
      Package[$packagelist],
      File['/etc/pulp/consumer/consumer.conf'],
      Exec['pulp-consumer-register']
    ],
  }
}
