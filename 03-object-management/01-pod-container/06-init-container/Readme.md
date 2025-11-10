### Init Containers in Kubernetes

An Init Container is a special type of container that runs before the main application containers in a Pod. They are mainly used for initialization or setup tasks — such as environment preparation, configuration checks, or data population — that must complete successfully before the main containers start.

```bash
apiVersion: v1
kind: Pod
metadata:
  name: webapp-pod
spec:
  initContainers:
    - name: init-db-check
      image: busybox
      command: ['sh', '-c', 'until nc -z my-database 3306; do echo "waiting for db..."; sleep 2; done']
  containers:
    - name: webapp
      image: nginx
      ports:
        - containerPort: 80
```
