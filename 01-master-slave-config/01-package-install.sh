# 0 - Creating a Cluster
# Log into our control plane node
ssh jakir@c1-cp1

# Disable swap, `swapoff` then edit your fstab removing any entry for swap partitions
# You can recover the space with `fdisk`. You may want to reboot to ensure your config is ok.
cat /etc/fstab
sudo swapoff -a
sudo swapon --show
sudo vi /etc/fstab
sudo swapon --show

#1 - Install Packages containerd prerequisites.
#https://kubernetes.io/docs/setup/production-environment/container-runtimes/

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Install containerd...
sudo apt-get install -y containerd

# Create a containerd directory and configuration file
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Set the cgroup driver for containerd to systemd which is required for the kubelet.
# For more information on this config file see:
# https://github.com/containerd/cri/blob/master/docs/config.md and also
# https://github.com/containerd/containerd/blob/master/docs/ops.md

# At the end of this section, change SystemdCgroup = false to SystemdCgroup = true
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
        ...
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
            SystemdCgroup = true

# You can use sed to swap in true
sudo sed -i 's/            SystemdCgroup = false/            SystemdCgroup = true/' /etc/containerd/config.toml

# Verify the change was made
grep 'SystemdCgroup = true' /etc/containerd/config.toml

# Restart containerd with the new configuration
sudo systemctl restart containerd

# Install Kubernetes packages - kubeadm, kubelet and kubectl
# Add k8s.io's apt repository gpg key, this will likely change for each version of kubernetes release.
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add the Kubernetes apt repository
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update the package list and use apt-cache policy to inspect versions available in the repository
sudo apt-get update
apt-cache policy kubelet | head -n 15

# Install the required packages, if needed we can request a specific version.
# Use this version because in a later course we will upgrade the cluster to a newer version.
# Try to pick one version back because later in this series, we'll run an upgrade
VERSION=1.32.0-1.1
sudo apt-get install -y kubelet=$VERSION kubeadm=$VERSION kubectl=$VERSION
sudo apt-mark hold kubelet kubeadm kubectl containerd

# To install the latest, omit the version parameters.
# I have tested all demos with the version above, if you use the latest it may impact other demos in this course and upcoming courses in the series
# sudo apt-get install kubelet kubeadm kubectl
# sudo apt-mark hold kubelet kubeadm kubectl containerd

# 1 - systemd Units
# Check the status of our kubelet and our container runtime, containerd.
# The kubelet will enter a inactive (dead) state until a cluster is created or the node is joined to an existing cluster.
sudo systemctl status kubelet.service
sudo systemctl status containerd.service
