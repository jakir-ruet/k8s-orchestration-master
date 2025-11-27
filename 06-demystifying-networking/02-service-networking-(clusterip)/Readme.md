### Create a Deployment

```bash
kubectl apply -f app-deploy.yaml
```

### Create a Service

```bash
kubectl apply -f service.yaml
```

### Test service DNS

```bash
kubectl run test --image=busybox -it -- /bin/bash # inside busybox:
wget -qO- http://myapp-service
```

```bash
# access from local computer
kubectl port-forward svc/myapp-service 8080:80
http://localhost:8080
```

