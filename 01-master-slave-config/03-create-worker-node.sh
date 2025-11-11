# For this demo ssh into c1-wnode1
ssh jakir@c1-wnode1

# Disable swap, swapoff then edit your fstab removing any entry for swap partitions
# You can recover the space with fdisk. You may want to reboot to ensure your config is ok.
swapoff -a
vi /etc/fstab

# 0 - Joining Nodes to a Cluster
# Install a container runtime - containerd
# containerd prerequisites, and load two modules and configure them to load on boot
# https://kubernetes.io/docs/setup/production-environment/container-runtimes/
# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Install containerd...
sudo apt-get install -y containerd

# Configure containerd
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml

# Set the cgroup driver for containerd to systemd which is required for the kubelet.
# For more information on this config file see:
# https://github.com/containerd/cri/blob/master/docs/config.md and also
# https://github.com/containerd/containerd/blob/master/docs/ops.md

# At the end of this section, change SystemdCgroup = false to SystemdCgroup = true
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
        ...
#          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
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

# To install the latest, omit the version parameters
# sudo apt-get install kubelet kubeadm kubectl
# sudo apt-mark hold kubelet kubeadm kubectl containerd

# Log out of c1-wnode1 and back on to c1-cp1
exit

# You can also use print-join-command to generate token and print the join command in the proper format
# COPY THIS INTO YOUR CLIPBOARD
kubeadm token create --print-join-command

# Back on the worker node c1-wnode1, using the Control Plane Node (API Server) IP address or name, the token and the cert has, let's join this Node to our cluster.
ssh aen@c1-wnode1

# PASTE_JOIN_COMMAND_HERE be sure to add sudo
sudo kubeadm join 172.16.94.10:6443 \
  --token szaqtk.ad6yeo8qp09t8s46 \
  --discovery-token-ca-cert-hash sha256:4f5322ce857874b44423c03fa6361c027f996b1e7d73eac16bb3eb8bbb6120da

# Log out of c1-wnode1 and back on to c1-cp1
exit

# Back on Control Plane Node, this will say NotReady until the networking pod is created on the new node.
# Has to schedule the pod, then pull the container.
kubectl get nodes

# On the Control Plane Node, watch for the calico pod and the kube-proxy to change to Running on the newly added nodes.
kubectl get pods --all-namespaces --watch

# Still on the Control Plane Node, look for this added node's status as ready.
kubectl get nodes

##################################################################
# GO BACK TO THE TOP AND DO THE SAME FOR c1-wnode2 and c1-wnode3
# Just SSH into c1-wnode2 and c1-wnode3 and run the commands again.
##################################################################

# Confirm all three worker nodes are online
kubectl get nodes

# Deploy a simple web application, this container stored in a container repository maintained for this course.
kubectl create deployment hello-world \
  --image=nginx:latest \
  --replicas=3

# Check to see if each node is running a pod
kubectl get pods -o wide

# Expose our deployment as a service
kubectl expose deployment hello-world \
     --port=80 \
     --target-port=8080

# Get the IP address of our service
kubectl get service

# Get the IP address of our service and store it in a variable for re-use
SERVICEIP=$(kubectl get service hello-world -o jsonpath='{ .spec.clusterIP }')
echo $SERVICEIP

# Test access to our web application
curl http://$SERVICEIP

# Lets clean things up...
kubectl delete deployment hello-world
kubectl delete service hello-world
