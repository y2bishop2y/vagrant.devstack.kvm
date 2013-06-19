# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "base"

  config.vm.define :devstack do |devstack_config|
 
    devstack_config.vm.box = "precise64"
    devstack_config.vm.box_url = "http://files.vagrantup.com/precise64.box"

    # Puppet wants a host that is FQDN
    devstack_config.vm.hostname = "devstack.kvm"
    # devstack_config.vm.host_name = dhostname

    # devstack_config.vm.boot_mode = :gui
    devstack_config.vm.network  :private_network, ip: "192.168.7.201", :netmask => "255.255.0.0"
    devstack_config.vm.network  :private_network, ip: "10.10.7.201",   :netmask => "255.255.0.0"

    devstack_config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", 16384]
      v.customize ["modifyvm", :id, "--cpus",   4]
    end

    devstack_config.ssh.max_tries = 100

    devstack_config.vm.provision :puppet do |devstack_puppet|
      devstack_puppet.pp_path        = "/tmp/vagrant-puppet"
      devstack_puppet.module_path    = "puppet/modules"
      devstack_puppet.manifests_path = "puppet/manifests"
      devstack_puppet.manifest_file  = "site.pp"
    end
  end



end
