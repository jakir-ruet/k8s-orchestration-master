### Create a Deployment

```bash
kubectl apply -f app-deploy.yaml
```

### Create a Service

```bash
kubectl apply -f service.yaml
```

### Test service DNS

1. Test Service DNS From Any Pod > `This verifies internal cluster DNS + ClusterIP service`

```bash
kubectl exec -it `any-pod` -- curl http://`service-name`:`port`
kubectl exec -it myapp-5667445f54-8pwrt -- curl http://myapp-service:80
```

> This works because Kubernetes automatically provides DNS

```bash
myapp-service.default.svc.cluster.local
```

2. Test Service Using DNS Short Name (Inside a Pod)

```bash
curl http://myapp-service:80 # or
curl myapp-service
```

3. Access Service From Your Local Machine (Minikube)

```bash
minikube service myapp-service
```

> Must be run on host machine, not inside a pod
> Minikube will:

- Create a tunnel to expose the service
- Open your browser OR show a URL

```bash
kubectl exec -it `any-pod` -- curl http://`service-name`:`port`
kubectl exec -it myapp-5667445f54-8pwrt -- curl http://myapp-service:80
```

4. Port-forward Service to Localhost > `Again, run on host machine, not inside a pod`

```bash
kubectl port-forward svc/myapp-service 8080:80 # http://localhost:8080
```

> This is especially useful when service type is ClusterIP (internal only).

### Here is a table summarizing everything

| Goal                                 | Works From   | Command                                          |
| ------------------------------------ | ------------ | ------------------------------------------------ |
| Test service inside cluster          | Pod          | `curl http://myapp-service:80`                   |
| Test DNS                             | Pod          | `curl myapp-service`                             |
| Access service externally (minikube) | Host machine | `minikube service myapp-service`                 |
| Access service externally (manual)   | Host machine | `kubectl port-forward svc/myapp-service 8080:80` |
