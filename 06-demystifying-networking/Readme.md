### Cluster Networking

Cluster Networking is the system that allows `Pods`, `Nodes`, `Services`, and `external clients` to communicate inside a Kubernetes cluster.

- Core Goals of Cluster Networking
  - Every Pod has a unique IP address
  - Pods can communicate with each other across Nodes
  - Services provide stable IPs to reach dynamic Pods
  - No NAT is required for Pod-to-Pod communication

#### Networking Models

1. Container-to-Container Networking in a Pod
   - Pod network namespace
     - Each Pod gets its own network namespace.
     - Containers inside the Pod share the same IP address and network stack.
   - Communication via localhost
     - Since all containers share the same network namespace, they can communicate over localhost and the respective port exposed by the target container.
     - No external routing or bridge is needed inside the Pod.
   - Isolation from outside
     - Containers without exposed ports (like your container2) cannot be accessed from outside the Pod, only from within the Pod.
     - Containers with exposed ports (like container1) can be accessed from other Pods using the Pod IP or via a Service.
2. Pod-to-Pod Communication
   - Every Pod gets a unique IP from the node’s Pod CIDR.
   - This IP allows direct communication between Pods, whether they’re on the same node or different nodes.
   - CNI plugin sets up this connectivity.
   - No NAT involved.
   - Each Pod has its own network namespace.
   - Each Pod is connected to the node via a veth pair (`veth0` (Pod1) <-> virtual bridge <-> `veth1` (Pod2))
   - The bridge handles Layer 2 networking, using `ARP` to forward traffic to the correct Pod IP.
   - Communication process (Pod1 eth0 → veth0 → virtual bridge → veth1 → Pod2 eth0)

![Container-to-Container & Pod-to-Pod](/img/network/concon-podpod.jpg)

3. Pod-to-Service Communication
   - A Service gets a ClusterIP (e.g., 10.96.0.1).
   - Traffic to this IP is routed to backend Pods.
   - kube-proxy handles the routing (via iptables/IPVS - `(IP Virtual Server)`).

![Pod-to-Service](/img/network/pod-service.jpg)

> The Problem: Pods Are Dynamic

- Pods can `scale up/down` or be `recreated` due to crashes or node failures.
- Each Pod may get a `new IP address` after recreation.
- Directly connecting to Pod IPs is unreliable.

> Kubernetes Service: Responsibilities. A Service solves this problem by providing:

- Static Virtual IP (ClusterIP)
  - A single stable IP that clients connect to instead of individual Pod IPs.
- Load Balancing
  - Distributes traffic to the backend Pods that match the Service’s selector.
  - Traffic is routed to available Pods, even if some fail or are recreated.
- Pod IP Tracking
  - The Service keeps track of which Pods are backing it.
  - Changes in Pod IPs are transparent to clients; they only interact with the Service IP.

4. External-to-Cluster Communication - Exposed via:
   - NodePort (nodeIP:port)
   - LoadBalancer (via cloud)
   - Ingress (layer 7 routing)

![Internet-to-Service](/img/network/internet-service.jpg)

#### Egress Traffic (Outward Flow)

Egress is when traffic originates from inside the cluster (for example, a Pod) and goes out to the Internet or external services.

> How it works:

- Pods typically don’t have routable IPs on the public internet.
- When a Pod sends traffic outside the cluster, iptables on the node performs Source Network Address Translation (SNAT).
- The packet’s source IP is changed from the Pod’s IP to the Node’s IP.
- To the external world, the request looks like it’s coming from the node, not the Pod.
- The return traffic comes back to the node, which then routes it back to the original Pod.

> Why it matters:

- This provides security and address translation so that internal Pod IPs remain hidden.
- You can use Egress gateways (in service meshes like Istio) or NetworkPolicies to control or restrict outbound traffic.

#### Ingress Traffic (Inbound Flow)

Ingress is when traffic originates outside the cluster (for example, from users or clients on the internet) and enters the cluster to reach a Service or Pod. Two main ingress solutions:

##### Service LoadBalancer (Layer 4/TCP–UDP)

- Works at the network layer (L4).
- You define a Service of type LoadBalancer.
- Your cloud provider provisions an external load balancer (e.g., AWS ELB, GCP Load Balancer, Azure LB).
- The load balancer forwards traffic to the NodePorts on cluster nodes.
- Inside the cluster, kube-proxy then routes the traffic to the right backend Pod.

```bash
apiVersion: v1
kind: Service
metadata:
  name: my-app
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 8080
```

