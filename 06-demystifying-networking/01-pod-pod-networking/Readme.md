### Create two pods

```bash
kubectl apply -f pod-a.yaml
kubectl apply -f pod-b.yaml
```

### Get Pod IPs

```bash
kubectl get pods -o wide
```

### Exec into pod-a and curl pod-b

```bash
kubectl exec -it pod-a -- sh # inside pod-a container:
apt update
apt install -y curl
apt install -y iputils-ping
ping google.com
curl http://<pod-b-ip>
```
