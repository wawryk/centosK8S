# -*- mode: ruby -*-
# vi: set ft=ruby :

load 'config'

def workerIP(num)
  return "172.16.16.#{num+100}"
end

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

Vagrant.configure("2") do |config|
  ip = "172.16.16.100"
  config.vm.box = "centos/7"
  config.vm.synced_folder ".", "/shared", type: "nfs"
  config.vm.define "master" do |master|
    master.vm.network :private_network, :ip => "#{ip}"
    master.vm.hostname = "master"
    master.vm.provider "virtualbox" do |v|
      v.memory = $master_memory
      v.cpus = $master_cpu
    end
    master.vm.provision :shell, :inline => "sed 's/127.0.0.1.*master/#{ip} master/' -i /etc/hosts"
    master.vm.provision :shell do |s|
      s.inline = "sh /vagrant/install.sh $1 $2 $3"
      s.args = ["master", "#{ip}", "#{$token}"]
    end
  end
  (1..$worker_count).each do |i|
    config.vm.define vm_name = "%s-%02d" % [$instance_name_prefix, i] do |node|
      node.vm.network :private_network, :ip => "#{workerIP(i)}"
      node.vm.hostname = vm_name
      node.vm.provider "virtualbox" do |v|
        v.memory = $worker_memory
        v.cpus = $worker_cpu
      end
      node.vm.provision :shell, :inline => "sed 's/127.0.0.1.*node-#{i}/#{workerIP(i)} node-#{i}/' -i /etc/hosts"
      node.vm.provision :shell do |s|
        s.inline = "sh /vagrant/install.sh $1 $2 $3"
        s.args = ["node", "#{ip}", "#{$token}"]
      end
    end
  end
end
