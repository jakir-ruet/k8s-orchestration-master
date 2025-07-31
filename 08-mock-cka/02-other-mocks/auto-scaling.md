Apply autoscaling to the `green-deployment` with a minimum of 5 and maximum of 10 replicas and a target CPU of 75%.

`Answer`
```bash
kubectl get deployment
kubectl autoscale deployment green-deployment --min=5 --max=10 --cpu-percent=75
kubectl get hpa
kubectl get pods
```