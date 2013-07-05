class pulp::admin (
  $pulpserver_host = 'localhost',
  $pulpserver_port = '443',
  $default_login   = 'admin',
  $default_passwd  = 'admin',
  $admin_login     = 'admin',
  $admin_passwd
) {

  $packagelist = [
    'pulp-admin-client',
    'pulp-puppet-admin-extensions',
    'pulp-rpm-admin-extensions'
  ]

  package { $packagelist:
    ensure => installed,
  }

  file { '/etc/pulp/admin/admin.conf':
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => template('pulp/admin.conf.erb'),
    require => Package[$packagelist],
  }

  exec { 'pulp-admin-update-login':
    command => "pulp-admin -u ${default_login} -p ${default_passwd} auth user \
                update --login ${admin_login} --password ${admin_passwd} --name 'Pulp Administrator'",
    onlyif  => "pulp-admin -u ${default_login} -p ${default_passwd} \
                auth user update --login ${default_login} --password ${default_passwd}",
    path    => ['/usr/bin', '/bin'],
    require => [ Package[$packagelist], File['/etc/pulp/admin/admin.conf']],
  }

  exec { 'pulp-admin-login':
    command => "pulp-admin login --username ${admin_login} --password ${admin_passwd}",
    creates => '/root/.pulp/user-cert.pem',
    path    => ['/usr/bin', '/bin'],
    require => [
      Package[$packagelist],
      File['/etc/pulp/admin/admin.conf'],
      Exec['pulp-admin-update-login']
    ],
  }
}
