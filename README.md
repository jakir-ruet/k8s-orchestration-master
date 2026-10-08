## More About Me – [Take a Look!](https://www.linkedin.com/in/jakir-ruet)

## Kubernetes

Kubernetes is a portable, extensible, open source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. It has a large, rapidly growing ecosystem. Kubernetes services, support, and tools are widely available. It was originally developed by Google and is now maintained by the **Cloud Native Computing Foundation** (CNCF).

### Salient Feature

| **Feature**                        | **Description**                                                                                                |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------- |
| Service discovery & load balancing | - Expose containers via DNS or IP  <br> - Load balances traffic to keep deployments stable                     |
| Storage orchestration              | - Automatically mount local or cloud storage  <br> - Works with local disks, public cloud providers            |
| Automated rollouts & rollbacks     | - Manage container updates safely and gradually  <br> - Automate replacing or adopting containers              |
| Automatic bin packing              | - Efficiently place containers based on CPU/RAM needs  <br> - Makes best use of node resources                 |
| Self-healing                       | - Restart, replace, or remove unhealthy containers automatically  <br> - Only advertise ready Pods             |
| Secret & configuration management  | - Securely store and manage secrets (passwords, tokens, etc.)  <br> - Update configs without rebuilding images |
| Batch execution                    | - Manage batch or CI jobs  <br> - Restart failed containers                                                    |
| Horizontal scaling                 | - Scale applications up/down via commands, UI, or automatically                                                |
| IPv4/IPv6 dual-stack               | - Supports allocation of both IPv4 and IPv6 addresses to Pods and Services                                     |
| Designed for extensibility         | - Easily add features without changing Kubernetes core                                                         |

### [Types of components](https://kubernetes.io/docs/concepts/overview/components/)

| Category          | Component                                 | Function                                                 |
| ----------------- | ----------------------------------------- | -------------------------------------------------------- |
| **Control Plane** | **kube-apiserver**                        | Exposes the Kubernetes API and handles cluster requests. |
|                   | **etcd**                                  | Stores Kubernetes cluster state and configuration.       |
|                   | **kube-scheduler**                        | Assigns unscheduled Pods to suitable nodes.              |
|                   | **kube-controller-manager**               | Runs controllers to maintain the desired cluster state.  |
| ↳ Controller      | Node Controller                           | Monitors node health and availability.                   |
| ↳ Controller      | Replication Controller                    | Maintains the required number of Pod replicas.           |
| ↳ Controller      | Endpoint Controller                       | Maintains Service endpoint information.                  |
| ↳ Controller      | ServiceAccount Controller                 | Manages ServiceAccount resources.                        |
|                   | **cloud-controller-manager** *(Optional)* | Integrates Kubernetes with cloud-provider APIs.          |
| ↳ Controller      | Node Controller                           | Manages cloud-specific node information.                 |
| ↳ Controller      | Route Controller                          | Manages cloud network routes.                            |
| ↳ Controller      | Service Controller                        | Manages cloud load balancers for Services.               |
| **Worker Node**   | **kubelet**                               | Ensures assigned Pods and containers are running.        |
|                   | **kube-proxy** *(Optional)*               | Implements Service networking and traffic routing.       |
|                   | **Container Runtime**                     | Runs and manages containers.                             |
| **Add-ons**       | **DNS**                                   | Provides service discovery and DNS resolution.           |
|                   | **Web UI / Dashboard**                    | Provides a graphical interface for cluster management.   |
|                   | **Resource Monitoring**                   | Collects CPU, memory, and resource metrics.              |
|                   | **Cluster-level Logging**                 | Collects and aggregates cluster and application logs.    |

### [Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/)

Kubernetes Objects are persistent entities that represent the desired and current state of resources in a cluster. Most Kubernetes objects contain **spec** for the desired state and **status** for the current state.

### Required fields in object

| Field        | Purpose                                           |
| ------------ | ------------------------------------------------- |
| `apiVersion` | API version of the object                         |
| `kind`       | Type of Kubernetes object                         |
| `metadata`   | Object name, namespace, labels, annotations, etc. |
| `spec`       | Defines the desired state                         |

> **Note:** status is generally maintained by Kubernetes/controllers and is not normally specified by users when creating an object.

### Deployment as Object

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
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
          image: nginx:1.14.2
          ports:
            - containerPort: 80
```

### Server-Side Field Validation - since Kubernetes v1.25

The API server validates object fields when requests are submitted.

| Option             | Function                                |
| ------------------ | --------------------------------------- |
| `strict` / `true`  | Reject unknown or duplicate fields      |
| `warn`             | Accept the request but display warnings |
| `ignore` / `false` | Skip field validation                   |

```bash
kubectl apply -f deployment.yaml --validate=strict
```

### Common Kubernetes Objects

| Object                               | Function                                        |
| ------------------------------------ | ----------------------------------------------- |
| **Pod**                              | Runs one or more containers                     |
| **ReplicaSet**                       | Maintains the desired number of Pods            |
| **Deployment**                       | Manages ReplicaSets and application updates     |
| **StatefulSet**                      | Manages stateful Pods with stable identities    |
| **DaemonSet**                        | Runs a Pod on every or selected nodes           |
| **Job**                              | Runs a task to completion                       |
| **CronJob**                          | Creates Jobs on a schedule                      |
| **Service**                          | Provides a stable network endpoint for Pods     |
| **ConfigMap**                        | Stores non-sensitive configuration              |
| **Secret**                           | Stores sensitive configuration data             |
| **PersistentVolume (PV)**            | Represents cluster storage                      |
| **PersistentVolumeClaim (PVC)**      | Requests storage                                |
| **Namespace**                        | Provides logical resource isolation             |
| **Ingress**                          | Routes external HTTP/HTTPS traffic to Services  |
| **NetworkPolicy**                    | Controls Pod network traffic                    |
| **ResourceQuota**                    | Limits resource usage within a namespace        |
| **LimitRange**                       | Defines resource defaults and limits            |
| **HorizontalPodAutoscaler**          | Automatically scales workloads based on metrics |
| **PodDisruptionBudget**              | Limits voluntary Pod disruptions                |
| **Role / ClusterRole**               | Defines RBAC permissions                        |
| **RoleBinding / ClusterRoleBinding** | Assigns RBAC roles to identities                |
| **ServiceAccount**                   | Provides an identity for Pods                   |
| **EndpointSlice**                    | Tracks network endpoints for Services           |
| **CustomResourceDefinition (CRD)**   | Extends the Kubernetes API with custom objects  |

### [Object Management](https://kubernetes.io/docs/concepts/overview/working-with-objects/object-management/) - Kubernetes objects can be managed primarily using

| Approach        | Description                                                  |
| --------------- | ------------------------------------------------------------ |
| **Imperative**  | Specify the operation directly using `kubectl` commands      |
| **Declarative** | Define the desired state in YAML and apply it to the cluster |

```bash
# Imperative
kubectl create deployment nginx --image=nginx
```

```bash
# Declarative
kubectl apply -f deployment.yaml
```

### [Cluster](https://kubernetes.io/docs/concepts/architecture/)

It is made up of at least one master node and one or more worker nodes. The **master node makes up the control plane** of a cluster and is responsible for scheduling tasks and monitoring the state of the cluster.

![Cluster](/img/cluster.png)

> - CRI: Container Runtime Interface
> - CNI: Container Network Interface

### [Nodes](https://kubernetes.io/docs/concepts/architecture/nodes/)

Kubernetes runs workloads by placing containers inside **Pods**, which run on **Nodes**. A Node can be a **physical or virtual machine**, depending on the cluster. Each Node is managed by the control plane and contains the components required to run Pods.

- The **kubelet** on the Node automatically registers the Node with the control plane.
- A user or administrator manually creates a **Node object** in the API server.

```json
{
  "kind": "Node",
  "apiVersion": "v1",
  "metadata": {
    "name": "10.240.79.157",
    "labels": {
      "name": "my-first-k8s-node"
    }
  }
}
```

### Node and Control Plane Communication

Kubernetes uses the **kube-apiserver** as the central communication point between the control plane, Nodes, and Kubernetes clients. A simplified communication model is:

```text
                         ┌──────────────────────────┐
                         │       Kubernetes         │
                         │       Control Plane      │
                         │                          │
                         │  kube-apiserver          │
                         │  kube-scheduler          │
                         │  controller-manager      │
                         │  etcd                    │
                         └────────────┬─────────────┘
                                      │
                              Kubernetes API
                                      │
                 ┌────────────────────┼────────────────────┐
                 │                    │                    │
                 ▼                    ▼                    ▼
              Worker 1             Worker 2             Worker 3
                 │                    │                    │
              kubelet              kubelet              kubelet
                 │                    │                    │
            Container Runtime   Container Runtime   Container Runtime
                 │                    │                    │
              Containers           Containers           Containers
                 │
                 ├── CNI
                 └── CSI
```

The **kube-apiserver** is therefore the primary communication hub for Kubernetes API operations.

---

### 1. Main Communication Paths

There are several important communication paths in a Kubernetes cluster:

```text
1. kubectl / Client
       ↓
   kube-apiserver

2. kubelet
       ↓
   kube-apiserver

3. kube-apiserver
       ↓
   kubelet

4. Control Plane Components
       ↓
   kube-apiserver

5. kube-apiserver
       ↓
   etcd

6. Pod
       ↓
   kube-apiserver
       (only when required by the application)

7. Pod
       ↔
   Pod

8. Pod
       ↓
   Service
       ↓
   Pod
