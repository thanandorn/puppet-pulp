class pulp::yum {

  @yumrepo {"pulp-init":
    baseurl  => "http://repos.fedorapeople.org/repos/pulp/pulp/v2/stable/${lsbmajdistrelease}Server/${architecture}/",
    enabled  => 1,
    gpgcheck => 0,
  }

  @yumrepo {"epel":
    baseurl  => "http://mirrors.coreix.net/fedora-epel/${lsbmajdistrelease}/${architecture}/",
    enabled  => 1,
    gpgcheck => 0,
  }
}
