Show the logs from the container and save it to `/doc/nginx.log`.
- pod name: logs-pod
- container: nginx-container
- namespace: dev-team

`Answer`
```yaml
apiVersion: v1
kind: Pod
metadata:
   creationTimestamp: null
   labels:
      run: logs-pod
   name: logs-pod
spec:
   containers:
   - image: nginx
     name: nginx-container
```
```bash
kubectl get pods -n dev-team -o wide
kubectl logs logs-pod -c nginx-container -n dev-team
kubectl logs logs-pod -c nginx-container -n dev-team > /doc/nginx.log
cat /doc/nginx.log
```

Create an init container in a pod which creates the file `check.txt` in the `tech-dir` directory. Use the main container to check if the `check.txt` file exists and execute the "sleep 300" command when it exists.
- pod name: my-check-pod
- image init container: busybox:1.28
- image container: alpine

`Answer`
