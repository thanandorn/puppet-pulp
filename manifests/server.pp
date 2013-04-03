class pulp::server (
  $db_name     = 'pulp_database',
  $db_host     = 'localhost',
  $db_port     = '27017',
  $db_retries  = '2',
  $server_name = "localhost",
  $def_login   = 'admin',
  $def_passwd  = 'admin',
  $user_expire = '365',
  $cons_expire = '3650',
  $cons_life   = '180',
  $msgq_server = 'localhost',
  $msgq_port   = '5672',
  $email_host  = 'localhost',
  $email_port  = '25',
  $email_from  = 'no-reply@example.com',
  $email       = 'false'
) {

  $packagelist = ['pulp-server', 'pulp-selinux', 'pulp-rpm-plugins', 'pulp-puppet-plugins']

  package { $packagelist:
    ensure => installed,
  }

  service { 'mongod':
    ensure  => running,
    enable  => true,
    require => Package[$packagelist],
  }

  service { 'qpidd':
    ensure  => running,
    enable  => true,
    require => Package[$packagelist],
  }

  file { '/etc/pulp/server.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('pulp/server.conf.erb'),
    notify  => Service['httpd'],
    require => Package[$packagelist],
  }

  exec { 'pulp-server-init':
    command => '/usr/bin/pulp-manage-db && touch /var/lib/pulp/init.flag',
    creates => '/var/lib/pulp/init.flag',
    notify  => Service['httpd'],
    require => [
      Package[$packagelist],
      File['/etc/pulp/server.conf'],
      Service['mongod'],
    ],
  }

  service { 'httpd':
    ensure  => running,
    enable  => true,
    require => [
      Package[$packagelist],
      File['/etc/pulp/server.conf'],
      Exec['pulp-server-init'],
      Service['qpidd'],
    ],
  }
}