```

These paths should be understood separately because they have different protocols, authentication mechanisms, and security requirements.

---

#### 2. Node → Control Plane Communication

The primary path is:

```text
Node
 │
 ├── kubelet
 │
 └──────── HTTPS ────────► kube-apiserver
```

The **kubelet** communicates with the API server to:

- Register the Node.
- Report Node status.
- Report Pod status.
- Retrieve Pod specifications assigned to the Node.
- Receive configuration required for Pod management.
- Perform other Kubernetes API operations required for Node management.

The communication normally uses **HTTPS/TLS**.

---

#### 3. Kubelet Authentication

The kubelet must authenticate to the API server.

A common bootstrap process is:

```text
New Node
   │
   ▼
kubelet
   │
   │ TLS bootstrap / credentials
   ▼
kube-apiserver
   │
   ▼
Authentication
   │
   ▼
Authorization
   │
   ▼
Node identity
```

The kubelet typically operates using a Node identity such as:

```text
system:node:<node-name>
```

The exact authentication mechanism depends on the cluster configuration.

Common mechanisms include:

- Client certificates
- TLS bootstrapping
- Authentication configuration provided to the kubelet

---

#### 4. Kubelet Authorization

Authentication answers:

> **Who is this client?**

Authorization answers:

> **What is this client allowed to do?**

Kubernetes provides **Node authorization** specifically for kubelets.

The Node authorizer restricts kubelet access to resources associated with the Node and its workloads.

Conceptually:

```text
kubelet
   │
   │ "I am system:node:worker-01"
   ▼
Authentication
   │
   ▼
Authorization
   │
   ▼
Node Authorizer
   │
   ▼
Allowed / Denied
```

This follows the Kubernetes security model of:

**Authenticate → Authorize → Execute**

---

#### 5. Node Registration

A Node can become known to the Kubernetes API server through kubelet registration.

```text
kubelet
   │
   │ register
   ▼
kube-apiserver
   │
   ▼
Node object
```

The Node is represented in Kubernetes as a **Node API object**.

You can inspect Nodes with:

```bash
kubectl get nodes
```

Detailed information:

```bash
kubectl describe node <node-name>
```

---

#### 6. Node Heartbeats and Leases

Kubernetes needs to determine whether a Node is healthy and reachable.

The kubelet periodically communicates its health information.

Modern Kubernetes also uses **Lease objects** for lightweight Node heartbeats.

```text
kubelet
   │
   │ renew Lease
   ▼
kube-apiserver
   │
   ▼
kube-node-lease namespace
```

Each Node has a corresponding Lease.

You can inspect them with:

```bash
kubectl get lease -n kube-node-lease
```

The Node Controller uses Node health information and Lease activity to help determine Node availability.

---

#### 7. Node Status

The kubelet reports information about the Node to the API server.

Important Node conditions include:

| Condition            | Meaning                              |
| -------------------- | ------------------------------------ |
| `Ready`              | Node is healthy and able to run Pods |
| `MemoryPressure`     | Node has insufficient memory         |
| `DiskPressure`       | Node has insufficient disk space     |
| `PIDPressure`        | Node has too many processes          |
| `NetworkUnavailable` | Node networking is unavailable       |

Inspect them with:

```bash
kubectl describe node <node-name>
```

---

#### 8. Control Plane → Node Communication

The primary control-plane-to-Node communication path is:

```text
kube-apiserver
       │
       │ HTTPS
       ▼
    kubelet
       │
       ▼
Container Runtime
```

The API server communicates with the kubelet for operations that require direct interaction with the Node.

Examples include:

- Pod logs
- Container attachment
- `kubectl exec`
- `kubectl port-forward`

---

#### 9. API Server → Kubelet

The API server connects to the kubelet's HTTPS endpoint.

For example:

```text
kubectl
   │
   ▼
kube-apiserver
   │
   │ HTTPS
   ▼
kubelet
   │
   ▼
container runtime
   │
   ▼
container
```

#### Pod Logs

When you execute:

```bash
kubectl logs nginx
```

the request follows approximately:

```text
kubectl
   ↓
kube-apiserver
   ↓
kubelet
   ↓
container runtime / container logs
   ↓
kubelet
   ↓
kube-apiserver
   ↓
kubectl
```

---

#### 10. kubectl exec

For:

```bash
kubectl exec -it nginx -- /bin/sh
```

the communication path involves the API server and the kubelet:

```text
kubectl
   │
   ▼
kube-apiserver
   │
   ▼
kubelet
   │
   ▼
container runtime
   │
   ▼
container
```

This is different from ordinary Kubernetes API requests because the operation ultimately requires interaction with the running container on the Node.

---

#### 11. kubectl port-forward

For:

```bash
kubectl port-forward pod/nginx 8080:80
```

the API server coordinates the request with the kubelet, which provides the connection to the Pod.

Conceptually:

```text
Local machine
      │
      ▼
  kubectl
      │
      ▼
kube-apiserver
      │
      ▼
   kubelet
      │
      ▼
     Pod
```

---

#### 12. Kubelet Certificate Verification

The API server communicates with the kubelet over HTTPS.

The kubelet presents a serving certificate.

For stronger security, the API server can be configured to verify the kubelet certificate against a trusted CA.

For example:

```text
--kubelet-certificate-authority
```

This establishes a stronger trust relationship:

```text
kube-apiserver
      │
      │ TLS
      ▼
Validate kubelet certificate
      │
      ▼
Trusted kubelet
```

Without proper certificate validation, encrypted communication alone does not necessarily provide protection against endpoint impersonation.

---

#### 13. API Server → Node, Pod, and Service Proxy

The API server also provides proxy functionality for accessing:

- Nodes
- Pods
- Services

Conceptually:

```text
Client
   │
   ▼
kube-apiserver
   │
   ├────────► Node
   │
   ├────────► Pod
   │
   └────────► Service
```

The security of the connection beyond the API server depends on the configured transport and endpoint.

Using HTTPS is preferable to plaintext HTTP, but **TLS encryption alone is not sufficient** if certificate verification and endpoint authentication are not properly configured.

---

#### 14. Control Plane Components → API Server

Control-plane components generally communicate through the API server.

```text
                  ┌──────────────────┐
                  │ kube-apiserver   │
                  └────────┬─────────┘
                           │
          ┌────────────────┼────────────────┐
          │                │                │
          ▼                ▼                ▼
   kube-scheduler   controller-manager   clients
```

##### kube-scheduler

The scheduler watches for unscheduled Pods through the API server.

```text
Pod
 │
 │ unscheduled
 ▼
kube-apiserver
 │
 ▼
kube-scheduler
 │
 │ selects Node
 ▼
kube-apiserver
 │
 ▼
Pod assigned to Node
```

---

### 15. Controller Manager → API Server

Controllers continuously compare:

```text
Desired State
      vs
Current State
```

For example:

```text
Deployment
   │
   │ desired: 3 replicas
   ▼
controller
   │
   │ current: 2 replicas
   ▼
create Pod
   │
   ▼
kube-apiserver
```

The controller manager therefore relies heavily on the API server as the interface for observing and modifying cluster state.

---

### 16. API Server → etcd

The API server is also the primary Kubernetes component that communicates with **etcd**.

```text
Kubernetes clients
       │
       ▼
kube-apiserver
       │
       │ HTTPS
       ▼
      etcd
```

Kubernetes cluster state is stored in etcd.

Examples include:

- Nodes
- Pods
- Deployments
- Services
- ConfigMaps
- Secrets
- RBAC objects
- Custom Resources

A simplified request path is:

```text
kubectl
   │
   ▼
kube-apiserver
   │
   ▼
 authentication
   │
   ▼
 authorization
   │
   ▼
 admission
   │
   ▼
 etcd
```

The API server is therefore the **gateway to Kubernetes state**, rather than individual components directly modifying etcd.

---

### 17. Pod → API Server Communication

Pods can communicate with the Kubernetes API server when their applications need Kubernetes API access.

Typical path:

```text
Pod
 │
 │ ServiceAccount credentials
 ▼
Kubernetes Service
 │
 ▼
kube-apiserver
```

A Pod can receive ServiceAccount credentials through its projected volume configuration.

Applications can then authenticate to the Kubernetes API using those credentials, subject to RBAC permissions.

Important distinction:

> **Pods do not automatically need to communicate with the API server.**

Only applications that require Kubernetes API functionality need this communication.

---

### 18. Pod → Pod Communication

Pod-to-Pod communication is different from control-plane communication.

Kubernetes networking generally expects:

```text
Pod A
  │
  │ Pod network
  ▼
Pod B
```

Pods normally receive their own IP addresses.

The CNI plugin provides the underlying Pod networking implementation.

For example:

```text
Pod
 │
 ▼
CNI
 │
 ▼
Node Network
 │
 ▼
Other Node
 │
 ▼
CNI
 │
 ▼
Destination Pod
```

This traffic does **not normally go through the kube-apiserver**.

---

### 19. Pod → Service Communication

Applications normally access other applications through a **Service**.

```text
Pod A
 │
 │ request
 ▼
Service
 │
 ▼
Service routing
 │
 ├──► Pod B
 ├──► Pod C
 └──► Pod D
```

The Service provides a stable virtual endpoint while the underlying Pods may be created, destroyed, or replaced.

---

### 20. Service Networking

A simplified model is:

```text
Client Pod
    │
    ▼
Service IP
    │
    ▼
Service routing
    │
    ▼
EndpointSlice
    │
    ▼
Backend Pod
```

Service traffic handling may involve:

- `kube-proxy`
- CNI networking
- eBPF-based networking in some Kubernetes environments

The exact implementation depends on the cluster's networking solution.

---

### 21. CNI Communication

The **Container Network Interface (CNI)** is responsible for configuring Pod networking.

Conceptually:

```text
kubelet
   │
   │ invokes networking setup
   ▼
