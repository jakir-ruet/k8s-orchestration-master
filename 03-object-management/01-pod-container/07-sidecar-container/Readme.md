### Sidecar Containers in Kubernetes

A Sidecar container is a secondary container that runs alongside the main application container in the same Pod. It extends or enhances the functionality of the main application — without modifying its code.

#### Key Features

- Runs alongside the main container within the same Pod.
- Shares resources — same network (IP, ports) and mounted volumes.
- Extends functionality — adds logging, monitoring, proxying, or syncing capabilities.
- Operates independently — if one container restarts, others keep running (unless the Pod restarts).
- Reusable pattern — can be applied across multiple apps for consistent operations (e.g., log agents, service mesh proxies).

```bash
apiVersion: v1
kind: Pod
metadata:
  name: webapp-with-sidecar
spec:
  containers:
    - name: nginx
      image: nginx
      ports:
        - containerPort: 80
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
    - name: log-agent
      image: busybox
      command: ["sh", "-c", "tail -n+1 -F /var/log/nginx/access.log"]
      volumeMounts:
        - name: shared-logs
          mountPath: /var/log/nginx
  volumes:
    - name: shared-logs
      emptyDir: {}
```

#### Sidecar vs. Init Container

| Feature                        | **Init Container**        | **Sidecar Container**                      |
| ------------------------------ | ------------------------- | ------------------------------------------ |
| **When it runs**               | Before the main container | Alongside the main container               |
| **Runs once or continuously?** | Runs once                 | Runs continuously                          |
| **Purpose**                    | Setup or initialization   | Support or enhancement                     |
| **Example**                    | Check database readiness  | Collect logs, manage proxy, refresh tokens |
