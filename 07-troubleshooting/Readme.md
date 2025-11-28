### Maintaining, Monitoring, and Troubleshooting

overview of Maintaining, Monitoring, and Troubleshooting Kubernetes, with practical tools and best practices for each area.

#### Maintenance

Maintenance ensures that your cluster remains secure, performant, and up to date.

- Cluster Upgrades.
  - Upgrade Kubernetes Components.
  - Upgrade Add-ons (e.g., CNI, CSI, CoreDNS, kube-proxy).
  - Check Deprecations: Review release notes for API version changes `kubectl get --raw / | jq .`.
- Backup and Restore
  - etcd Backups `ETCDCTL_API=3 etcdctl snapshot save snapshot.db`
  - Store snapshots in secure, versioned storage (e.g., S3, GCS).
  - Cluster State Backup: Tools like `Velero` back up persistent volumes and cluster resources.
  - Disaster Recovery Testing: Regularly restore from backups in test environments.
- Resource and Node Management
- Autoscaling
  - Cluster Autoscaler adjusts node count.
  - Horizontal Pod Autoscaler (HPA) adjusts pod replicas.

#### Monitoring

Monitoring ensures visibility into cluster health, performance, and workload behavior.

##### Core Monitoring Tools

| Area                  | Tools                                                          |
| --------------------- | -------------------------------------------------------------- |
| Metrics & Performance | **Prometheus + Grafana**, **Metrics Server**                   |
| Logs                  | **Fluentd**, **Fluent Bit**, **Elastic Stack (ELK)**, **Loki** |
| Tracing               | **Jaeger**, **OpenTelemetry**, **Zipkin**                      |
| Events & Alerts       | **Alertmanager**, **PagerDuty**, **Opsgenie**                  |

##### Key Metrics to Track

- `Cluster Level:` Node CPU, memory, disk usage, API server latency, etcd health.
- `Pod Level:` Pod restarts, resource requests vs. limits, container logs.
- `Application Level:` HTTP request latency, error rates, throughput.

##### Dashboards & Visualization Grafana Dashboards for

- Cluster health
- Namespace resource usage
- Network performance
- Application latency

#### Troubleshooting

When something breaks, structured diagnosis is key. Common Troubleshooting Steps.

- Check Cluster Health
- Inspect Pod Issues
- Network Issues
- Storage Problems
- Node Problems

> Debugging Tools

- `kubectl debug` (ephemeral debug containers)
- `kubectl exec` (run commands inside containers)
- `Lens`, `K9s`, or `Octant` for visual cluster exploration
- `Stern` or `kubetail` for aggregated log viewing

#### Prerequisites

- Access to the `control plane` node (where etcd runs)
- `etcdctl` installed
- Knowledge of etcd’s `API version` (v3 for Kubernetes ≥ 1.13)
- Access to the `certificate files` used by etcd

### Essential commands of troubleshooting

#### Using `get`

##### Exec into the nginx container

```bash
kubectl exec -it PodName -n NamespaceName -- /bin/bash
```

##### Get Pod YAML

```bash
kubectl get pod PodName -n NamespaceName -o yaml
```

##### Get Deployment YAML

```bash
kubectl get deployment DeploymentName -n NamespaceName -o yaml
```

##### Get All Resources YAML (Pod, RS, Deployment)

```bash
kubectl get all -n DeploymentName -o yaml
```

##### Save YAML to a file

```bash
kubectl get pod PodName -n NamespaceName -o yaml > FileName.yaml
```

##### Find the replica numbers

```bash
kubectl get deployment DeploymentName -n NamespaceName -o yaml | grep replicas
kubectl get deployment DeploymentName -n NamespaceName -o yaml | grep replicas | jq # sorted form
```

> jq means JSON, Query

#### Using JSONPath

##### Get Pod name

```bash
kubectl get pod -n NamespaceName -o jsonpath='{.items[*].metadata.name}'
```

##### Get Pod IP

```bash
kubectl get pod PodName -n NamespaceName -o jsonpath='{.status.podIP}'
```

##### Get container images inside a Pod

```bash
kubectl get pod PodName -n NamespaceName -o jsonpath='{.spec.containers[*].image}'
```

