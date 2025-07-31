Create a pod with a non-persistent volume.
- pod name: non-per-pod
- image: redis
- mount path: /data/per-redis

`Answer`
```yaml
apiVersion: v1
kind: Pod
metadata: 
   name: non-per-pod
spec:
   containers:
   - image: redis
     name: redis
     volumeMounts:
     - mountPath: /data/per-redis
       name: data-volume
   volumes:
   - name: data-volume
     emptyDir: {}
```
```bash
kubectl create -f non-per-pod.yaml
kubectl get pod non-per-pod -o wide
kubectl describe pod non-per-pod # check memory type
```

Create a pod with a non-persistent storage.
- pod name: redis-pod
- image: redis

`Answer`
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: redis-pod
spec:
  containers:
  - name: redis
    image: redis
    volumeMounts:
    - name: redis-volume
      mountPath: /data/redis
  volumes:
  - name: redis-volume
    emptyDir: {}
```
```bash
kubectl create -f redis-pod.yaml
kubectl get pods -o wide
kubectl describe pod redis-pod
```