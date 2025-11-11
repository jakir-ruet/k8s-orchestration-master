### etcd

etcd is a distributed key-value store used by Kubernetes to store all cluster data, such as:

- Cluster state
- Pod specifications
- ConfigMaps, Secrets, and API objects

> Backing it up ensures that if the control plane fails or data becomes corrupted, you can restore your cluster to a working state.

#### Prerequisites

- Access to the `control plane` node (where etcd runs)
- `etcdctl` installed
- Knowledge of etcd’s `API version` (v3 for Kubernetes ≥ 1.13)
- Access to the `certificate files` used by etcd
