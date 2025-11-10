### Object Management in Kubernetes

Kubernetes objects are persistent entities in the Kubernetes system. Kubernetes uses these entities to represent the desired state of your cluster. These objects are sometimes referred to as Kubernetes Primitives.

#### Common Kubernetes objects include

- `Pods` – The smallest deployable unit, representing one or more containers.
- `ReplicaSet` – Ensures a specified number of Pod replicas are running at all times.
- `DaemonSet` – Ensures a copy of a Pod runs on all (or selected) nodes.
- `StatefulSet` – Manages stateful applications with unique, persistent identities.
- `Job/CronJob` – Executes tasks one-time (Job) or periodically (CronJob).
- `Deployment` – Declaratively manages Pod replicas and updates.

#### Difference & Comparison of `kubectl apply`  & `kubectl create`

| Aspect                | `kubectl apply`                                                                              | `kubectl create`                                                        |
| --------------------- | -------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| Purpose               | Updates and manages resources declaratively                                                  | Creates new resources imperatively                                      |
| Idempotency           | Idempotent-can be run multiple times without effect if the desired state is already achieved | Not idempotent-running it multiple times can create duplicate resources |
| Resource Management   | Merges changes into the existing resource state                                              | Creates resources as defined in the configuration                       |
| File Handling         | Reads and applies configuration from YAML or JSON files                                      | Reads configuration from YAML or JSON files                             |
| Server-Side Apply Use | Supports server-side apply (Kubernetes 1.18+)                                                | Does not support server-side apply                                      |
| Update Strategy       | Patch-like update (only the changes are applied)                                             | Full resource creation                                                  |
| Conflict Resolution   | Handles conflicts by ***merging*** changes                                                   | No conflict resolution; will ***fail*** if resource already exists      |
| Annotations           | Adds `kubectl.kubernetes.io/last-applied-configuration` annotation for tracking changes      | Does not add such annotations                                           |
| Command               | `kubectl apply -f <filename>`                                                                | `kubectl create -f <filename>`                                          |

> NB:

Idempotency is a concept in computer science and programming that refers to the property of certain operations that can be applied multiple times without changing the result beyond the initial application.
