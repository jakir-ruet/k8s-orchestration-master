### [Container health](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)

In Kubernetes, monitoring doesn’t just mean watching metrics like CPU and memory — it also involves ensuring that containers are healthy and functioning correctly. That’s where probes (Liveness, Readiness, and Startup) come in.

#### Liveness Probe

Detects if the container is still alive (running as expected). If the probe fails, Kubernetes restarts the container automatically.

```bash
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 5
```

#### Readiness Probe

Checks if the container is ready to receive traffic. If it fails, Kubernetes removes the Pod from Service load balancing but does not restart the container.

```bash
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 10
```

#### Startup Probe

Used for slow-starting containers. It runs first — if this probe succeeds, Kubernetes starts running the liveness/readiness probes. If it fails repeatedly → the container is restarted.

```bash
startupProbe:
  httpGet:
    path: /healthz
    port: 8080
  failureThreshold: 30
  periodSeconds: 10
```

#### How Probes Work Together

| Probe         | Checks                           | Failure Action                | Typical Use                     |
| ------------- | -------------------------------- | ----------------------------- | ------------------------------- |
| **Liveness**  | Is container alive?              | Restart container             | Detect deadlocks or crashes     |
| **Readiness** | Is container ready?              | Remove from service endpoints | Prevent traffic to unready Pods |
| **Startup**   | Has container started correctly? | Restart container             | Handle slow-start apps          |
