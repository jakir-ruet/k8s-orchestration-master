#### Welcome to K8s
1. Metadata
2. Specification
3. Status (Automatically generated and added by Kubernetes)
   kubernetes fix/organize the desire configuration in specification section on nginx-deployment.yaml (e.g nginx-deployment).
   synchronize the configuration all specification by using data from etcd (due to etcd is brain of kubernetes).


#### Declaration
```bash
apiVersion: apps/v1
kind: Deployment
```

#### Metadata
```bash
metadata:
  name: nginx-deployment
  labels:
    app: nginx
```

#### Specification
```bash
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.25.3
        ports:
        - containerPort: 8080
```

#### Status (In result-nginx-deployment-FILE)
```bash
status:
  availableReplicas: 2
  conditions:
    - lastTransitionTime: '2024-01-18T10:54:59Z'
      lastUpdateTime: '2024-01-18T10:54:59Z'
      message: Deployment has minimum availability.
      reason: MinimumReplicasAvailable
      status: 'True'
      type: Available
    - lastTransitionTime: '2024-01-18T10:54:56Z'
      lastUpdateTime: '2024-01-18T10:54:59Z'
      message: ReplicaSet "nginx-deployment-7d64f4b574" has successfully progressed.
      reason: NewReplicaSetAvailable
      status: 'True'
      type: Progressing
  observedGeneration: 1
  readyReplicas: 2
  replicas: 2
  updatedReplicas: 2
```
