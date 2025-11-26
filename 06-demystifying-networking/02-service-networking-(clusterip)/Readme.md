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
kubectl run test --image=busybox -it -- sh # inside busybox:
wget -qO- http://myapp-service
```
