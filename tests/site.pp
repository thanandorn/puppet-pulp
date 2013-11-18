node default {
  # Init
  exec { 'iptables-off':
    command => '/sbin/iptables -F',
  } ->
  host {
    'pulp.example.com':
      ip => '10.10.10.100';
    'consumer1.example.com':
      ip => '10.10.10.200';
  }
}

node /pulp/ inherits default {

  # Init
  Host <||> ->

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

node /consumer/ inherits default {

  # Init
  Host <||> ->

  # Pulp Installation
  class { 'pulp::yum': } ->
  class { 'pulp::consumer':
    pulpserver_host => 'pulp.example.com',
    admin_login     => 'admin',
    admin_passwd    => 'new_password',
  } ->
  pulp::consumer::bind { 'varnish-el6-x86_64': }
}
