Create an init container in a pod which creates the file `check.txt` in the `tech-dir`. Use the main container to check it the `check.txt` file exists and execute the `sleep 300` command when it exists.
- pod name: blue-check
- image init container: busybox:1.28
- image container: alpine

`Answer`
```yaml
apiVersion: v1
kind: Pod
metadata:
   name: blue-check
spec:
   volumes:
   - name: blue-volume
     emptyDir: {}
   containers:
   - name: alpine
     name: alpine
     command: ['sh', '-c', 'if [ -f /tech-dir/check.txt ]; then sleep 300; fi']
     volumeMounts:
     - name: blue-volume
       mountPath: /tech-dir
   initContainers:
   - name: init-busybox
     image: busybox:1.28
     command: ['sh', '-c', 'mkdir /tech-dir; echo>/tech-dir/check.txt']
     volumeMounts:
     - name: blue-volume
       mountPath: /tech-dir
```
```bash
kubectl create -f init-container.yaml
kubectl get pod blue-check -o wide
```