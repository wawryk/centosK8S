# Vagrant Centos kubernetes cluster
- Centos 7.2 amd64
- docker 1.10
- kubeadm 1.5

## plugins used
- flannel
- dashboard

## Installation
Use install_requirements.sh anr read help
```bash
./install_requirements.sh --help
```

or install dependencies:
- vagrant
- git
- virtualbox
- kubectl

then:

```bash
git pull https://github.com/wawryk/centosK8S.git
cd centosK8S/
vagrant up
```
## Clean-up
```bash
vagrant destroy
#or use below to force destroy
vagrant destroy -f
```

## Configuration
config
```ruby
#You can change token but remember about format "6signs.16signs"
$token = "vr9e0z.zcnghm9a3sp848zn"
$master_memory = 4096
#Minimal required cpu's
$master_cpu = 2
$worker_count = 2
$worker_memory = 1024
$worker_cpu = 1
#Worker names in Vagrant
$instance_name_prefix = "worker"
```

### Basic usage
```bash
# If you use SSH to connect on master you should remove
# "--kubeconfig admin.conf" argument
# Cluster info
kubectl cluster-info --kubeconfig admin.conf
# Get nodes
kubectl get nodes --kubeconfig admin.conf
# Get system pods
kubectl get pods --namespace=kube-system --kubeconfig admin.conf
# Go to dashboard (require kubectl on the host, or use master
# ip address to access to the ui)
kubectl proxy --kubeconfig admin.conf # http://localhost:8001/ui on host
```
