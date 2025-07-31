Get a list of all the pods in all the namespaces and write it to the file `/doc/pods-namespaces.txt`.

`Answer`
```bash
kubectl get pods --all-namespaces
kubectl get pods --all-namespaces /doc/pods-namespaces.txt
cat /doc/pods-namespaces.txt
```

Create a networkpolicy and allow traffic from all the pods in the `dev-team` namespace and from pods with the label `type=review` to the pods matching the label `app=postgres`.

`Answer`
```bash
kubectl label namespace/dev-team app=dev-team
```
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
   name: allow-dev-team
   namespace: default
spec:
   podSelector:
      matchLabels:
         app: postgres
      ingress:
         - from:
            - namespaceSelector:
                 - matchLabels:
                     - app: dev-team
              podSelector:
                 matchLabels:
                    type: review 
```
```bash
kubectl create -f allow-dev-team.yaml
```

Get all the objects in all the namespaces and write to file `/doc/all-object.txt`.

`Answer`
```bash
kubectl get all --all-namespaces
kubectl get all --all-namespaces > /doc/all-object.txt
cat /doc/all-object.txt
```