CNI plugin
   │
   ├── Pod interface
   ├── IP address
   ├── Routes
   └── Network connectivity
```

Examples of CNI implementations include:

- Cilium
- Calico
- Flannel
- cloud-provider networking plugins

---

### 22. CSI Communication

Storage follows another communication path.

```text
Pod
 │
 ▼
kubelet
 │
 ▼
CSI driver
 │
 ▼
Storage system
```

The **Container Storage Interface (CSI)** allows Kubernetes to communicate with storage systems.

For example:

```text
Pod
 ↓
PVC
 ↓
PV
 ↓
CSI Driver
 ↓
Cloud / SAN / NAS / Storage Platform
```

---

### 23. DNS Communication

Applications commonly use Kubernetes DNS for Service discovery.

```text
Pod
 │
 │ DNS query
 ▼
CoreDNS
 │
 ▼
Service / DNS records
```

For example:

```text
backend.default.svc.cluster.local
```

may resolve to the Service's cluster IP.

DNS traffic is therefore primarily **Pod → DNS**, not Pod → API server.

---

### 24. Node → Node Communication

Nodes also communicate directly with one another depending on the networking implementation.

Typical traffic can include:

```text
Node A
 │
 ├── Pod → Pod
 ├── Service traffic
 ├── CNI traffic
 └── Overlay / routing traffic
 │
 ▼
Node B
```

The exact ports and protocols depend on the selected CNI and cluster architecture.

Examples may include:

- VXLAN
- Geneve
- IP-in-IP
- BGP
- Native cloud routing
- eBPF-based forwarding

Therefore, there is **no single universal Node-to-Node port list** for every Kubernetes cluster.

---

### 25. Node → External Network

Pods and Nodes may need to communicate with external systems:

```text
Pod
 │
 ▼
Node
 │
 ▼
Network Gateway
 │
 ▼
Internet / Corporate Network
 │
 ▼
External Service
```

Examples:

- Database servers
- External APIs
- SaaS platforms
- Container registries
- DNS infrastructure
- Monitoring systems

Network policies, firewalls, security groups, NAT, and routing determine whether such communication is allowed.

---

### 26. NetworkPolicy and Communication

Kubernetes **NetworkPolicy** can control Pod traffic.

Conceptually:

```text
Pod A ───────► Pod B
       ALLOW

Pod A ───────X Pod C
       DENY
```

Policies can control:

- Ingress traffic
- Egress traffic
- Source Pods
- Destination Pods
- Namespaces
- IP ranges
- Ports and protocols

NetworkPolicy enforcement requires a networking implementation that supports NetworkPolicy.

---

### 27. SSH Tunnels

Historically, Kubernetes supported SSH tunneling for control-plane-to-Node communication.

Conceptually:

```text
kube-apiserver
      │
      │ SSH
      ▼
    Node
      │
      ▼
   kubelet
```

SSH tunneling can provide a protected path when direct connectivity is unsuitable.

Modern Kubernetes deployments generally rely on **TLS-secured communication and network-level security controls** rather than SSH tunnels.

---

### 28. Communication Security Model

Kubernetes communication should be understood using four security layers:

```text
┌─────────────────────────────┐
│ Authentication              │
├─────────────────────────────┤
│ Authorization               │
├─────────────────────────────┤
│ TLS / Encryption            │
├─────────────────────────────┤
│ Network Policy / Firewall   │
└─────────────────────────────┘
```

### Authentication

Determines:

> Who are you?

Examples:

- Client certificates
- ServiceAccount tokens
- OIDC
- Other configured authentication mechanisms

### Authorization

Determines:

> What are you allowed to do?

Examples:

- RBAC
- Node authorization

### Encryption

Determines:

> Is the communication protected in transit?

Typically:

```text
HTTPS / TLS
```

### Network Security

Determines:

> Can the traffic reach the destination at all?

Examples:

- Firewall
- Security groups
- NetworkPolicy
- Network ACLs
- Routing rules

---

### 29. Complete Kubernetes Communication Model

The following model brings the major communication paths together:

```text
					┌─────────────────────┐
					│       kubectl       │
					└──────────┬──────────┘
									│
								HTTPS
									│
									▼
					┌─────────────────────┐
					│   kube-apiserver    │
					└──────────┬──────────┘
									│
	┌──────────────────────┼──────────────────────┐
	│                      │                      │
	▼                      ▼                      ▼
	etcd              kube-scheduler        controllers
	│                      │                      │
	│                      └──────────┬───────────┘
	│                                 │
	│                                 ▼
	│                         kube-apiserver
	│
	└─────────────────────────────────────────────

									│
								HTTPS
									│
	┌──────────────────────┼──────────────────────┐
	│                      │                      │
	▼                      ▼                      ▼
	Node 1                  Node 2                 Node 3
	│                      │                      │
	kubelet                kubelet                kubelet
	│                      │                      │
	Container Runtime      Container Runtime      Container Runtime
	│                      │                      │
	┌───┴───┐              ┌───┴───┐              ┌───┴───┐
	│       │              │       │              │       │
	Pod     Pod            Pod     Pod            Pod     Pod
	│       │              │       │              │       │
	└───┬───┘              └───┬───┘              └───┬───┘
	│                      │                      │
	└────────────── CNI / Pod Network ────────────┘
```

---

### 30. Communication Matrix

A useful reference table is:

| Source      | Destination       | Purpose                          | Typical Security           |
| ----------- | ----------------- | -------------------------------- | -------------------------- |
| `kubectl`   | API server        | Kubernetes API operations        | HTTPS/TLS                  |
| kubelet     | API server        | Node/Pod management and status   | HTTPS/TLS                  |
| API server  | kubelet           | Logs, exec, attach, port-forward | HTTPS/TLS                  |
| API server  | etcd              | Cluster state storage            | HTTPS/TLS                  |
| Scheduler   | API server        | Watch and bind Pods              | HTTPS/TLS                  |
| Controllers | API server        | Watch/update resources           | HTTPS/TLS                  |
| Pod         | API server        | Kubernetes API access            | HTTPS/TLS + ServiceAccount |
| Pod         | Pod               | Application traffic              | CNI/network                |
| Pod         | Service           | Application/service traffic      | CNI + Service routing      |
| Pod         | CoreDNS           | DNS resolution                   | Cluster networking         |
| kubelet     | Container Runtime | Container lifecycle              | CRI                        |
| kubelet     | CNI               | Pod networking                   | CNI                        |
| kubelet     | CSI               | Storage operations               | CSI                        |
| Node        | Node              | Pod/network traffic              | CNI/network                |
| Pod         | External system   | External application traffic     | Network/TLS dependent      |

---

### 31. Important Port Concepts

Do not memorize one universal port table for Kubernetes networking.

Some common ports include:

| Port    | Typical Component | Purpose              |
| ------- | ----------------- | -------------------- |
| `6443`  | kube-apiserver    | Kubernetes API       |
| `2379`  | etcd              | Client communication |
| `2380`  | etcd              | Peer communication   |
| `10250` | kubelet           | Kubelet API          |
| `53`    | DNS               | DNS queries          |
| `22`    | SSH               | SSH, if used         |

The actual ports can vary depending on:

- Kubernetes distribution
- Cloud provider
- CNI
- Container runtime
- Service configuration
- Cluster architecture

Always verify the configuration of the actual cluster rather than relying solely on a generic port list.

---

### 32. End-to-End Example: Deploying an Application

Suppose you execute:

```bash
kubectl apply -f deployment.yaml
```

The communication flow is approximately:

```text
Developer
    │
    ▼
 kubectl
    │
    │ HTTPS
    ▼
kube-apiserver
    │
    ▼
Authentication
    │
    ▼
Authorization
    │
    ▼
Admission
    │
    ▼
Cluster State
    │
    ▼
Controllers
    │
    ▼
ReplicaSet
    │
    ▼
Pod
    │
    ▼
Scheduler
    │
    ▼
Node Assignment
    │
    ▼
kubelet
    │
    ▼
Container Runtime
    │
    ▼
Container
```

---

### 33. End-to-End Example: Application Request

Suppose a frontend Pod calls a backend Service:

```text
Frontend Pod
     │
     │ DNS lookup
     ▼
   CoreDNS
     │
     │ backend Service IP
     ▼
Backend Service
     │
     │ Service routing
     ▼
Backend Pod
     │
     ▼
Application
```

Notice that the **kube-apiserver is not in the normal data path**.

This distinction is fundamental:

> **The Kubernetes API server manages the cluster; it does not normally carry application traffic between Pods.**

---

### 34. Control Plane vs Data Plane

This distinction should be emphasized in your README.

### Control Plane Traffic

Responsible for managing Kubernetes:

```text
kubectl
   ↓
API Server
   ↓
Controllers / Scheduler / etcd
   ↓
kubelet
```

Examples:

- Pod scheduling
- Node management
- Resource updates
- Cluster state
- Pod logs
- `exec`
- `port-forward`

### Data Plane Traffic

Responsible for running applications:

```text
Pod
 ↓
Service
 ↓
Pod
```

and:

```text
Pod
 ↓
