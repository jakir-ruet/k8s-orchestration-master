Step of application configuration

- Create ConfigMap Object
- Describe ConfigMap
- Create Secrets Object
- Create volume object
- Create ConfigMap Env
- Create POSIX Env
- Pass ConfigMap to Container as Env Variable

```bash
kubectl apply -f my-first-configmap.yaml
kubectl get configmap my-first-configmap
kubectl describe configmap my-first-configmap
kubectl delete configmap configmapName
```

```bash
echo -n 'admin' | base64 # find user hash value
echo -n 'adminadmin' | base64 # find password hash value
kubectl apply -f my-first-secret.yaml
kubectl get secret
kubectl describe configmap mmy-first-secret
kubectl delete configmap configmapName
```

User Env Variable connecting ConfigMap to Secret. By creating as belows yaml files configure

```bash
kubectl apply -f my-first-configmap-env.yaml
kubectl get pod
kubectl exec my-first-configmap-env -it -- sh
echo $PLAYER_INITIAL_LIVES
echo $UI_PROPERTIES_FILE_NAME
echo $SECRET_NAME
echo $SECRET_PASSWORD
printenv
```
