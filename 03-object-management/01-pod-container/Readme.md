In K8s [pod](https://kubernetes.io/docs/concepts/workloads/pods/) & [container](https://kubernetes.io/docs/concepts/containers/) is basic building block of execution of a application. Complete knowledge of pod & container is very necessary. We are going learn here as follows

1. Application [configuration](https://kubernetes.io/docs/concepts/configuration/) management

- [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)
- [Env variables](https://kubernetes.io/docs/tasks/inject-data-application/define-environment-variable-container/)
- [Volumes configuration](https://kubernetes.io/docs/concepts/storage/volumes/)

2. Container resources management
3. Container health monitoring
4. Building self healing pods

| Aspect               | Pod                                                                                       | Container                                                   |
| -------------------- | ----------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| Definition           | The smallest deployable unit in Kubernetes.                                               | A lightweight, standalone, executable package of software.  |
| Composition          | One or more containers, along with storage and network.                                   | A single application or service instance.                   |
| Lifecycle Management | Managed by Kubernetes.                                                                    | Managed by the Pod.                                         |
| Isolation            | Shares network namespace with other containers in the same Pod.                           | Isolated from other containers, unless specified otherwise. |
| Networking           | Has a single IP address for the Pod, shared by all containers.                            | Uses the Pod's IP address.                                  |
| Storage              | Can have shared volumes accessible by all containers.                                     | Accesses volumes via the Pod specification.                 |
| Scalability          | Scaled by Kubernetes via ReplicaSets, Deployments, etc.                                   | Not directly scalable; scaling is managed at the Pod level. |
| Resource Management  | Requests and limits are set at the container level but managed by the Pod.                | Requests and limits specified per container.                |
| Health Management    | Health checks (liveness/readiness probes) defined at the Pod level but target containers. | Subject to the Pod's health checks.                         |
| Use Case             | Deploying applications or microservices, typically as a unit.                             | Running a specific application or service instance.         |
| Logging & Monitoring | Logs collected per container but can be aggregated at the Pod level.                      | Logs specific to the container's application.               |

***ConfigMaps commands*** is execute the command two ways.

- Via Config File

```bash
kubectl create configmap my-config --from-literal=key1=value1 --from-literal=key2=value2 # from literal
kubectl create configmap my-config --from-file=path/to/config/file # from file
kubectl create configmap my-config --from-file=path/to/directory # from directory
```

- Via CLI

```bash
kubectl get configmap [ConfigMapName] -o yaml/json
```

Sample ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-config
data:
  key1: value1
  key2: value2
```

Accessing ConfigMaps in Pods

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: my-image
    env:
    - name: KEY1
      valueFrom:
        configMapKeyRef:
          name: my-config
          key: key1
    - name: KEY2
      valueFrom:
        configMapKeyRef:
          name: my-config
          key: key2
```

Mount ConfigMaps as volumes

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: my-image
    volumeMounts:
    - name: config-volume
      mountPath: /etc/config
      readOnly: true
  volumes:
  - name: config-volume
    configMap:
      name: my-config
```

Manage

```bash
kubectl get configmap my-config -o yaml
kubectl edit configmap my-config
kubectl delete configmap my-config
```

***Secrets*** is execute the command following below way.

```bash
kubectl create secret generic my-secret --from-literal=username=my-user --from-literal=password=my-pass # generic
kubectl create secret generic my-secret --from-file=path/to/secret/file # from file
kubectl create secret generic my-secret --from-env-file=path/to/env/file # from env
kubectl create secret generic [DB-USER-PASSWORD] --from-file=./username.txt --from-file=./password.txt
kubectl get secrets
kubectl describe secrets [SecretName]
```

***Note:*** `$`, `\`, `*`, `!` are require to escape.

Secret

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  username: bXktdXNlcg==
  password: bXktcGFzcw==
```

Accessing Secrets in Pods

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: my-image
    env:
    - name: USERNAME
      valueFrom:
        secretKeyRef:
          name: my-secret
          key: username
    - name: PASSWORD
      valueFrom:
        secretKeyRef:
          name: my-secret
          key: password
```

Mount Secrets as volumes

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: my-container
    image: my-image
    volumeMounts:
    - name: my-secret-volume
      mountPath: /etc/secret
      readOnly: true
  volumes:
  - name: my-secret-volume
    secret:
      secretName: my-secret
```

View the secret & decode data

```bash
kubectl get secret my-secret -o yaml
echo 'bXktdXNlcg==' | base64 --decode
```