External Network
```

The data plane is primarily handled by:

- CNI
- kube-proxy or equivalent
- Node networking
- Load balancers
- NetworkPolicy implementation

---

### 35. The Most Important Concept

A useful mental model is:

```text
                 CONTROL PLANE
                      │
                      │ Kubernetes API
                      ▼
                 kube-apiserver
                      │
          ┌───────────┴───────────┐
          │                       │
          ▼                       ▼
       kubelet              Cluster State
          │                    / etcd
          ▼
   Container Runtime
          │
          ▼
       Containers
          │
          ▼
       APPLICATION
          │
          ▼
   ┌──────┴───────┐
   │              │
   ▼              ▼
 Services       External
   │             Systems
   ▼
 Pods
```

The key principle is:

> **The API server is primarily the control-plane communication hub, while the CNI/networking layer carries normal application data-plane traffic.**

Understanding this distinction makes Kubernetes networking, troubleshooting, security, and architecture significantly easier.

### [Self-Healing capabilities](https://kubernetes.io/docs/concepts/architecture/self-healing/)

| Self-Healing Capability         | Function                                                                                                                                                                                 |
| ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Container-level restart**     | If a container fails, the **kubelet** can restart it according to the Pod's `restartPolicy`.                                                                                             |
| **Pod replacement**             | If a Pod managed by a **Deployment, StatefulSet, or DaemonSet** fails, the controller creates a replacement Pod to maintain the desired state.                                           |
| **Persistent storage recovery** | If a Node fails while running a Pod with persistent storage, Kubernetes can coordinate volume detachment and reattachment to a replacement Pod, depending on the storage implementation. |
| **Service traffic management**  | When a Pod is no longer ready, Kubernetes removes it from the Service's eligible endpoints so normal Service traffic is directed to healthy Pods.                                        |

#### Couple of key components for Self-Healing

- **kubelet** Ensures that containers are running, and restarts those that fail.
- **ReplicaSet, StatefulSet and DaemonSet controller** Maintains the desired number of Pod replicas.
- **PersistentVolume controller** Manages volume attachment and detachment for stateful workloads.

##### Considerations

- **Storage Failures:** If a persistent volume becomes unavailable, recovery steps may be required
- **Application Errors:** Kubernetes can restart containers, but underlying application issues must be addressed separately.

#### [Container Runtime Interface (CRI)](https://kubernetes.io/docs/concepts/architecture/cri/)

The CRI is a plugin interface which enables the kubelet to use a wide variety of container runtimes, without having a need to recompile the cluster components.

- Each node needs a working `container runtime` so the kubelet can run Pods and containers
- Kubernetes uses the `Container Runtime Interface (CRI)` as the standard communication between the `kubelet and Container Runtime`.
- CRI defines a `gRPC` interface for kubelet to talk to the container runtime on the node

#### [Garbage Collection](https://kubernetes.io/docs/concepts/architecture/garbage-collection/)

- Terminated pods
- Completed Jobs
- Objects without owner references
- Unused containers and container images
- Dynamically provisioned PersistentVolumes with a StorageClass reclaim policy of Delete
- Stale or expired CertificateSigningRequests (CSRs)
- Nodes deleted in the following scenarios:
  - On a cloud when the cluster uses a cloud controller manager
  - On-premises when the cluster uses an addon similar to a cloud controller manager
- Node Lease objects

### [Containers](https://kubernetes.io/docs/concepts/containers/)

Technology for packaging an application along with its runtime dependencies.

#### Container images

- A container image is a ready-to-run package with:
  - Application code
  - Required runtime
  - Libraries
  - Default settings
- Containers are designed to be stateless and immutable:
  - Do not change code inside a running container
  - Instead, build a new image with changes and redeploy the container

#### [Container runtimes](https://kubernetes.io/docs/concepts/containers/)

A fundamental component that empowers Kubernetes to run containers effectively. It is responsible for managing the execution and lifecycle of containers within the Kubernetes environment.

- Kubernetes supports container runtimes like containerd, CRI-O, and any CRI-compatible runtime
- By default, the cluster chooses the container runtime for a Pod
- If you need multiple runtimes, use RuntimeClass to select a specific runtime for a Pod
- RuntimeClass can also let you run Pods with the same runtime but different settings

#### [Container environment](https://kubernetes.io/docs/concepts/containers/container-environment/)

The Kubernetes Container environment provides several important resources to Containers:

- A filesystem, which is a combination of an image and one or more volumes.
- Information about the Container itself.
- Information about other objects in the cluster.

#### [Container Lifecycle Hooks](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/)

How kubelet managed Containers can use the Container lifecycle hook framework to run code triggered by events during their management lifecycle.

### [Workloads](https://kubernetes.io/docs/concepts/workloads/)

**Pods** Understand Pods, the smallest deployable compute object in Kubernetes, and the higher-level abstractions that help you to run them.

- A workload is any application running on Kubernetes, whether single or multi-component
- Workloads run inside Pods, which hold one or more containers
- Pods have a lifecycle:
  - If the node fails, the Pod fails permanently
  - A new Pod must be created to recover
- You don’t have to manage Pods directly — use workload resources to do it

#### Built-in workload resources

- [**Deployment/ReplicaSet**](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)
  - Good for stateless apps
  - Any Pod can be replaced interchangeably
- [**StatefulSet**](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
  - For stateful apps needing stable identities
  - Can use PersistentVolumes and replicate data
- [**DaemonSet**](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
  - Runs a Pod on every matching node
  - Useful for node-level tasks like networking plugins or monitoring
- [**Job**](https://kubernetes.io/docs/concepts/workloads/controllers/job/)
  - Runs a task once, until completion
- [**CronJob**](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)
  - Runs Jobs on a schedule
- **Custom Resources**
  - You can define third-party workload resources with custom behavior
  - For advanced needs beyond the built-in controllers

#### [Pod (as in a pod of whales or pea pod)](https://kubernetes.io/docs/concepts/workloads/pods/)

Pods are the smallest deployable units of computing that you can create and manage in Kubernetes. It's is a group of one or more containers, with shared storage and network resources, and a specification for how to run the containers. Pods are used in `two` main ways:

- Single-container Pods (most common)
  - Pod acts as a wrapper for one container
  - Kubernetes manages the Pod instead of managing the container directly
- Multi-container Pods
  - Runs multiple containers that work tightly together
  - Containers share resources and act as a single unit
  - Useful only when containers are tightly coupled
- For scaling and replication, you generally create multiple Pods, rather than putting multiple containers in a single Pod.

**Pod Definition:**

```bash
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```

**With Pod Template:**

```bash
apiVersion: batch/v1
kind: Job
metadata:
  name: hello
spec:
  template:
    # This is the pod template
    spec:
      containers:
      - name: hello
        image: busybox:1.28
        command: ['sh', '-c', 'echo "Hello, Kubernetes!" && sleep 3600']
      restartPolicy: OnFailure
    # The pod template ends here
```

**Some workload resources that manage one or more Pods:**

- Deployment
- StatefulSet
- DaemonSet

##### Pod update and replacement

When the Pod template for a workload resource is changed, the controller creates new Pods based on the updated template instead of updating or patching the existing Pods. You should not manually update Pods directly. Instead, manage Pods through controllers like `Deployments`, `StatefulSets`, or `DaemonSets`, which will create new Pods with your changes automatically.

**Using Deployment:**

```bash
kubectl set image deployment my-deployment my-container=myimage:2.0
```

##### But what if you need

- kubectl patch
- kubectl edit
- kubectl replace

```bash
kubectl patch pod my-pod -p '{"spec":{"containers":[{"name":"my-container","image":"nginx:1.25"}]}}'
```

##### Pod subresources

The above update rules apply to regular pod updates, but other pod fields can be updated through subresources.

- **Resize**
  - Allows updating container resource limits and requests (`spec.containers[*].resources`)
  - See: **Resize Container Resources** for details

- **Ephemeral Containers**
  - Lets you add ephemeral containers to a running Pod
  - Useful for debugging

- **Status**
  - Allows updating the Pod's status
  - Typically used only by the Kubelet or system controllers

- **Binding**
  - Allows setting the Pod’s `spec.nodeName` to bind it to a specific node
  - Usually handled by the Kubernetes scheduler

##### Resource sharing and communication

Pods enable data sharing and communication among their constituent containers.

##### Storage in Pods

- Pods can define shared storage volumes
- Persistent storage volumes by attaching a PersistentVolume (PV) through a PersistentVolumeClaim (PVC)
- All containers in the Pod can access these volumes to share data
- Volumes allow data to persist even if a container inside the Pod restarts
- See Kubernetes Storage documentation for deeper details

##### Pod Networking

- Each Pod gets a unique IP address for each address family (IPv4/IPv6)
- All containers in a Pod:
  - Share the same network namespace
  - Share the same IP address and port space
  - Can talk to each other using `localhost`
- Containers in the same Pod can also use standard inter-process communication (e.g., SystemV semaphores, POSIX shared memory)
- Containers in different Pods:
  - Have different IP addresses
  - Communicate using IP networking (no shared IPC)
- The system hostname inside each container matches the Pod’s configured name

##### Static Pods

- Managed directly by the **kubelet**, not by the API server
- Kubelet supervises static Pods and restarts them if they fail
- Always tied to one specific node and its kubelet
- Commonly used to run **self-hosted control plane components**
- Kubelet creates a **mirror Pod** on the API server to make static Pods visible there
  - However, you cannot manage static Pods through the API server
- See the **Create static Pods** guide for more details

##### Pod lifecycle

A Pod lifecycle describes how a Pod goes through different phases from creation to termination. Lifecycle stages shown below;

| **Phase** | **Description**                                                                                                 |
| --------- | --------------------------------------------------------------------------------------------------------------- |
| Pending   | Pod accepted by the cluster, but containers haven’t started yet (e.g., waiting for scheduling or image pulling) |
| Running   | At least one container has started successfully, and the Pod is active                                          |
| Succeeded | All containers have completed successfully and won’t restart                                                    |
| Failed    | At least one container terminated with an error and will not restart                                            |
| Unknown   | Pod state cannot be determined (e.g., lost communication with the node)                                         |

##### [Init Containers](https://kubernetes.io/docs/concepts/workloads/pods/init-containers/)

This is specialized containers that run before app containers in a Pod. Init containers can contain utilities or setup scripts not present in an app image. You can specify init containers in the Pod specification alongside the containers array (which describes app containers).

```bash
apiVersion: v1
kind: Pod
metadata:
  name: myapp-pod
  labels:
    app.kubernetes.io/name: MyApp
