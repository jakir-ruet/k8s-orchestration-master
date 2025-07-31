List all the persistent volumes sorted by capacity & write to file `/doc/persistent-volume.txt`

`Answer`
```bash
kubectl get pv
kubectl get pv --sort-by=.spec.capacity.storage > /doc/persistent-volume.txt
cat /doc/persistent-volume.txt
```

Create a pod which uses a persistent volume for storage.
- pod name: my-pod
- image: busybox
- persistent volume name: my-pv-volume
- persistent volume claim name: my-pvc
- persistent volume claim size: 100Mi

`Answer`
```bash
kubectl get pv
nano pvc.yaml
```
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
   name: my-pvc
spec:
   accessModes:
      - ReadWriteOnce
   resources:
      requests:
         storage: 100Mi
```
```bash
kubectl create -f pvc.yaml
kubectl run my-pod --image=busybox --dry-run=client yaml > my-pod.yaml
nano my-pod.yaml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
   creationTimestamp: null
   labels:
      run: my-pod
   run: my-pod
spec:
   volumes: # add this section as volume
      - name: pv-storage
        persistentVolumeClaim:
           claimName: my-pvc
   containers:
   - image: busybox
     name: my-pod
     resources: {}
     volumeMounts: # add this section as pvc volume
        - mountPath: /data
          name: pv-storage
   dnsPolicy: ClusterFirst
   restartPolicy: Always
status: {}
```
```bash
kubectl create -f my-pod.yaml
kubectl describe pod my-pod -o wide
kubectl get pvc
```

Change the mount path of the nginx container in the `online` statefulset to `/usr/share/nginx/updated-html`.

`Answer`
```bash
kubectl get statefulset -o wide
kubectl get statefulset online -o yaml > stateful.yaml
nano stateful.yaml # update mount path
kubectl replace -f stateful.yaml
kubectl get statefulset
kubectl describe statefulset online # check update path
```