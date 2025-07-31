Create a new ingress resource and expose service `service-ingress` on path `hello-path` by using service port `5487`.
- name: connect-ingress
- namespace: dev-host

`Answer`
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
   name: service-ingress
   namespace: dev-host
spec:
   rules:
   - http:
      paths:
      - path: /hello-path
      pathType: Prefix
      backend:
         service:
            name: service-ingress
            port:
               number: 5487
```

```bash
kubectl create -f service-ingress.yaml
kubectl get ingress -n dev-host
```