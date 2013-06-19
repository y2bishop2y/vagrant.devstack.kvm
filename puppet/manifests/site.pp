#============================
#----------------------------
node /^devstack/ {


  exec { "apt-get update":
    command => "/usr/bin/apt-get update && touch /tmp/apt.update",
  }
  
  # class { 'emacs': }    
  class { 'tree':  }



  #=========================
  #-------------------------
  $trema = false


  if $trema {
    $source = "https://github.com/nec-openstack/devstack-quantum-nec-openflow.git"
  }
  else {
    $source = "https://github.com/openstack-dev/devstack.git"
  }


  # Ensure Git is installed
  package { 'git':
    ensure => 'present'
  }

  package { 'pm-utils':
    ensure => 'present'
  }
    

  # Clone the devstack repo
  vcsrepo { "/home/vagrant/work/devstack":
    ensure    => present,
    provider  => git,
    source    => $source,
    user      => 'vagrant',
    require    => Package['git'],
  }
  
  $localrc_cnt = "
ADMIN_PASSWORD=admin
MYSQL_PASSWORD=admin
RABBIT_PASSWORD=admin
SERVICE_PASSWORD=admin
SERVICE_TOKEN=admin

APACHE_USER=vagrant
API_RATE_LIMIT=False
HOST_IP=192.168.5.201

VLAN_INTERFACE=eth1
FLAT_INTERFACE=eth1
GUEST_INTERFACE=eth1
PUBLIC_INTERFACE=eth2
FIXED_RANGE=192.168.6.0/24
FIXED_NETWORK_SIZE=256
FLOATING_RANGE=10.10.1.0/24
  
#=========================
#-------------------------
SYSLOG=True
SCREEN_LOGDIR=/opt/stack/logs/screen

#=========================
# Enable HEAT 
#-------------------------
ENABLED_SERVICES+=,heat,h-api,h-api-cfn,h-api-cw,h-eng
## It would also be useful to automatically download and register VM images that Heat can launch.
# 64bit image (~660MB)
IMAGE_URLS+=",http://fedorapeople.org/groups/heat/prebuilt-jeos-images/F17-x86_64-cfntools.qcow2"
# 32bit image (~640MB)
IMAGE_URLS+=",http://fedorapeople.org/groups/heat/prebuilt-jeos-images/F17-i386-cfntools.qcow2"

  
"

  file { "/home/vagrant/work/devstack/localrc":
    content => "$localrc_cnt",
    require => Vcsrepo["/home/vagrant/work/devstack"],
    group   => "vagrant",
    owner   => "vagrant",
  }

  #run stack.sh as current user (vagrant)
#  exec { "/home/vagrant/work/devstack/stack.sh":
#    cwd     	=> "/home/vagrant/work/devstack",
#    group	=> "vagrant",
#    user	=> "vagrant",
#    logoutput	=> on_failure,
#    timeout	=> 0, # stack.sh takes time!
#    require 	=> File["/home/vagrant/work/devstack/localrc"],
#  }


  

}
