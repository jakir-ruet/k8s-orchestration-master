### Create nodeport service

```bash
kubectl apply -f service-nodeport.yaml
```

### Access the service

```bash
minikube ip
```

### Then open in browser

```bash
http://<minikube-ip>:30080
```
