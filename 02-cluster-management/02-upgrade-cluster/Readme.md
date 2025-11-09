#### Lets get started Upgrade the cluster
Master node (master-node)
```bash
kubectl get nodes
# drain the node
kubectl drain master-node --ignore-daemonsets
sudo apt-get update
# update the kubeadm
sudo apt-get install -y --allow-change-held-packages kubeadm=1.30.0-00
kubeadm version
# verify the upgrade
sudo kubeadm upgrade plan v1.30.0-00
sudo apt-get update
# upgrade kubelet & kubectl packages
sudo apt-get install -y --allow-change-held-packages kubelet=1.30.0-00 kubectl=1.30.0-00
# restart the kubelet:
sudo systemctl daemon-reload
sudo systemctl restart kubelet
kubectl get nodes
# uncordon
kubectl uncordon master-node
```

Worker node (worker-node)
```bash
kubectl drain worker-node --ignore-daemonsets
sudo apt-get update
sudo apt-get install -y --allow-change-held-packages kubeadm=1.30.0-00
kubeadm version
# worker node upgrade
sudo kubeadm upgrade node
sudo apt-get update
# upgrade kubelet & kubectl packages
sudo apt-get install -y --allow-change-held-packages kubelet=1.30.0-00 kubectl=1.30.0-00
# restart the kubelet:
sudo systemctl daemon-reload
sudo systemctl restart kubelet
kubectl get nodes
# uncordon
kubectl uncordon worker-node
```

| Aspect            | Master Node                                                | Worker Node                                             |
| ----------------- | ---------------------------------------------------------- | ------------------------------------------------------- |
| Upgrade Order     | First                                                      | After the master nodes are upgraded                     |
| Impact            | High-impacts the entire cluster's control plane operations | Moderate-impacts workloads running on the specific node |
| Downtime          | Should be minimized; follow HA practices to reduce         | Minimal if done node-by-node with draining              |
| Command           | `sudo kubeadm upgrade apply <version>`                     | `sudo kubeadm upgrade node`                             |
| Drain Node        | No Required                                                | Yes, to safely migrate workloads `kubectl drain <node>` |
| Risk              | Higher due to critical nature of components                | Lower, focused on individual node functionality         |
| HA Considerations | Use multiple control plane nodes for zero downtime         | Upgrade nodes one at a time to maintain availability    |