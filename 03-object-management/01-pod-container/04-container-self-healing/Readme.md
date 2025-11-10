### Container Self-Healing in Kubernetes

Self-healing refers to Kubernetes’ built-in ability to detect and automatically recover from container or Pod failures — without manual intervention. Kubernetes constantly monitors the state of Pods and containers to ensure that the actual state matches the desired state defined in your manifests.

#### How Kubernetes Achieves Self-Healing

##### Restarting Failed Containers

- Controlled by the Pod’s restart policy (`Always`, `OnFailure`, `Never`).
- If a container crashes or becomes unhealthy:
  - The Kubelet automatically restarts it according to the restart policy.
  - In a Deployment (default restartPolicy: `Always`), containers are restarted automatically whenever they fail.

```bash
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
    - name: nginx
      image: nginx
  restartPolicy: Always
```

##### Health Checks (Probes)

Kubernetes uses probes to check container health:

- Liveness Probe:
  Detects if a container is alive. If the probe fails repeatedly, Kubelet restarts the container (if allowed by restart policy).
- Readiness Probe:
  Detects if a container is ready to serve traffic. If it fails, Kubernetes temporarily removes the Pod from service endpoints (no restart).
- Startup Probe:
  Helps delay liveness checks until the app is fully started.

##### Controller-Level Healing

Higher-level controllers (like `Deployments`, `ReplicaSets`, `StatefulSets`, `DaemonSets`) add another layer of self-healing:

- If a Pod is deleted, evicted, or fails permanently, the controller automatically creates a new one to maintain the desired replica count.
- This ensures your application stays available even if nodes or Pods fail.

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
        - name: webapp
          image: myapp:latest
          ports:
            - containerPort: 80
```
