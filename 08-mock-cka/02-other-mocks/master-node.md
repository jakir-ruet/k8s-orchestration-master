Find out where the K8s master & KubeDNS are running at and write to file `/doc/master-node-info.txt`.

`Answer`
```bash
kubectl cluster-info
kubectl cluster-info > /doc/master-node-info.txt
cat /doc/master-node-info.txt
```

List all the control plane components and write to the file `/doc/all-master-component.txt`.

`Answer`
```bash
kubectl get pods -n kube-system
kubectl get pods -n kube-system > /doc/all-master-component.txt
cat /doc/all-master-component.txt
```