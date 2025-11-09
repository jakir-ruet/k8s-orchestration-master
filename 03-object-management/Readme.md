#### Welcome to Object Management

Kubernetes objects are persistent entities in the Kubernetes system. Kubernetes uses these entities to represent the state of your cluster. Kubernetes object is also know as `Kubernetes Primitive`.

- Pods
- ReplicaSet
- DaemonSet
- StatefulSet
- Job CronJob
- Deployment

Difference & Comparison of `kubectl apply`  & `kubectl create`

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

NB:
Idempotency is a concept in computer science and programming that refers to the property of certain operations that can be applied multiple times without changing the result beyond the initial application.

Necessary commands

- Kubectl get
- Kubectl describe
- Kubectl create
- Kubectl apply
- Kubectl delete
- Kubectl exec

K8s RBAC Management

- Object
  - ***Roles*** (Define permission only within namespace in cluster)
    After assign the permission ***RoleBinding*** to the specific user 😐.
  - ***ClusterRoles*** (Define permission across the cluster. Not limited to specific namespace)
    After assign the permission ***ClusterRoleBinding*** to the specific user 😐.
