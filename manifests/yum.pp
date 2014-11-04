class pulp::yum ($major_release = '6') {

  yumrepo { 'pulp-init':
    name     => "pulp-init",
    baseurl  => "http://repos.fedorapeople.org/repos/pulp/pulp/stable/latest/${major_release}Server/${architecture}/",
    enabled  => 1,
    gpgcheck => 0,
  }

  yumrepo { 'pulp-epel':
    name     => "pulp-epel",
    baseurl  => "http://mirrors.coreix.net/fedora-epel/${major_release}/${architecture}/",
    enabled  => 1,
    gpgcheck => 0,
  }
}
