### Services & Ingress

Let's create a complete, step-by-step Kubernetes Service and Ingress guide with examples, covering everything from Pods to external access. I’ll make it structured, practical, and ready to follow.

- Creating a Deployment (Pods)
- ClusterIP Service (Internal Access)
- NodePort Service (External Access)
- LoadBalancer Service (Cloud)
- Service DNS and Cross-Namespace Access
- Ingress and Ingress Controller (Advanced Routing)

#### Services

A Service in Kubernetes is an abstraction that exposes a set of Pods as a network application. It provides a stable endpoint (IP/DNS) for clients, decoupling them from the dynamic Pod IPs.

- Its used to access the pods from outer world
- Its abstract layer between pods & client
- Its provides a way to expose application as a set of pods.

![Service](/img/service.png)

##### Service types

1. ClusterIP (Default)
2. NodePort
3. LoadBalancer
4. ExternalName

###### ClusterIP (Default)

- `Purpose:` Exposes the Service on an internal IP in the cluster.
- `Accessibility:` Only reachable within the cluster.

```bash
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: ClusterIP
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 8080
```

> Use case: Communication between internal microservices, backend services, or APIs not exposed to the internet.

###### NodePort

- `Purpose:` Exposes the Service on the same port of each Node in the cluster.
- `Accessibility:` Can be accessed externally using <NodeIP>:<NodePort>.
- `Use case:` Quick access to a service from outside the cluster without an Ingress or LoadBalancer.
- `Range:` NodePort is usually between `30000–32767`.

```bash
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: NodePort
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 30007
```

###### LoadBalancer

- `Purpose:` Exposes the Service externally using a cloud provider’s load balancer.
- `Accessibility:` Publicly accessible over the internet.
- `Use case:` Production-level exposure of services to the internet, often used with cloud providers like AWS, GCP, or Azure.

```bash
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 8080
```

> Note: Requires a cloud environment that supports load balancers.

###### ExternalName

- `Purpose:` Maps the Service to a DNS name outside the cluster.
- `Accessibility:` Acts as a DNS alias for external services.
- `Use case:` When you want to access an external database, API, or service as if it were part of your cluster.

```bash
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  type: ExternalName
  externalName: example.com
  ports:
    - port: 80
```

###### Comparison Table

| Service Type | Cluster Internal? | External Access?      | Typical Use Case                         |
| ------------ | ----------------- | --------------------- | ---------------------------------------- |
| ClusterIP    | Yes               | No                    | Internal service communication           |
| NodePort     | Yes               | Limited (NodeIP:Port) | Expose a service externally for dev/test |
| LoadBalancer | Yes               | Yes                   | Production-level public service          |
| ExternalName | Yes               | Indirect via DNS      | Reference external services via DNS      |

#### Ingress

Ingress is a Kubernetes resource that manages external access to services inside your cluster. It’s primarily used for `HTTP` and `HTTPS` traffic, but it does more than just exposing services like `NodePort` or `LoadBalancer`.

> Key Features:

- Routes external requests to internal services based on hostnames and paths.
- Supports SSL/TLS termination (so you can handle HTTPS traffic directly at the Ingress level).
- Provides load balancing for services.
- Supports name-based virtual hosting, allowing multiple domains to share a single IP.

##### Capabilities vs NodePort/LoadBalancer

| Feature                    | NodePort / LoadBalancer | Ingress                   |
| -------------------------- | ----------------------- | ------------------------- |
| HTTP Routing               | Limited                 | Path & Host-based routing |
| SSL/TLS Termination        | N/A                     | Yes                       |
| Name-based Virtual Hosting | N/A                     | Yes                       |
| Load Balancing             | N/A                     | N/A                       |
| External Access            | N/A                     | N/A                       |

##### [Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)

An Ingress resource does not work on its own—it needs an Ingress Controller, which is a pod (or set of pods) that watches for Ingress resources and implements the routing rules.

> Key Points:

- Multiple types available (NGINX, Traefik, HAProxy, Istio, etc.).
- You can run multiple controllers in a cluster.
- Ingress defines routing rules: each rule has paths pointing to a backend service.
- Supports Named Ports, so the backend service’s port can be referenced by name.

##### Service Routing

- When a client makes a request to a Service, Kubernetes routes traffic to the Pods associated with that Service in a load-balanced manner.
- This allows the client to interact with a stable endpoint (Service), even though Pods may be dynamic.

##### Endpoints

- Each Service has associated endpoints, which represent the backend Pods to which the Service routes traffic.
- Each Pod that matches the Service’s selector automatically becomes an endpoint.

```bash
kubectl get endpoints <serviceName>
```

> Endpoints update automatically as Pods are added or removed.

#### Egress

Egress refers to outbound traffic from Pods inside a Kubernetes cluster to the external world (the internet or external services). While Ingress manages traffic coming into the cluster, Egress manages traffic going out of the cluster.

> Key Points

1. Outbound Traffic Control

- By default, Pods can reach any external endpoint.
- Egress policies let you restrict which external IPs or domains a Pod or namespace can access.

2. Use Cases

- `Security:` Prevent Pods from contacting unauthorized external services.
- `Compliance:` Only allow outbound traffic to certain endpoints.
- `Network optimization:` Control or log external connections.

3. Egress Resources

- Kubernetes itself doesn’t have a built-in Egress object like Ingress.
- Instead, Network Policies or Egress Gateways (e.g., via service mesh like Istio) are used to implement Egress rules.

```bash
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-specified-egress
  namespace: default
spec:
  podSelector:
    matchLabels:
      role: backend
  policyTypes:
  - Egress
  egress:
  - to:
    - ipBlock:
        cidr: 203.0.113.0/24
    ports:
    - protocol: TCP
      port: 443
```

#### Egress vs Ingress

| Aspect            | Ingress                       | Egress                        |
| ----------------- | ----------------------------- | ----------------------------- |
| Traffic Direction | External → Cluster            | Cluster → External            |
| Control Method    | Ingress resource + controller | Network Policies / Gateways   |
| Purpose           | Routing, SSL, virtual hosting | Security, compliance, logging |