#### Using describe (e.g., OOMKilled, CrashLoopBackOff, pending, scheduling events, etc.)

It is used for debugging, because it displays: Events, Container status, Restart reasons, Node info, Volumes, Labels, annotations etc.

##### Describe a Pod

```bash
kubectl describe pod PodName -n mango
```

##### Describe a Service

```bash
kubectl describe svc myapp-service
```

#### Using Events

##### Get all events (current namespace)

```bash
kubectl get events
```

##### Sort events by time (newest first)

```bash
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl get events --sort-by=.metadata.creationTimestamp -n Namespace
```

##### Watch events live

```bash
kubectl get events -w
kubectl get events -w -n Namespace
```

#### Using Logs

##### Get logs of a Pod

```bash
kubectl logs PodName -n Namespace
kubectl logs PodName -n Namespace --all-containers
kubectl get deployment mango-deployment -o yaml | grep labels -A5
```

> `-A5` means show 5 lines After the match

##### Using `logs --timestamps`

```bash
kubectl logs PodName -n Namespace --timestamps
```

##### Follow logs live with timestamps

```bash
kubectl logs -f PodName -n Namespace --timestamps
```

##### Useful combinations `Last 100 lines with timestamp`

```bash
kubectl logs PodName -n Namespace --tail=100 --timestamps
```

##### Logs since 10 minutes ago

```bash
kubectl logs PodName -n Namespace --since=10m --timestamps
```

##### Include previous logs (for restarted pods)

```bash
kubectl logs PodName -n Namespace --previous --timestamps
```

#### Using `logs follow`

##### Basic command (follow logs)

```bash
kubectl logs -f PodName # f means follow
```

#### Using `exec`

##### Basic exec

```bash
kubectl exec -it PodName -n Namespace -- sh
kubectl exec -it PodName -n Namespace -- /bin/bash
```

##### If the pod has multiple containers

```bash
kubectl exec -it PodName -n Namespace -c ContainerName -- sh
kubectl exec -it PodName -n Namespace -c ContainerName -- /bin/bash
```

#### Using `port-forward`

```bash
kubectl port-forward PodName LocalPort:RemotePort
```

#### Using `auth`

```bash
kubectl auth whoami
kubectl config current-context
```

#### List all Roles in the current namespace

Same as other like `ClusterRoles`, `RoleBindings` etc

```bash
kubectl get roles
kubectl describe role RoleName -n Namespace
kubectl get role RoleName -n Namespace -o yaml # role details
kubectl get role RoleName -n Namespace -o json | jq
```

#### check whether a user or service account has permission

```bash
kubectl auth can-i Verb Resource [options]
```

```bash
kubectl auth can-i get pods -n Namespace # verb `get`
```

#### Using `top` required `minikube addons enable metrics-server`

```bash
kubectl top nodes
kubectl top pods -n kube-system
```

#### Using `diff`

> compare the live cluster state with your local manifest files

```bash
kubectl diff -f DeploymentYamlFile -n Namespace
kubectl diff -f mango-deployment.yaml -n mango
```

#### Using `kubectl debug`

##### Debug a Pod (ephemeral container)

```bash
kubectl debug -it PodName --image=busybox --target=ContainerName -n Namespace
```

##### Debug a Node

```bash
kubectl debug node/NodeName -it --image=busybox
kubectl debug node/minikube-m02 -it --image=nginx
```

##### Debug nginx pod

```bash
kubectl debug -it nginx-deployment --image=ubuntu -n mango
```

> Why an image is needed

The debug container is ephemeral; it is created temporarily inside an existing pod (or on a node).

Kubernetes does not automatically copy your original container’s image, so you must provide an image that has the tools you need for debugging (like sh, bash, curl, ping, etc.).

Common choices:

| Image               | Use case                                 |
| ------------------- | ---------------------------------------- |
| `busybox`           | Minimal image, has `sh`, `ls`, `ping`    |
| `ubuntu`            | Larger, has `bash` and can install tools |
| `alpine`            | Very small, minimal shell                |
| `nicolaka/netshoot` | Networking tools for debug               |
