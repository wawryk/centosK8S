#!/bin/sh

TOKEN=$3
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://yum.kubernetes.io/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
       https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

setenforce 0
yum install -y docker kubelet kubeadm kubectl kubernetes-cni ntp
systemctl start ntpd
systemctl enable ntpd
systemctl enable docker && systemctl start docker
systemctl enable kubelet && systemctl start kubelet

sed -i 's/SELINUX=enforcing/SELINUX=enforcing/g' /etc/selinux/config
swapoff -a
sed -i '/swap/s/^/#/g' /etc/fstab
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

if [ "$1" == "master" ]; then
  kubeadm init --apiserver-advertise-address=${2} --token=$TOKEN
  cp /etc/kubernetes/admin.conf /shared
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  join_command=$(sudo kubeadm token create --print-join-command | tail -1)
  echo $join_command > /shared/joincommand
  kubectl --kubeconfig /shared/admin.conf apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
  kubectl --kubeconfig /shared/admin.conf apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta8/aio/deploy/recommended.yaml
elif [ "$1" == "node" ]; then
  rm -Rf /etc/kubernetes/*
  join_command=$(cat /shared/joincommand)
  sudo $join_command
fi

echo "Wait 10.00s" && sleep 10
