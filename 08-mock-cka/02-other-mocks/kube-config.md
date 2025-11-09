There's an issue with kubeconfig file located in the directory `~/.kube/config`.
- troubleshoot and fix the issue.

`Answer`
```bash
kubectl get pods
cat ~/.kube/config
nano ~/.kube/config # fix the issue
kubectl cluster-info
kubectl get pods
```