spec:
  containers:
  - name: myapp-container
    image: busybox:1.28
    command: ['sh', '-c', 'echo The app is running! && sleep 3600']
  initContainers:
  - name: init-myservice
    image: busybox:1.28
    command: ['sh', '-c', "until nslookup myservice.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for myservice; sleep 2; done"]
  - name: init-mydb
    image: busybox:1.28
    command: ['sh', '-c', "until nslookup mydb.$(cat /var/run/secrets/kubernetes.io/serviceaccount/namespace).svc.cluster.local; do echo waiting for mydb; sleep 2; done"]
```

##### [Sidecar Containers](https://kubernetes.io/docs/concepts/workloads/pods/sidecar-containers/)

A secondary container that runs in the same Pod as the main application container, providing supporting features (like logging, monitoring, or security) without modifying the primary application’s code. It shares storage, networking, and lifecycle with the main container.

- Example:
  - App container runs a web application
  - Sidecar container runs a local web server to serve its content

#### [Namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)

Namespaces is virtual cluster in a cluster, where organized the resources. Namespaces provides a mechanism for isolating groups of resources within a single cluster. Names of resources need to be unique within a namespace, but not across namespaces. Kubernetes starts with four initial namespaces:

1. default
    - We can start using your new cluster without first creating a namespace.
    - Resource we can create are located here.

2. kube-node-lease
    - Heartbeats of nodes so that the control plane can detect node failure.
    - Each node has associated lease object in namespace.
    - Determines the availability of a node.

3. kube-public:
    - Publicly accessible data, even without any authentication.
    - A configure, which containers cluster information.

4. kube-system (```kubectl cluster-info```):
    - The namespace for objects created by the Kubernetes system.
    - Do not create or modify in kube system.
    - System Process.
    - Master and Kubectl processes

**Importance:**

- Everything in one namespace (default).
  - Deployments
  - ReplicaSets
  - Services
  - ConfigMaps
- Resources grouping (database, monitoring, elastic stack, nginx-ingress) is possible in namespace.
- Conflicts minimization in same application with many teams.
- Resources sharing is possible such as staging, development, env setup.
- Limit the access into resource will possible on namespace.
- Own ConfigMap only possible in each namespace.

#### Workload Management

- Kubernetes offers built-in APIs to manage your workloads declaratively. Instead of handling Pods manually, you define higher-level workload objects (like Deployments), and Kubernetes automatically creates and manages the Pods for you, replacing them if they fail.

##### [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)

A Deployment manages a set of Pods to run an application workload, usually one that doesn't maintain state.

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
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
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

##### [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)

A ReplicaSet's purpose is to maintain a stable set of replica Pods running at any given time. Usually, you define a Deployment and let that Deployment manage ReplicaSets automatically.

```bash
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: frontend
  labels:
    app: guestbook
    tier: frontend
spec:
  # modify replicas according to your case
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: us-docker.pkg.dev/google-samples/containers/gke/gb-frontend:v5
```

##### [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)

A StatefulSet runs a group of Pods, and maintains a sticky identity for each of those Pods. This is useful for managing applications that need persistent storage or a stable, unique network identity.

```bash
apiVersion: v1
kind: Service
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  ports:
  - port: 80
    name: web
  clusterIP: None
  selector:
    app: nginx
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  selector:
    matchLabels:
      app: nginx # has to match .spec.template.metadata.labels
  serviceName: "nginx"
  replicas: 3 # by default is 1
  minReadySeconds: 10 # by default is 0
  template:
    metadata:
      labels:
        app: nginx # has to match .spec.selector.matchLabels
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - name: nginx
        image: registry.k8s.io/nginx-slim:0.24
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: www
          mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes: [ "ReadWriteOnce" ]
      storageClassName: "my-storage-class"
      resources:
        requests:
          storage: 1Gi
```

##### [DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)

A DaemonSet defines Pods that provide node-local facilities. These might be fundamental to the operation of your cluster, such as a networking helper tool, or be part of an add-on.

```bash
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: fluentd-elasticsearch
  namespace: kube-system
  labels:
    k8s-app: fluentd-logging
spec:
  selector:
    matchLabels:
      name: fluentd-elasticsearch
  template:
    metadata:
      labels:
        name: fluentd-elasticsearch
    spec:
      tolerations:
      # these tolerations are to have the daemonset runnable on control plane nodes
      # remove them if your control plane nodes should not run pods
      - key: node-role.kubernetes.io/control-plane
        operator: Exists
        effect: NoSchedule
      - key: node-role.kubernetes.io/master
        operator: Exists
        effect: NoSchedule
      containers:
      - name: fluentd-elasticsearch
        image: quay.io/fluentd_elasticsearch/fluentd:v2.5.2
        resources:
          limits:
            memory: 200Mi
          requests:
            cpu: 100m
            memory: 200Mi
        volumeMounts:
        - name: varlog
          mountPath: /var/log
      # it may be desirable to set a high priority class to ensure that a DaemonSet Pod
      # preempts running Pods
      # priorityClassName: important
      terminationGracePeriodSeconds: 30
      volumes:
      - name: varlog
        hostPath:
          path: /var/log
```

##### [Jobs](https://kubernetes.io/docs/concepts/workloads/controllers/job/)

Jobs represent one-off tasks that run to completion and then stop.

```bash
apiVersion: batch/v1
kind: Job
metadata:
  name: pi
spec:
  template:
    spec:
      containers:
      - name: pi
        image: perl:5.34.0
        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
      restartPolicy: Never
  backoffLimit: 4
```

##### [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)

A CronJob starts one-time Jobs on a repeating schedule.

```bash
apiVersion: batch/v1
kind: CronJob
metadata:
  name: hello
spec:
  schedule: "* * * * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: hello
            image: busybox:1.28
            imagePullPolicy: IfNotPresent
            command:
            - /bin/sh
            - -c
            - date; echo Hello from the Kubernetes cluster
          restartPolicy: OnFailure
```

**Writing a CronJob spec - Schedule syntax:**

```bash
# ┌───────────────────── minute (0 - 59)
# │ ┌─────────────────── hour (0 - 23)
# │ │ ┌───────────────── day of the month (1 - 31)
# │ │ │ ┌─────────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of the week (0 - 6) (Sunday to Saturday)
# │ │ │ │ │                                   OR sun, mon, tue, wed, thu, fri, sat
# │ │ │ │ │
# │ │ │ │ │
# * * * * *
```

##### [ReplicationController](https://kubernetes.io/docs/concepts/workloads/controllers/replicationcontroller/)

Legacy API for managing workloads that can scale horizontally. Superseded by the Deployment and ReplicaSet APIs.

```bash
apiVersion: v1
kind: ReplicationController
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    app: nginx
  template:
    metadata:
      name: nginx
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
```

#### [Autoscaling Workloads](https://kubernetes.io/docs/concepts/workloads/autoscaling/)

With autoscaling, you can automatically update your workloads in one way or another. This allows your cluster to react to changes in resource demand more elastically and efficiently.

**Scaling workloads manually**
Kubernetes supports manual scaling of workloads. Horizontal scaling can be done using the kubectl CLI. For vertical scaling, you need to patch the resource definition of your workload. See below for examples of both strategies.

- Horizontal scaling: Running multiple instances of your app
- Vertical scaling: Resizing CPU and memory resources assigned to containers

#### [Managing Workloads](https://kubernetes.io/docs/concepts/workloads/management/)

You've deployed your application and exposed it via a Service. Now what? Kubernetes provides a number of tools to help you manage your application deployment, including scaling and updating.

```bash
apiVersion: v1
kind: Service
metadata:
  name: my-nginx-svc
  labels:
    app: nginx
spec:
  type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: nginx
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx
  labels:
    app: nginx
spec:
  replicas: 3
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
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

#### [Services, Load Balancing, and Networking](https://kubernetes.io/docs/concepts/services-networking/)

**Services:** Expose an application running in your cluster behind a single outward-facing endpoint, even when the workload is split across multiple backends.

```bash
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app.kubernetes.io/name: MyApp
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9376
```

**Port definitions:**

Port definitions in Pods have names, and you can reference these names in the targetPort attribute of a Service.

```bash
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app.kubernetes.io/name: proxy
spec:
  containers:
  - name: nginx
    image: nginx:stable
    ports:
      - containerPort: 80
        name: http-web-svc

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app.kubernetes.io/name: proxy
  ports:
  - name: name-of-service-port
    protocol: TCP
    port: 80
    targetPort: http-web-svc
```

**Multi-port Services:**

Kubernetes lets you configure multiple port definitions on a Service object. When using multiple ports for a Service, you must give all of your ports names so that these are unambiguous. For example:

```bash
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app.kubernetes.io/name: MyApp
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 9376
    - name: https
      protocol: TCP
      port: 443
      targetPort: 9377
```

##### Service type

