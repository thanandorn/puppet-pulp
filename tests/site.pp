node default {

  exec { 'yum-update':
    command => '/usr/bin/yum -y update > /dev/null',
  } ->
  exec { 'install-redhat_lsb':
    command => '/usr/bin/yum -y install redhat-lsb > /dev/null',
  } ->
  host { 'pulp.example.com':
    ip => '127.0.0.1',
  } ->

  # Pulp Installation
  class { 'pulp::yum': } ->
  class { 'pulp::server':
    server_name => 'pulp.example.com',
  } ->
  class { 'pulp::admin':
    pulpserver_host => 'pulp.example.com',
    admin_login     => 'admin',
    admin_passwd    => 'new_password',
  } ->
  class { 'pulp::consumer':
    pulpserver_host => 'pulp.example.com',
    admin_login     => 'admin',
    admin_passwd    => 'new_password',
  } ->
  pulp::repo { 'varnish-el6-x86_64':
    feedurl => 'http://repo.varnish-cache.org/redhat/varnish-3.0/el6/x86_64/',
  } ->
  pulp::consumer::bind { 'varnish-el6-x86_64': } ->
  pulp::consumer::group { 'cache-servers': } ->
  pulp::consumer::group::members { 'cache-servers':
    consumerid => $::hostname,
  }
}
