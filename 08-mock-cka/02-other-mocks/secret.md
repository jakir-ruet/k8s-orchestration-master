Create a secret & mount it to the pod `secret-pod`.
- secret name: CkaAdmin
- secret content: password=Cka@054003
- 
`Answer`
```bash
kubectl get pods
kubectl create secret generic pod-for-secret --from-literal=password=Cka@054003
kubectl get pod secret-pod -o yaml > secret-pod.yaml
nano secret-pod.yaml
```
Mount in pod
```bash
nano secret-pod.yaml
- mountPath: "/secret" # under containers > volumeMounts
  name: pod-for-secret
- name: pod-for-secret # user the volumes
  secret: 
     secretName: pod-for-secret
```
```bash
kubectl delete pod secret-pod
kubectl create -f secret-pod.yaml
kubectl describe pod secret-pod
```

List all the secrets and configmap in the cluster in all namespaces and write to file `/doc/all-configmap-secret.txt`.

`Answer`
```bash
kubectl get configmap, secrets --all-namespaces
kubectl get configmap, secrets --all-namespaces > /doc/all-configmap-secret.txt
cat /doc/all-configmap-secret.txt
```