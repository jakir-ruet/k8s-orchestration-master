ssh jakir@c1-cp1

# 1 - Find the version you want to upgrade to.
# You can only upgrade one minor version to the next minor version
sudo apt-get update
apt-cache policy kubeadm
TARGET_VERSION='1.32.1-1.1'

# What version are we on?
kubectl version
kubectl get nodes

# First, upgrade kubeadm on the Control Plane Node
# Replace the version with the version you want to upgrade to.
sudo apt-mark unhold kubeadm
sudo apt-get install -y kubeadm=$TARGET_VERSION
sudo apt-mark hold kubeadm

# All good, check to see if the version is updated
kubeadm version

# Run upgrade plan to test the upgrade process and run pre-flight checks
# Highlights additional work needed after the upgrade, such as manually updating the kubelets
# And displays version information for the control plan components
sudo kubeadm upgrade plan v1.32.1  #<---this format is different than the package's version format

# Run the upgrade, you can get this from the previous output.
# Runs preflight checks - API available, Node status Ready and control plane healthy
# Checks to ensure you're upgrading along the correct upgrade path
# Prepulls container images to reduce downtime of control plane components
# For each control plane component,
# Updates the certificates used for authentication
# Creates a new static pod manifest in /etc/kubernetes/mainifests and saves the old one to /etc/kubernetes/tmp
# Which causes the kubelet to restart the pods
# Updates the Control Plane Node's kubelet configuration and also updates CoreDNS and kube-proxy
sudo kubeadm upgrade apply v1.32.1  #<---this format is different than the package's version format

# Look for [upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.xx.yy". Enjoy!
# Next, Drain any workload on the Control Plane Node
kubectl drain c1-cp1 --ignore-daemonsets

# Now update the kubelet and kubectl on the control plane node(s)
sudo apt-mark unhold kubelet kubectl
sudo apt-get install -y kubelet=$TARGET_VERSION kubectl=$TARGET_VERSION
sudo apt-mark hold kubelet kubectl

# Reload and restart the systemd unit since their configs files have changed
sudo systemctl daemon-reload
sudo systemctl restart kubelet
sudo systemctl status kubelet

# Check the update status
kubectl version
kubectl get nodes

# Uncordon the node
kubectl uncordon c1-cp1

# Upgrade any additional control plane nodes with the same process.
