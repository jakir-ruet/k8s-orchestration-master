Create the replicaset `front-replicaset` with the image `nginx` which has 3 replicas.

`Answer`
```bash 
kubectl create deployment front-replicaset --image=nginx --dry-run=client -o yaml > replicaset.yaml
nano replicaset.yaml
```
Update this section
```yaml
kind: ReplicaSet
spec:
   replicas: 3
strategy {} # removed
```
```bash
kubectl create -f replicaset.yaml
kubectl get replicasets
kubectl get pods
kubectl delete pod front-replicaset-dxs6d
kubectl get pods
```