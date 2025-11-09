Grep the current context and write it to the file `/doc/current-context.txt`.

`Answer`
```bash
kubectl config current-context
cat ~/.kube/config
cat ~/.kube/config | grep current
cat ~/.kube/config | grep current > /doc/current-context.txt
cat /doc/current-context.txt
```

Get all contexts and write it to the file `/doc/all-contexts.txt`.

`Answer`
```bash
cat ~/.kube/config
kubectl config get-contexts
kubectl config get-contexts > /doc/all-contexts.txt
cat /doc/all-contexts.txt
```