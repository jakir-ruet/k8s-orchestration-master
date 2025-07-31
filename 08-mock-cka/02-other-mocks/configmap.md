Create a configmap and add it to the pod.
- pod name: my-pod
- configmap name: data-config
- data: user: root, password: Root@054003

`Answer`
```bash
kubectl create configmap data-config --from-literal=user=root --from-literal=password=Root@054003
kubectl describe configmap data-config
kubectl get pods
kubectl get pod my-pod -o yaml > my-pod.yaml
```
```yaml
nano my-pod.yaml
# add this section under containers > volumeMounts
envFrom:
- configMapRef:
     - name: data-config
```
```bash
kubectl delete pod my-pod
kubectl create -f my-pod.yaml
kubectl exec -it my-pod -- env
```

Update the password in the existing configmap `my-configmap` to `NewPass@054003`.

`Answer`
```bash
kubectl describe configmap my-configmap
kubectl get configmap my-configmap -o yaml > my-configmap.yaml
nano my-configmap.yaml # update the password & same
kubectl replace -f my-configmap.yaml
kubectl describe configmap my-configmap
kubectl get pods
kubectl describe configmap my-configmap
kubectl exec -it my-configmap -- env # check password -old
kubectl get pod my-configmap -o yaml | kubectl replace --force -f -
kubectl exec -it my-configmap -- env # check password -new
```