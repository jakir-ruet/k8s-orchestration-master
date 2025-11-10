### Deployments

A Deployment manages a set of Pods to run an application workload, usually one that doesn't maintain state. A Deployment provides declarative updates for `Pods` and `ReplicaSets`.

> Feature

- `Declarative Updates` – Define the desired state; Kubernetes handles the rest.
- `Scaling` – Supports both horizontal and vertical scaling.
- `Rolling Updates` – Gradually update Pods with zero downtime.
- `Rollback` – Revert to a previous version of the deployment if something goes wrong.
- `Self-Healing` – Automatically replaces failed Pods.
- `Declarative Configuration` – Use YAML/JSON manifests to describe the desired state.

> Use Cases

- Stateless Applications
- Continuous Delivery
- Blue-Green and Canary Deployments

#### Application scaling

1. app scaling
   - Vertical Scaling (up-down) – Increase resources (CPU, RAM) for a Pod.
   - Horizontal Scaling (left-right) – Add more Pod replicas to handle more traffic.
2. Stateless vs Stateful Applications

| Type      | Characteristics                                      | Scaling                                                                  |
| --------- | ---------------------------------------------------- | ------------------------------------------------------------------------ |
| Stateless | Doesn’t save data, no state carried between requests | Can scale horizontally                                                   |
| Stateful  | Saves data, maintains state                          | Typically scales vertically; requires StatefulSet for multiple instances |

3. Replication Controller
   - manage the app scaling
   - Ensures a specified number of Pod replicas are running.
   - Manages lifecycle and ensures availability of Pods.

### ReplicaSet

A ReplicaSet (RS) in Kubernetes is a controller that ensures a specified number of pod replicas are running at all times. It's usually managed by a Deployment, not directly.

> Purpose: Maintains a stable set of pods; if some pods fail or are deleted, RS creates new ones to match the desired number.

```bash
spec:
  replicas: 3
  selector:
    matchExpressions:
      - {key: app, operator: In, values: [example, example, rs]}
      - {key: tier, operator: NotIn, values: [production]}
  template:
    metadata:
```

### Replication Controller

An older Kubernetes controller that also ensures a specified number of pod replicas are running. Mostly deprecated in favor of ReplicaSets.

> Comparison: RC provides similar functionality to a ReplicaSet but lacks some advanced features like set-based selectors.

```bash
spec:
  replicas: 3
  selector:
    app: alpine-app
  template:
    metadata:
```

### Bare Pods (Standalone Pods)

Pods that are not managed by any higher-level controller (`Deployment`, `ReplicaSet`, `StatefulSet`, `DaemonSet`).

> Characteristics:

- Created manually via kubectl run or YAML.
- No self-healing or automated scaling.
- Good for testing or temporary workloads.

#### ReplicaSet vs ReplicationController

| Feature         | ReplicaSet                              | ReplicationController       |
| --------------- | --------------------------------------- | --------------------------- |
| Selector type   | Supports **set-based & equality-based** | Only **equality-based**     |
| Typical usage   | Used with **Deployments**               | Standalone, older workloads |
| Features        | Self-healing, scalable                  | Basic replication only      |
| Rolling updates | Indirectly via Deployment               | Not supported               |

#### ReplicaSet vs Bare Pods

| Bare Pod                               | ReplicaSet                        |
| -------------------------------------- | --------------------------------- |
| No labels                              | Has labels                        |
| Suitable for simple/non-critical tasks | Suitable for production workloads |
| Not self-healing                       | Self-healing                      |
| No scaling                             | Supports scaling (via Deployment) |
