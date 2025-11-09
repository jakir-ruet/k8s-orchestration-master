### Welcome to `Cluster Architecture`, `Installation`, and `Configuration` for `CKA`: `Cluster Management` and `Lifecycle`

#### Prerequisite

- Good understanding Linux & Virtualization
- Basic understanding Kubernetes
- Basic understanding computer networking

#### Requirements

- System Requirement in each node
  - Linux (Ubuntu/RedHat)
  - Two CPUs
  - 2GB RAM
  - 100GB SSD
  - Swap Disabled
- Container Runtime Requirement
  - Container Runtime Interface (CRI)
  - Containerd
  - CRI-O
- Networking Requirement
  - All Node Connectivity
- VirtualBox/VmWare

#### Required Packages

- containerd
- kubelet
- kubeadm
- kubectl

#### Installing Kubernetes on Ubuntu VMs

##### Lab environment

- Kubectl
- Control Plane Node `c1-cp1` - `172.16.94.10`
 Worker Node `c1-wnode1` - `172.16.94.11`
 Worker Node `c2-wnode2` - `172.16.94.12`
 Worker Node `c3-wnode3` - `172.16.94.13`

#### Package Install

- Setup
  - 4 VMs Ubuntu 24.04, `1 Control plane`, `3 nodes`
  - `Static IP`s on individual VMs
  - `/etc/hosts` `hosts` file includes name to IP mappings for VMs
  - `Swap` is disabled

#### Login to

- control plane `ssh jakir@c1-cp1`,
- worker node 1 `ssh jakir@c1-wnode1`,
- worker node 2 `ssh jakir@c1-wnode2` and ,
- worker node 3 `ssh jakir@c1-wnode3`

> Execute all command in `01-package-install.sh` on four VM's
