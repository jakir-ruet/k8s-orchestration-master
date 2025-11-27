### Install ingress with Minikube

```bash
minikube addons enable ingress
```

```bash
kubectl apply -f ingress-rules.yaml
```

### Add to `/etc/hosts`

```bash
<minikube-ip>  myapp.local
```

### Visit in browser

```bash
http://myapp.local
```
