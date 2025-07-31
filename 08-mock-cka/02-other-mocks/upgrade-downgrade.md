Downgrade & Upgrade the cluster:
- kubeadm: 1.29.0-1.30.0
- kubelet: 1.29.0-1.30.0
- kubectl: 1.29.0-1.30.0


`Answer`
| Upgrade                                 | Downgrade                                 |
| :-------------------------------------- | :---------------------------------------- |
| `apt-mark hold kubelet kubeadm kubectl` | `apt-mark unhold kubelet kubeadm kubectl` |
