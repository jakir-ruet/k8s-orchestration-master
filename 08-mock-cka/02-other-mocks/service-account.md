Create a new service account, clusterrole and clusterrolebinding. Make it possible to list the persistent volumes & create a pod with the new service account.
- Service account name: my-service-account
- Clusterrole name: pv-role
- Clusterrolebinding name: pv-binding
- Pod name: pv-pod
- Image: redis

`Answer`
```bash
kubectl create serviceaccount my-service-account
kubectl create clusterrole pv-role --resource=persistentvolumes --verb=list
kubectl create clusterrolebinding pv-binding --clusterrole=pv-role --serviceaccount=default:my-service-account
kubectl run pv-pod --image=redis --dry-run=client -o yaml > pod.yaml
nano pod.yaml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
   creationTimestamp: null
   labels:
      run: pv-pod
   name: pv-pdo
spec:
   serviceAccountName: my-service-account # update this section as service account
   containers:
   - image: redis
     name: pv-pod
     resources: {}
   dnsPolicy: ClusterFirst
   restartPolicy: Always
status: {}
```
```bash
kubectl create -f pod.yaml
kubectl describe pod pv-pod
```