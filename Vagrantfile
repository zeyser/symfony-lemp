# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.provision "shell", path: "code/provision/setup.sh"

  config.vm.network "private_network", ip: "10.4.4.101"
  config.vm.network "public_network", ip: "192.168.1.161"

  config.vm.synced_folder "./code", "/var/www", create: true, id: "v-root", mount_options: ["rw", "tcp", "nolock", "noacl", "async"], type: "nfs", nfs_udp: false

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 4
    vb.memory = "1024"
  end
end
