### [Security](https://kubernetes.io/docs/concepts/security/)

Kubernetes security involves multiple layers, from the cluster infrastructure to applications running inside it. Security is critical because Kubernetes exposes APIs and orchestrates workloads across multiple nodes. The **four C**s stand for **Cloud**, **Cluster**, **Container**, and **Code**, as shown in the following diagram:

![K8s Security Layer](/img/security/security-layer.png)

#### Authentication - Verify the identity of users or components accessing the cluster

- X.509 client certificates
- Static token files
- Service Account tokens (for pods)
- OpenID Connect (OIDC)
- LDAP or Active Directory

#### Authorization – Decide what an authenticated user can do

- `Role-Based Access Control (RBAC):` Most common; defines roles and role bindings.
- `Attribute-Based Access Control (ABAC):` Policies based on attributes of users and requests.
- `Webhook:` External authorization server validates requests.

```bash
# RBAC Role
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
```

#### Network Security

- `Network Policies:` Define which pods can communicate with each other.
- `Service Mesh (e.g., Istio, Linkerd):` Secure communication via mTLS.
- `Firewalls and Security Groups:` Control ingress and egress at the node or cloud level.

```bash
# NetworkPolicy
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
  namespace: default
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

#### Secrets & Configuration Management

- Store sensitive data (passwords, API keys) using Secrets.
- Avoid storing secrets in environment variables or ConfigMaps directly.
- Encrypt secrets at rest (enable EncryptionConfiguration).

```bash
apiVersion: v1
kind: Secret
metadata:
  name: my-secret
type: Opaque
data:
  username: bXl1c2Vy
  password: bXlwYXNz
```

#### Pod Security

- Pod Security Standards (PSS):
  - Privileged vs. Restricted: Control capabilities and host access.

- Use Security Contexts for pods and containers:
  - Run as non-root user
  - Limit capabilities
  - Set read-only root filesystem

```bash
securityContext:
  runAsUser: 1000
  runAsGroup: 3000
  fsGroup: 2000
  readOnlyRootFilesystem: true
```

#### Cluster Hardening

- Keep Kubernetes and container runtimes updated.
- Enable audit logging to monitor access.
- Enable API server TLS.
- Use network segmentation between master and worker nodes.
- Limit the scope of Service Accounts.

#### Cluster Management

- Cluster provisioning: Use tools like kubeadm, kops, Rancher, or managed services (EKS, AKS, GKE).
- Node management:
  - Monitor node health (kubectl get nodes)
  - Upgrade Kubernetes versions
  - Manage kubelet and container runtime

#### Resource Management

- `Namespaces:` Organize resources for multi-tenancy.
- `Resource Quotas & Limits:` Control CPU, memory usage per namespace or pod.

```bash
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
  namespace: dev
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
```

#### Workload Management

- Deployments, StatefulSets, DaemonSets, Jobs, and CronJobs.
- Use Horizontal Pod Autoscaler (HPA) and Vertical Pod Autoscaler (VPA) for scaling.
- Perform rolling updates and rollbacks.

#### Storage Administration

- Manage PersistentVolumes (PVs) and PersistentVolumeClaims (PVCs).
- Configure StorageClasses and dynamic provisioning.
- Monitor volume health and usage.

#### Monitoring & Logging

- Monitoring: Prometheus, Grafana, K8s Metrics Server.
- Logging: EFK stack (Elasticsearch, Fluentd, Kibana) or Loki.
- Audit logs for API access and cluster activity.

#### Backup & Disaster Recovery

- Backup etcd (cluster state) regularly.
- Backup persistent volumes.
- Test restore procedures.

#### Upgrades & Maintenance

- Upgrade control plane and worker nodes in a rolling manner.
- Drain nodes before maintenance: `kubectl drain <node-name>`.
- Ensure high availability for critical components (API server, etcd, controllers).
