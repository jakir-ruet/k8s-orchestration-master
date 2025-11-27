# Log into the node and update the enviroment variable so you can reuse those code over and over.
ssh aen@c1-wnode2
TARGET_VERSION='1.32.1-1.1'

# First, upgrade kubeadm
sudo apt-mark unhold kubeadm
sudo apt-get update
sudo apt-get install -y kubeadm=$TARGET_VERSION
sudo apt-mark hold kubeadm

# Updates kubelet configuration for the node
sudo kubeadm upgrade node

# Next, on the control plane node, drain any workload on the Worker Node
exit
kubectl drain c1-wnode1 --ignore-daemonsets
ssh jakir@c1-wnode1

# Since we logged out and back in we need to set that variable again
TARGET_VERSION='1.32.1-1.1'

# Update the kubelet and kubectl on the node
sudo apt-mark unhold kubelet kubectl
sudo apt-get install -y kubelet=$TARGET_VERSION kubectl=$TARGET_VERSION
sudo apt-mark hold kubelet kubectl

# Reload and restart the systemd unit since their configs files have changed
sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo systemctl status kubelet

# Log out of the node
exit

# Uncordon the node to allow workload again
kubectl uncordon c1-wnode1

# Get the nodes to show the version...can take a second to update
kubectl get nodes

#### TO DO ###
# BE SURE TO UPGRADE THE REMAINING WORKER NODES#####

