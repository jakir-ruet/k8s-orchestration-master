### Create cluster-service and nodeport-service

```bash
kubectl apply -f clusterip-service.yaml
kubectl apply -f nodeport-service.yaml
```

### Test DNS inside a Pod (Kubernetes automatically creates DNS records for services.)

```bash
kubectl exec -it test -- sh
nslookup clusterip-service
nslookup nodeport-service
```
