### Create a Deployment

```bash
kubectl apply -f app-deploy.yaml
```

### Create nodeport service

```bash
kubectl apply -f service-nodeport.yaml
```

### Access the service

```bash
minikube ip
```

### Internal cluster access

1. Access using Service DNS name `From any pod`

```bash
kubectl exec -it myapp-5667445f54-6hq97 -- /bin/bash
curl http://myapp-nodeport # or
curl http://myapp-service:80 # This uses Kubernetes DNS `myapp-service.default.svc.cluster.local`
```

2. Access using ClusterIP address `This works only inside the cluster.`

```bash
kubectl get svc myapp-nodeport
kubectl exec -it myapp-5667445f54-6hq97 -- /bin/bash
curl http://10.104.9.83:80
```

3. Access using Pod IP (not recommended) - `Use only for debugging`

```bash
kubectl get pod -o wide
curl http://<pod-ip>:80
curl http://10.244.1.3:80 # any pod's IP
```

> Problems:

- No load balancing
- Pod IP changes on restart

### External cluster access

1. NodePort access (your current setup)

```bash
minikube ip
curl http://<node-ip>:30080
curl http://192.168.49.2:30080
```

2. Port-forward (easy + recommended for testing) - `Works with any service or pod`

```bash
kubectl port-forward svc/myapp-nodeport 8080:80
http://localhost:8080 # It's work from localhost
```

3. minikube service command (only when using Minikube) - `This automatically opens the service in your browser`

```bash
minikube service myapp-nodeport
```

> Minikube will map the NodePort and open it.

- Must run this on your host machine, not inside a pod.

4. LoadBalancer service (cloud / minikube tunnel)

```bash
minikube tunnel
kubectl get svc myapp-service
http://<external-ip>:80 # It will show an External IP
```

### All ways you can access the app

| Method           | Inside Cluster | Outside Cluster | Notes                  |
| ---------------- | -------------- | --------------- | ---------------------- |
| Service DNS      | ✅              | ❌               | Easiest inside cluster |
| ClusterIP        | ✅              | ❌               | Internal IP only       |
| Pod IP           | ✅              | ❌               | Debug only             |
| NodePort         | ❌              | ✅               | `NodeIP:30080`         |
| Port-forward     | ❌              | ✅               | `localhost:8080`       |
| Minikube service | ❌              | ✅               | Auto browser open      |
| LoadBalancer     | ❌              | ✅               | Cloud only             |
| Ingress          | ❌              | ✅               | Domain-based access    |
