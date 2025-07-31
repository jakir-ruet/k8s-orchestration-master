Create a new service account with the name `pvviewer`. Grant this service account access to `list` all persistentVolumes in the cluster by creating an appropriate cluster role called `pvviewer-role` and ClusterRoleBinding called `pvviewer-role-binding`. Next, create a pod called `pvviewer` with the image: `redis` and serviceAccount `pvviewer` in the default namespace.
- ServiceAccount: `pvviewer`
- ClusterRole: `pvviewer-role`
- ClusterRoleBinding: `pvviewer-role-binding`
- Pod: `pvviewer`
- Pod configured to use ServiceAccount pvviewer?

`Answer`
```bash
kubectl get nodes
kubectl create serviceaccount pvviewer
kubectl create clusterrole pvviewer-role --resource=persistentvolumes --verb=list
kubectl create clusterrolebinding pvviewer-role-binding --clusterrole=pvviewer-role --serviceaccount=default:pvviewer 
```
Create Pod `pod.yaml`
```yaml
apiVersion: v1
kind: Pod
metadata:
   creationTimestamp: null
   labels:
      run: pvviewer
   name: pvviewer
spec:
   containers:
   - image: redis
     imagePullPolicy: IfNotPresent
     name: pvviewer
   serviceAccountName: pvviewer
```
```bash
kubectl apply -f pod.yaml
kubectl describe pod pvviewer
```

Create a service from the `green` pod & run a DNS lookup to check the  service & write to file `/doc/lookup.txt`
- service name: green-service
- port: 80

`Answer`
```bash
kubectl get pods
```
```yaml
apiVersion: v1
kind: Pod
metadata:
   creationTimestamp: null
   labels:
      run: green
   name: green
spec:
   containers:
   - image: nginx
     name: green
```
```bash
kubectl create -f green.yaml
kubectl expose pod green --name=green-service --port=80
kubectl run nslookup --image=busybox:1.28 --command sleep 3600
kubectl exec -it nslookup -- nslookup green-service
kubectl exec -it nslookup -- nslookup green-service > /doc/lookup.txt
cat /doc/lookup.txt
```