- [**ClusterIP**](https://kubernetes.io/docs/concepts/services-networking/service/#type-clusterip)
  - Exposes the Service on an internal cluster IP
  - Only reachable within the cluster
  - Default Service type
  - To expose it externally, use Ingress or a Gateway

- [**NodePort**](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport)
  - Exposes the Service on each Node’s IP at a static port
  - Also sets up a ClusterIP behind the scenes
  - Reachable via `<NodeIP>:NodePort`

- [**LoadBalancer**](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer)
  - Exposes the Service externally through an external load balancer
  - Kubernetes does not provide the load balancer directly
  - Works with cloud provider integrations

- [**ExternalName**](https://kubernetes.io/docs/concepts/services-networking/service/#externalname)
  - Maps the Service to an external DNS name using a CNAME
  - No proxying, just DNS redirection

##### [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)

Make your HTTP (or HTTPS) network service available using a protocol-aware configuration mechanism, that understands web concepts like URIs, hostnames, paths, and more. The Ingress concept lets you map traffic to different backends based on rules you define via the Kubernetes API.
![Ingress](/img/ingress.png)

``` YAML
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: minimal-ingress
    annotations:
      nginx.ingress.kubernetes.io/rewrite-target: /
  spec:
    ingressClassName: nginx-example
    rules:
    - http:
        paths:
        - path: /testpath
          pathType: Prefix
          backend:
            service:
              name: test
              port:
                number: 80
```

- If you are using `Minikube`

|  SL   | Command                                        | Explanation                    |
| :---: | :--------------------------------------------- | :----------------------------- |
|   1   | `minikube addons enable ingress`               | install controller in Minikube |
|   2   | `kubectl apply -f dashboard-ingress.yaml`      | ingress create                 |
|   3   | `minikube get ingress -n kubernetes-dashboard` | see details of ingress         |

##### Ingress Controllers

In order for an Ingress to work in your cluster, there must be an ingress controller running. You need to select at least one ingress controller and make sure it is set up in your cluster. This page lists common ingress controllers that you can deploy.

##### [Egress](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

Egress refers to the traffic that exits the Kubernetes cluster to external systems or networks.

```bash
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-external
spec:
  podSelector:
    matchLabels:
      role: frontend
  policyTypes:
  - Egress
  egress:
  - to:
    - ipBlock:
        cidr: 0.0.0.0/0
    ports:
    - protocol: TCP
      port: 80
```

Ingress vs Egress

|  SL   | Aspect        | Ingress                                                          | Egress                                                                                            |
| :---: | :------------ | :--------------------------------------------------------------- | :------------------------------------------------------------------------------------------------ |
|   1   | Definition    | Manages external access to services within the cluster           | Manages traffic exiting the cluster to external systems                                           |
|   2   | Focus         | Primary Use Routing incoming HTTP/HTTPS traffic to services      | Controlling and securing outbound traffic from the cluster                                        |
|   3   | Components    | Ingress Resource & Ingress Controller                            | Network Policies, Egress Gateways (in service mesh environments)                                  |
|   4   | Functionality | Load balancing, SSL/TLS termination & Name-based virtual hosting | Regulating access to external services, Enforcing security policies & Monitoring outbound traffic |
|   5   | Example       | NGINX Ingress Controller, HAProxy Ingress & Traefik              | Istio Egress Gateway                                                                              |

#### [Storage](https://kubernetes.io/docs/concepts/storage/)

[Volumes](https://kubernetes.io/docs/concepts/storage/)

It is a directory containing data, which can be accessed by containers in a Kubernetes pod. The location of the directory, the storage media that supports it, and its contents, depend on the specific type of volume being used. There are a few types of volumes in Kubernetes.

- Volumes
  - Persistent Volumes (PV)
    is a piece of storage in the cluster that has been provisioned by an administrator or dynamically provisioned using `Storage Classes`. It is a resource in the cluster just like a node is a cluster resource. PVs are volume plugins like Volumes, but have a lifecycle independent of any individual Pod that uses the PV.
  - Persistent Volume Claim (PVC)
    - It is a request for storage by a user.
    - It is similar to a Pod.
    - Pods consume node resources and
    - PVCs consume PV resources.
    Pods can request specific levels of resources (CPU and Memory). Claims can request specific `size` and `access` modes (They can be mounted to access mode)
      - ReadWriteOnce,
      - ReadOnlyMany,
      - ReadWriteMany, or
      - ReadWriteOncePod
  - Ephemeral Volumes
  - EmptyDir Volumes
  - hostPath Volumes
  - Volumes ConfigMap
- [Storing Volumes](https://kubernetes.io/docs/concepts/storage/storage-classes/)
  - NFS (Network File System)
  - CSI (Container Storage Interface)

**StorageClass**
A StorageClass in Kubernetes is a way to define different types of storage, or "classes," that a cluster administrator offers. It provides a way for cluster administrators to describe the "classes" of storage they offer and allows users to request different types of storage dynamically based on their performance and cost requirements.

**Features of StorageClass:**

- **Dynamic Provisioning:** A StorageClass enables dynamic provisioning of Persistent Volumes (PVs). When a user creates a Persistent Volume Claim (PVC) that references a StorageClass, Kubernetes automatically provisions a Persistent Volume that matches the desired storage properties defined in the StorageClass.
- **Abstracts Underlying Storage:** It abstracts the details of the underlying storage infrastructure (such as type, performance, availability zone, etc.). Users only need to specify the required class of storage (e.g., fast, slow, ssd) without needing to know the specifics of how it is implemented.
- **Supports Different Backends:** StorageClasses can be configured to support various storage backends such as AWS EBS, Google Cloud Persistent Disks, Azure Disks, NFS, Ceph, GlusterFS, and more. This flexibility allows Kubernetes to work with different types of storage solutions.
- **Customizable Parameters:** Each StorageClass can define a set of parameters that affect how the storage is provisioned. These parameters are specific to the storage backend and can include details such as disk type, IOPS, redundancy level, and more.
- **Reclaim Policy:** StorageClasses define a reclaim policy that dictates what happens to a dynamically provisioned Persistent Volume when it is released (e.g., deleted). The reclaim policy can be Retain (keep the storage intact), Delete (delete the storage), or Recycle (wipe and reuse the storage).

### [Configuration](https://kubernetes.io/docs/concepts/configuration/)

#### [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)

A ConfigMap is an API object used to store non-confidential data in key-value pairs. Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a volume.

- An API object that stores **non-confidential** key-value pairs
- Pods can use ConfigMaps as:
  - Environment variables
  - Command-line arguments
  - Configuration files mounted from volumes
- Helps **separate environment-specific configuration** from container images
- Makes applications easier to **deploy and port** across environments

#### [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)

A Secret is an object that contains a small amount of sensitive data such as a password, a token, or a key. Such information might otherwise be put in a Pod specification or in a container image.

- Kubernetes object for storing **sensitive data** (e.g., passwords, tokens, keys)
- Avoids putting confidential data directly in Pod specs or container images
- Created **separately** from Pods, reducing the risk of accidental exposure
- Kubernetes can handle Secrets more securely (e.g., avoid writing to disk)
- Similar to ConfigMaps, but intended for **confidential data**

#### Liveness, Readiness, and Startup Probes

In Kubernetes are checks performed by the kubelet to monitor the health and status of a container running inside a Pod.

**In simple words:**

- Probes periodically test if your container is healthy and ready.
- Based on probe results, Kubernetes can:
  - Restart a failing container (using liveness probes)
  - Stop sending traffic to a container until it is ready (using readiness probes)
  - Avoid killing slow-starting containers too early (using startup probes)

| **Probe Type**      | **Purpose**                                                              | **Behavior**                                                                                     |
| ------------------- | ------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------ |
| **Liveness probe**  | Detects when to restart a container (e.g., deadlocks, unresponsive apps) | - If probe fails repeatedly, kubelet restarts the container  <br> - Runs regardless of readiness |
| **Readiness probe** | Checks if container is ready to accept traffic                           | - If probe fails, pod is removed from service endpoints  <br> - Runs throughout container life   |
| **Startup probe**   | Checks if the application has successfully started                       | - Disables liveness & readiness checks until it succeeds  <br> - Runs only at startup            |

### [Security](https://kubernetes.io/docs/concepts/security/)

Securing a Kubernetes cluster is less about a single feature and more about layering controls across identity, network, workloads, and the control plane. Think of it as building “defense in depth” around the orchestration system of Kubernetes.

#### 1. Secure the Control Plane (most critical layer)

**Key actions:**

1. Enable API server authentication + authorization
   - Use strong certs
   - Avoid anonymous access
2. Enforce RBAC only (disable legacy ABAC if enabled)
3. Restrict access to API server endpoint:
   - Private cluster endpoint (VPC/internal only)
   - IP allowlisting for kubectl access
4. Enable audit logs:
   - Capture all API calls
   - Send logs to centralized system (ELK/CloudWatch/Loki)

#### 2. RBAC (Role-Based Access Control)

**Best practices:**

- Follow least privilege principle
- Avoid cluster-admin unless absolutely required
- Use namespace-scoped roles instead of cluster-wide roles

```bash
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: dev
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list"]
```

```bash
kind: RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
subjects:
- kind: User
  name: dev-user
roleRef:
  kind: Role
  name: pod-reader
```

#### 3. Network Security (Zero Trust inside cluster)

```bash
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

> By default, all pods can talk to all pods → unsafe. So, need explicitly allow traffic.
> Service mesh (Istio / Linkerd) for mTLS
> Separate namespaces per environment (dev/test/prod)

#### 4. Pod Security Standards

**Use:**

- Restricted (production)
- Baseline (general workloads)
- Privileged (avoid unless necessary)

```bash
apiVersion: v1
kind: Namespace
metadata:
  name: prod
  labels:
    pod-security.kubernetes.io/enforce: restricted
```

#### 5. Container Security

**Image best practices:**

- Use minimal base images (alpine/distroless)
- Scan images (Trivy / Grype)
- Sign images (cosign / Notary v2)

**Avoid:**

- Latest tag
- Running as root inside container

```bash
securityContext:
  runAsNonRoot: true
  readOnlyRootFilesystem: true
  allowPrivilegeEscalation: false
```

#### 6. Secrets Management

**Better options:**

1. Kubernetes Secrets (base64 only → weak alone)
2. External systems:
   - HashiCorp Vault
   - AWS Secrets Manager
   - Azure Key Vault

```bash
encryptionConfiguration:
  resources:
    - resources:
        - secrets
      providers:
        - aesgcm:
            keys:
              - name: key1
                secret: <base64-key>
```

#### 7. Node Security

1. Harden OS (CIS benchmark)
2. Disable SSH where possible
3. Regular patching
4. Restrict kubelet API access
5. Use separate node pools:
   - System nodes
   - Application nodes

#### 8. Logging & Monitoring

You must detect before you react.

- Audit logs (API server)
- Runtime monitoring:  Falco (detect suspicious behavior)
- Metrics: Prometheus + Grafana

- Alert on:
  - Privilege escalation
  - Unexpected exec into pods
  - Unusual API spikes

### [Policies](https://kubernetes.io/docs/concepts/policy/)

| Policy Type       | Controls                                          | Mental Model                          | Scope                                    | What it Prevents                                                                   | Real-World Analogy                               |
| ----------------- | ------------------------------------------------- | ------------------------------------- | ---------------------------------------- | ---------------------------------------------------------------------------------- | ------------------------------------------------ |
| **NetworkPolicy** | Pod-to-pod traffic, ingress/egress communication  | “Who can talk to whom”                | Network layer inside namespace / cluster | Unauthorized service access, lateral movement, open communication between all pods | Internal firewall between services in a building |
| **LimitRange**    | CPU, memory per container/pod (min, max, default) | “How much each container can consume” | Per container / per pod                  | Missing resource limits, overconsumption by a single pod, scheduling instability   | Safety limiter on each machine/equipment         |
| **ResourceQuota** | Total CPU, memory, pod count per namespace        | “Total budget of the namespace”       | Namespace-wide aggregate                 | Resource exhaustion, one team consuming all cluster capacity                       | Department budget limit in an organization       |

### [Scheduling, Preemption and Eviction](https://kubernetes.io/docs/concepts/scheduling-eviction/)

| Concept        | When it happens                                   | Who triggers it      | Purpose                                        | Result                             |
| -------------- | ------------------------------------------------- | -------------------- | ---------------------------------------------- | ---------------------------------- |
| **Scheduling** | When a pod is created                             | Kubernetes Scheduler | Find a suitable node for pod placement         | Pod assigned to a node             |
| **Preemption** | When high-priority pod cannot be scheduled        | Scheduler            | Free resources by removing lower-priority pods | Some pods are deleted to make room |
| **Eviction**   | When node is unhealthy or under resource pressure | Kubelet (node agent) | Protect node stability                         | Pods are removed from node         |

> Think of a cluster as:
>
> - Nodes = seats
> - Pods = passengers
> - Scheduler = seating manager
> - Preemption = kicking lower priority passengers
> - Eviction = forced removal due to problems

#### Kubernetes Component Version Compatibility

Kubernetes allows minor version skew between its components to make upgrades and rollbacks safer.
Typically, components can differ by `one minor version (±1)`, depending on their role.

| **Component**          | **Version Compatibility Rule**            | **If Control Plane = v1.12** | **Notes / Guidelines**                                  |
| ---------------------- | ----------------------------------------- | ---------------------------- | ------------------------------------------------------- |
| **kube-apiserver**     | `x` (acts as the version reference)       | v1.12                        | The API server defines the cluster’s version.           |
| **controller-manager** | `x - 1` (may be one minor version older)  | v1.11 or v1.12               | Must not be newer than API server.                      |
| **kube-scheduler**     | `x - 1` (may be one minor version older)  | v1.11 or v1.12               | Follows same rule as controller-manager.                |
| **kubelet**            | `x - 2` (may be up to two versions older) | v1.10 or v1.11               | Must not be newer than the API server.                  |
| **kube-proxy**         | `x - 2` (may be up to two versions older) | v1.10 or v1.11               | Follows same rule as kubelet.                           |
| **kubectl (CLI)**      | `x - 1 ≤ kubectl ≤ x + 1`                 | v1.11 to v1.13               | Can safely communicate with older or newer API servers. |

#### High Availability?

High Availability refers to designing a system so that applications and services remain operational even during component failures. It involves redundancy, failover, and load balancing to prevent a single point of failure (SPOF).

##### Core Concepts

- `Multiple Nodes/Instances:` Components (e.g., API servers, etcd, controllers) are distributed across multiple machines or zones.
- `Redundancy:` Backup components take over if one fails.
- `Failover Mechanisms:` Automatic switchover to a healthy node when a primary fails.
- `Resource Sufficiency:` Ensure there are always enough resources to handle load even after failures.

##### etcd Cluster and Quorum

In an etcd cluster, a `quorum (majority)` of nodes must agree for writes to succeed. The formula is `Quorum = N/2 + 1`. Where N is the total number of etcd nodes.

| Instance (`Node`) | Quorum (`Majority`) | Fault Tolerance (`C1-C2`) |
| :---------------: | :-----------------: | :-----------------------: |
|         1         |          1          |             0             |
|         2         |          2          |             0             |
|       **3**       |        **2**        |           **1**           |
|         4         |          3          |             1             |
|       **5**       |        **3**        |           **2**           |
|         6         |          4          |             2             |
|       **7**       |        **4**        |           **3**           |
|         8         |          5          |             3             |
|         9         |          5          |             4             |

> Where

- Odd number quorum (Min No. of Node) member is Recommended.
- Odd number of Instance/Node/Manager is Recommended.

> Etch Management

- Stacked Etcd
  ![Stacked Etcd](/img/high-availability/stacked-etch.png)
- External Etcd
  ![External Etcd](/img/high-availability/external-etcd.png)

### Environment Setup (Two ways one is Minikube, another KIND) - `Minikube Recommended`

#### [Minikube Install & Configuration](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fmacos%2Fx86-64%2Fstable%2Fbinary+download)

Minikube is a lightweight tool that lets you run a `real Kubernetes cluster` locally on your laptop or desktop for development, `testing`, and `learning` purposes.

**Key Points:**

- Runs locally on `macOS`, `Linux`, and `Windows`
- Supports `Docker`, `Hyperkit`, `KVM`, and `VirtualBox` drivers
- It creates a `single-node` or `multi-node Kubernetes` cluster using virtual machines or Docker containers
- Includes all `core Kubernetes` components
- Ideal for `developers`, `DevOps` engineers, and learners
- Supports add-ons like `Ingress`, `Dashboard`, and `Metrics Server`

##### Install & Configuration

###### Colima, Docker, Minikube & Kubernetes Cluster Install - Macbook or Linux

```bash
                 MacBook Pro M1
                    macOS
                      │
                   Colima
                 6 CPU / 7 GB
                      │
                   Docker
                      │
                ┌───────────┐
                │ Minikube  │
                │ Kubernetes│
                │ v1.37.0   │
                └─────┬─────┘
                      │
          ┌───────────┼───────────┐
          │           │           │
          ▼           ▼           ▼
      minikube    minikube-m02  minikube-m03
      CONTROL      WORKER-1      WORKER-2
       PLANE
       Ready        Ready         Ready
```

| Node           | Role          | Status  | Kubernetes | Runtime          |
| -------------- | ------------- | ------- | ---------- | ---------------- |
| `minikube`     | Control Plane | ✅ Ready | v1.37.0    | containerd 2.3.4 |
| `minikube-m02` | Worker        | ✅ Ready | v1.37.0    | containerd 2.3.4 |
| `minikube-m03` | Worker        | ✅ Ready | v1.37.0    | containerd 2.3.4 |

```bash
uname -m
system_profiler SPHardwareDataType | grep -E "Chip|Memory"
sw_vers
```

```bash
brew --version
brew --prefix
```

```bash
brew install colima
brew install docker
brew install kubectl
brew install minikube
```

```bash
colima version
docker --version
kubectl version --client
minikube version
```

```bash
colima start \
  --runtime docker \
  --cpu 6 \
  --memory 7 \
  --disk 60
```

```bash
colima status
docker info
```

```bash
minikube start \
  --driver=docker \
  --nodes=3 \
  --cpus=2 \
  --memory=1800mb \
  --disk-size=15g
```

###### Minikube Install

```bash
minikube start # for single node
minikube start --nodes 3 --driver=docker # or
minikube start --nodes 3 --driver=docker --cpus=2 --memory=3g
kubectl get nodes -o wide
```

- If something went wrong

```bash
minikube start --force --driver=docker
```

- Run dashboard

```bash
minikube dashboard
```

###### [KIND](https://kind.sigs.k8s.io/)

It's a tool for running local Kubernetes clusters using Docker container “nodes”. kind was primarily designed for testing Kubernetes itself, but may be used for local development or CI.

To install Kind in Ubuntu

```bash
sudo apt update
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
```

You can download and install Kind using the following command for ARM & AMD. In my case ARM.

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind version
```

Or, For latest version

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind version
```

You can create a new Kubernetes cluster with Kind using:

```bash
kind create cluster # Single node created
kind get clusters # Check clusters
kubectl cluster-info # cluster information
grep server ~/.kube/config # Getting server address
docker exec -it kind-control-plane bash # Access into the control plane
crictl ps # Checking running containers
exit # Go back in Ubuntu
```

Create another cluster

```bash
kind create cluster --name my-cluster
kind get clusters # Check clusters
grep server ~/.kube/config # Getting server address
less ~/.kube/config # Check config
kubectl get nodes --context kind-kind # Checking master/control node
kubectl get node # Checking worker node
kubectl get nodes --context kind-my-cluster # Checking worker node
kubectl config get-contexts # Multiple cluster in a config file
kubectl delete cluster # Delete cluster
kind delete cluster --name my-cluster # Delete name cluster
```

Multi-node clusters

```bash
nano /tmp/kind.yaml
```

```bash
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: control-plane
- role: control-plane
- role: worker
- role: worker
- role: worker
```

```bash
kind create cluster --config /tmp/kind.yaml
docker ps
grep server ~/.kube/config # Getting server address
kubectl get nodes
```

An additional node will be created and tagged to all other nodes.

```bash
docker exec -it kind-external-load-balancer sh
ls
cat /usr/local/etc/haproxy/haproxy.cfg
```

#### Comparison between Minikube & KIND

| Purpose / Use Case                    | Recommendation | Why                                                        |
| ------------------------------------- | -------------- | ---------------------------------------------------------- |
| Learning full Kubernetes features     | ✅ Minikube     | Full support for LoadBalancer, Ingress, Dashboard, Storage |
| CI/CD pipelines / Testing YAML files  | ✅ Kind         | Faster, headless, Docker-native                            |
| Fast and lightweight cluster          | ✅ Kind         | Uses Docker, no VM overhead                                |
| Realistic production-like environment | ✅ Minikube     | VM or container-based cluster with full kube features      |
| Running long-lived workloads locally  | ✅ Minikube     | Better volume persistence and add-on support               |

#### [Kubernetes Install & Configuration](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)

##### Enable `bash` completion & Setup `kubectl` autocompletion

```bash
sudo apt install bash-completion
echo "source /etc/bash_completion" >> ~/.bashrc # for bashrc
echo 'source <(kubectl completion bash)' >> ~/.bashrc # for bashrc
echo 'source <(kubectl completion zsh)' >> ~/.zshrc # for zshrc
source ~/.bashrc # for bashrc
source ~/.zshrc # for zshrc
```

##### Add your aliases to `.bashrc`

```bash
echo "alias k=kubectl" >> ~/.bashrc
echo "alias kg='kubectl get'" >> ~/.bashrc
echo "alias kgno='kubectl get node'" >> ~/.bashrc
echo "alias kgpo='kubectl get pod'" >> ~/.bashrc
```

##### Add your aliases to `.zshrc`

```bash
echo "alias k=kubectl" >> ~/.zshrc
echo "alias kg='kubectl get'" >> ~/.zshrc
echo "alias kgno='kubectl get node'" >> ~/.zshrc
echo "alias kgpo='kubectl get pod'" >> ~/.zshrc
```

**Basic Commands:**

|  SL   | Command                                                            | Explanation                            |
| :---: | :----------------------------------------------------------------- | :------------------------------------- |
|   1   | `kubectl -h`                                                       | show all command                       |
|   2   | `kubectl get node`                                                 | show enlisted node                     |
|   3   | `kubectl describe node`                                            | show description of node               |
|   4   | `kubectl top node NodeName`                                        | move a node to top                     |
|   5   | `kubectl get node -o wide`                                         | show enlisted node in details          |
|   6   | `kubectl get pod`                                                  | show enlisted pod                      |
|   7   | `kubectl describe pod podName`                                     | description of node                    |
|   8   | `kubectl get pod --show-labels`                                    | show the label of pod                  |
|   9   | `kubectl get pod -o yaml`                                          | show yaml of pod                       |
|  10   | `kubectl exec -it podName -- bin/bash`                             | debugging the pod                      |
|  11   | `kubectl logs podName`                                             | checking logs of a pod                 |
|  12   | `kubectl get deployment`                                           | show deployment list                   |
|  13   | `kubectl create deployment nginxDepltName --image=nginx`           | nginx install on kubernetes            |
|  14   | `kubectl create deployment my-nginx --image=nginx:latest`          | create nginx deployment                |
|  15   | `kubectl expose deployment my-nginx --port=80 --type=LoadBalancer` | run nginx deployment expose port       |
|  16   | `kubectl get services`                                             | show enlisted services                 |
|  17   | `minikube service my-nginx`                                        | run the nginx server                   |
|  18   | `kubectl exec -it podName -- bin/bash`                             | debugging the pod                      |
|  19   | `kubectl edit deployment nginxDepltName`                           | change deployment name (image version) |
|  20   | `kubectl delete deployment nginxDepltName`                         | remove deployment                      |
|  21   | `kubectl get deployment deplName -o yaml`                          | all info in output yaml file           |
|  22   | `kubectl get services`                                             | show enlisted services                 |
|  23   | `kubectl describe service serviceName`                             | show details of a service              |
|  24   | `kubectl apply -f config-file.yaml`                                | execute the conf file                  |
|  25   | `kubectl describe pod DepltName PIPESIGN grep -i image`            | which images is use in a pod           |
|  26   | `kubectl run DepltName --image=nginx --dry-run=client -o yaml`     | see the yaml template                  |

**DaemonSet:**

|  SL   | Command                                                      | Explanation            |
| :---: | :----------------------------------------------------------- | :--------------------- |
|   1   | `kubectl get node`                                           | check available node   |
|   2   | `kubectl pod --show-labels`                                  | check node's label     |
|   3   | `kubectl label pod podName env=labelName name=labelName`     | apply the label name   |
|   4   | `kubectl run web-app --image=nginx --dry-run=client -o yaml` | see in details in yaml |
|   5   | `vi web-app.yaml`                                            | see in details in yaml |
|   6   | `kubectl apply -f web-app.yaml`                              | apply new label        |
|   7   | `kubectl get pod --show-labels`                              | check node's label     |

**Replica set:**

|  SL   | Command                                                                                | Explanation                 |
| :---: | :------------------------------------------------------------------------------------- | :-------------------------- |
|   1   | `kubectl describe rs rsName`                                                           | describe rs                 |
|   2   | `kubectl ge rs rsName -o wide`                                                         | see details                 |
|   3   | `kubectl describe rs rsName PIPSIGN grep -i image`                                     | which images is use in a rs |
|   4   | `kubectl create deployment rsName --image=nginx --replicas=3 --dry-run=client -o yaml` | see the yaml template       |
|   5   | `kubectl get deployments.apps`                                                         | checking available app      |
|   6   | `kubectl describe deployments.apps AppName`                                            | details of available app    |
|   7   | `kubectl rollout undo deployment depltName`                                            | go back to pre version      |

**Static Pod(Without APIServer):**

|  SL   | Command                            | Explanation                |
| :---: | :--------------------------------- | :------------------------- |
|   1   | `kubectl get deployment.apps`      | check available deployment |
|   2   | `kubectl get pod`                  | check available pod        |
|   3   | `kubectl -n kube-system get pod`   | check system pod           |
|   4   | `vi static.yaml`                   | --                         |
|   5   | `kubectl apply -f static.yaml`     | apply                      |
|   6   | `kubectl get pod`                  | check pod                  |
|   7   | `kubectl delete pod static-master` | delete the pod             |

```bash
apiServer: v1
kind: Pod
metadata:
  name: static-master
  spec:
  containers:
  - image: busybox
    name: static
    command: ["sleep", "1000"]
```

#### First nginx deployment

|  SL   | Command                                  | Explanation                         |
| :---: | :--------------------------------------- | :---------------------------------- |
|   1   | `touch nginx-deployment.yaml`            | create yaml conf file on local pc   |
|   2   | `nano nginx-deployment.yaml`             | open in nano & write conf yaml code |
|   3   | `kubectl apply -f nginx-deployment.yaml` | deployment on the kubernetes        |
|   4   | `kubectl get deployment`                 | checking the deployment             |
|   5   | `kubectl exec -it podName -- bin/bash`   | accessing the pod                   |

**Namespace:**

|  SL   | Command                                | Explanation               |
| :---: | :------------------------------------- | :------------------------ |
|   1   | `kubectl get namespaces`               | Check enlisted namespaces |
|   2   | `kubectl cluster-info`                 | Check the cluster info    |
|   3   | `kubectl create namespace myNamespace` | Create namespace          |

## With Regards, `Jakir`

[![LinkedIn][linkedin-shield-jakir]][linkedin-url-jakir]
[![Facebook-Page][facebook-shield-jakir]][facebook-url-jakir]
[![Youtube][youtube-shield-jakir]][youtube-url-jakir]

### Wishing you a wonderful day! Keep in touch

<!-- Personal profile -->

[linkedin-shield-jakir]: https://img.shields.io/badge/linkedin-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white
[linkedin-url-jakir]: https://www.linkedin.com/in/jakir-ruet/
[facebook-shield-jakir]: https://img.shields.io/badge/Facebook-%231877F2.svg?style=for-the-badge&logo=Facebook&logoColor=white
[facebook-url-jakir]: https://www.facebook.com/jakir.ruet/
[youtube-shield-jakir]: https://img.shields.io/badge/YouTube-%23FF0000.svg?style=for-the-badge&logo=YouTube&logoColor=white
[youtube-url-jakir]: https://www.youtube.com/@mjakaria-ruet/featured
