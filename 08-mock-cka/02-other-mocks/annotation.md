Annotate the existing pod `my-pod` and use the value "name=my-annotate-pod".

`Answer`
```bash
kubectl get pods
kubectl annotate pod my-pod name=my-annotate-pod
kubectl describe pod my-pod | grep -i annotations
```