> This exposes your app externally via a cloud load balancer.

##### Ingress Controller (Layer 7 / HTTP–HTTPS)

- Works at the application layer (L7).
- Provides routing based on HTTP hostnames, paths, or headers.
- Instead of exposing each Service individually, you define Ingress resources with rules that forward traffic to internal Services.
- Requires an `Ingress Controller`, such as:
  - NGINX Ingress Controller
  - HAProxy
  - Traefik
  - Istio Gateway

```bash
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-ingress
spec:
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app
            port:
              number: 80
```

> This routes external HTTP traffic for `myapp.example.com` to the my-app Service inside the cluster.

#### In-Cluster Load Balancing

Kubernetes uses kube-proxy for implementing Service networking. There are `two` modes:

1. [IPTables](https://kubernetes.io/docs/concepts/services-networking/service/#proxy-mode-iptables) Mode
   - Kube-proxy watches for Service and Pod changes in the API server.
   - Installs iptables rules that redirect traffic from Service IP to backend Pods.
   - Traffic handling occurs in kernel space via Linux Netfilter.
   - Backend Pods are selected randomly.
   - Pros: Reliable, low system overhead.

2. [IPVS (IP Virtual Server)](https://kubernetes.io/blog/2018/07/09/ipvs-based-in-cluster-load-balancing-deep-dive/) Mode
   - IPVS (IP Virtual Server) uses Netfilter hooks at the transport layer.
   - Uses a hash table for fast routing in kernel space.
   - Provides lower latency, higher throughput, and better performance than iptables.
   - Ideal for large-scale clusters.

#### Traffic Flow (Pod → Service → Pod)

- Client Pod sends traffic to the Service IP.
- Traffic goes through the virtual bridge in the node’s network.
- Since ARP on the bridge doesn’t understand the Service, the packet is routed via the default gateway (eth0).
- kube-proxy rules (iptables or IPVS) redirect traffic to one of the backend Pods.
- Traffic can cross nodes if necessary.

#### What Enables Kubernetes Cluster Networking — Combined View

| Communication Type   | Enabled By                         | Description                                                       |
| -------------------- | ---------------------------------- | ----------------------------------------------------------------- |
| Pod → Pod            | CNI Plugin (e.g., Calico, Flannel) | Ensures all Pods can reach each other across nodes with real IPs  |
| Pod → Service        | kube-proxy + iptables/IPVS         | Forwards traffic from ClusterIP to backend Pods                   |
| Pod → External World | NAT via node or egress gateway     | Lets Pods reach the internet                                      |
| Node → Pod           | CNI routing                        | Nodes can talk to any Pod via Pod IP                              |
| External → Cluster   | NodePort / LoadBalancer / Ingress  | Enables access to services from outside the cluster               |
| Service Discovery    | CoreDNS                            | Resolves service names to ClusterIP addresses                     |
| Traffic Routing      | kube-proxy + iptables              | Handles traffic rules for services and endpoints                  |
| Traffic Restriction  | NetworkPolicy + CNI                | Controls which Pods can talk to each other (requires CNI support) |

#### Container Network Interface (CNI)

The CNI is a standard defined by the Container Networking Interface specification
 that Kubernetes uses to manage networking between pods. It ensures every pod gets its own IP and can communicate with other pods (pod-to-pod communication).

##### Plugins

Kubernetes itself doesn’t implement networking; instead, it relies on third-party plugins such as:

- `Calico:` Offers both overlay and non-overlay modes, with network policies for security.
- `Flannel:` Simple overlay network using VXLAN.
- `Cilium:` eBPF-based networking with advanced observability and security features.

When a new pod is created, the kubelet calls the configured `CNI` plugin to:

- Create a network interface for the pod.
- Assign an IP address to the pod.
- Set up routing rules so the pod can reach other pods and services.

#### CoreDNS in Kubernetes

CoreDNS is the default DNS server in modern Kubernetes clusters, replacing the older kube-dns.

- It provides service discovery — letting pods find and communicate with each other by service names rather than IPs.
- A Service named `backend` in namespace dev can be reached at `backend.dev.svc.cluster.local`.
- CoreDNS automatically updates DNS records as services or pods are created or destroyed.

Key Record Types:

| Record Type  | Description                                                                |
| ------------ | -------------------------------------------------------------------------- |
| **A / AAAA** | Map DNS name → IPv4/IPv6 address.                                          |
| **SRV**      | Map a service name to its hostname and port. Useful for service discovery. |
| **PTR**      | Reverse lookup: map IP address → DNS name.                                 |
