# -*- mode: ruby -*-
# vi: set ft=ruby 

$pulp_init = <<SCRIPT
service iptables stop
chkconfig iptables off
yum -y install redhat-lsb
yum -y update
puppet apply --verbose --show_diff --manifestdir /tmp/vagrant-puppet/manifests --detailed-exitcodes /tmp/vagrant-puppet/manifests/site.pp
SCRIPT

Vagrant.configure("2") do |config|

  # Default box configuration is for Virtualbox
  config.vm.box = "centos64"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
  config.ssh.forward_agent = true

  # Puppet Config Provisioning
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "./tests/"
    puppet.manifest_file  = "site.pp"
    puppet.options        = "--verbose --show_diff"
  end

  # Virtual Machines
  config.vm.define "pulp" do |pulp|
    pulp.vm.hostname = "pulp.example.com"
    pulp.vm.network  "private_network", ip: "10.10.10.100"
    pulp.vm.synced_folder "./manifests", "/etc/puppet/modules/pulp/manifests"
    pulp.vm.synced_folder "./templates", "/etc/puppet/modules/pulp/templates"
    pulp.vm.provision "shell", inline: $pulp_init
  end

  config.vm.define "consumer1" do |consumer1|
    consumer1.vm.hostname = "consumer1.example.com"
    consumer1.vm.network  "private_network", ip: "10.10.10.200"
    consumer1.vm.synced_folder "./manifests", "/etc/puppet/modules/pulp/manifests"
    consumer1.vm.synced_folder "./templates", "/etc/puppet/modules/pulp/templates"
    consumer1.vm.provision "shell", inline: $pulp_init
  end
end
