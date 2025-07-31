Create a pod with container port 80. It should check the pod running at endpoint `/healthz` on port 80, verify & delete the pod.
- pod name: health-pod
- image: nginx

`Answer`
```bash
kubectl run health-pod --image=nginx --port=80 --restart=Always --dry-run=client -o yaml > health-pod.yaml
nano health-pod.yaml
```
Add this section ports section
```yaml
livenessProbe:
   httpGet:
      path: /healthz
      port: 80
   initialDelaySeconds: 300
```
```bash
kubectl create -f health-pod.yaml
kubectl describe pod health-pod | grep -i liveness
kubectl describe pod health-pod | grep -i readiness
kubectl delete pod health-pod
```

Monitor the logs of the pod `my-pod`, extract all the log lines matching with `not found` and write to the file `/doc/failed.log`.

`Answer`
```bash
kubectl logs my-pod | grep "not found"
kubectl logs my-pod | grep "not found" > /doc/failed.log
cat /doc/failed.log
```

List the logs of the pod named `my-pod` and search for the pattern `start` and write it to the file `/doc/pod-start.txt`.

`Answer`
```bash
kubectl get pods
kubectl logs my-pod | grep start
kubectl logs my-pod | grep start > /doc/pod-start.txt
cat /doc/pod-start.txt
```

Add a readiness probe to the existing deployment `ready-deployment`.
- path: /ready
- port: 80

`Answer`
```bash
kubectl get deployments
kubectl get deployment -o yaml > ready-deployment.yaml
nano ready-deployment.yaml
```
Add this section under containers section
```yaml
readinessProbe:
   httpGet:
      path: /ready
      port: 80
   successThreshold: 3
```
```bash
kubectl delete deployment ready-deployment
kubectl create -f ready-deployment.yaml
```