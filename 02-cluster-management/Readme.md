### Cluster Upgrade Process Overview

- Upgrade Control Plane Node
- Upgrade any other Control Plane Nodes
- Upgrade Worker Nodes

#### Cluster Upgrade Process - Control Plane

- Update kubeadm package
- kubeadm upgrade plan
- kubeadm upgrade apply
- Drain the Control Plane Node
- Update kubelet and kubectl
- Uncordon the Control Plane Node

### Cluster Upgrade Process - Worker Nodes

- Update kubeadm
- kubeadm upgrade node
- Drain the Node
- Update kubelet and kubectl
- Uncordon Node

### Upgrade Impact Overview

| Aspect            | Master Node                                                | Worker Node                                             |
| ----------------- | ---------------------------------------------------------- | ------------------------------------------------------- |
| Upgrade Order     | First                                                      | After the master nodes are upgraded                     |
| Impact            | High-impacts the entire cluster's control plane operations | Moderate-impacts workloads running on the specific node |
| Downtime          | Should be minimized; follow HA practices to reduce         | Minimal if done node-by-node with draining              |
| Command           | `sudo kubeadm upgrade apply <version>`                     | `sudo kubeadm upgrade node`                             |
| Drain Node        | No Required                                                | Yes, to safely migrate workloads `kubectl drain <node>` |
| Risk              | Higher due to critical nature of components                | Lower, focused on individual node functionality         |
| HA Considerations | Use multiple control plane nodes for zero downtime         | Upgrade nodes one at a time to maintain availability    |
