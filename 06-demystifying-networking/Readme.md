### Welcome to Demystifying Networking

#### Networking Model

Cluster Networking is the system that allows `Pods`, `Nodes`, `Services`, and `external clients` to communicate inside a Kubernetes cluster.

- Core Goals of Cluster Networking
  - Every Pod has a unique IP address
  - Pods can communicate with each other across Nodes
  - Services provide stable IPs to reach dynamic Pods
  - No NAT is required for Pod-to-Pod communication

##### Networking Models

1. Pod-to-Pod Communication
   - Pods can communicate across nodes using their IPs.
   - CNI plugin sets up this connectivity.
   - No NAT involved.
2. Service-to-Pod Communication
   - A Service gets a ClusterIP (e.g., 10.96.0.1).
   - Traffic to this IP is routed to backend Pods.
   - kube-proxy handles the routing (via iptables/IPVS).
3. Node-to-Pod Communication
   - Nodes (e.g., kubelet, monitoring agents) talk to Pods using Pod IPs.
   - This works because of the flat network model (Pods visible from all nodes).
4. External-to-Cluster Communication - Exposed via:
   - NodePort (nodeIP:port)
   - LoadBalancer (via cloud)
   - Ingress (layer 7 routing)

##### What Enables Kubernetes Cluster Networking — Combined View

| Communication Type   | Enabled By                           | Description                                                       |
| -------------------- | ------------------------------------ | ----------------------------------------------------------------- |
| Pod → Pod            | ✅ CNI Plugin (e.g., Calico, Flannel) | Ensures all Pods can reach each other across nodes with real IPs  |
| Pod → Service        | ✅ kube-proxy + iptables/IPVS         | Forwards traffic from ClusterIP to backend Pods                   |
| Pod → External World | ✅ NAT via node or egress gateway     | Lets Pods reach the internet                                      |
| Node → Pod           | ✅ CNI routing                        | Nodes can talk to any Pod via Pod IP                              |
| External → Cluster   | ✅ NodePort / LoadBalancer / Ingress  | Enables access to services from outside the cluster               |
| Service Discovery    | ✅ CoreDNS                            | Resolves service names to ClusterIP addresses                     |
| Traffic Routing      | ✅ kube-proxy + iptables              | Handles traffic rules for services and endpoints                  |
| Traffic Restriction  | ✅ NetworkPolicy + CNI                | Controls which Pods can talk to each other (requires CNI support) |


##### Type of services

- ClusterIP
  A default service type for Kubernetes. For internal communications, exposing the service makes it reachable within the cluster.

- NodePort
  For both internal and external communication. `NodePort exposes` the service on a static port on each worker node – meanwhile, a ClusterIP is created for it, and it is used for internal communication, requesting the IP address of the node with an open port – for example, `nodeIP:port` for external communication.

- LoadBalancer
  This works for cloud providers, as it’s backed by their respective load balancer offerings. Underneath `LoadBalancer`, `ClusterIP` and `NodePort` are created, which are used for internal and external communication.

- ExternalName
  Maps the service to the contents with a CNAME record with its value. It allows external traffic access through it.

**Node to Node**
Within a cluster, each node is registered by the `kubelet` agent to the master node, and each node is assigned a node IP address so they can communicate with each other.

**Container Network Interface plugin**
We talked about how to use the Calico plugin as the overlay network for our Kubernetes cluster. We can enable the Container Network Interface (CNI) for pod-to-pod communication. The CNI plugins conform to the CNI specification. Once the CNI is set up on the Kubernetes cluster, it will allocate the IP address per pod.

**Ingress controllers and Ingress resources**
One of the challenges of Kubernetes networking is about managing internal traffic, which is also known as east-west traffic, and external traffic, which is known as north-south traffic. There are a few different ways of getting external traffic into a Kubernetes cluster. When it comes to Layer 7 networking, Ingress exposes HTTP and HTTPS at Layer 7 routes from outside the cluster to the services within the cluster.

**How Ingress and an Ingress controller works**
Ingress acts as a router to route traffic to services via an Ingress-managed load balancer – then, the service distributes the traffic to different pods. From that point of view, the same IP address can be used to expose multiple services. However, our application can become more complex, especially when we need to redirect the traffic to its subdomain or even a wild domain. Ingress is here to address these challenges. Ingress works with an Ingress controller to evaluate the defined traffic rules and then determine how the traffic is being routed. The process works as shown in below;
![Ingress work procedure](/img/network/ingress.png)

**Configuring and leveraging CoreDNS**
As mentioned earlier in this chapter, nodes, pods, and services are assigned their own IP addresses in the Kubernetes cluster. Kubernetes runs a Domain Name System (DNS) server implementation that maps the name of the service to its IP address via DNS records. So, you can reach out to the services with a consistent DNS name instead of using its IP address. This comes in very handy in the context of microservices. All microservices running in the current Kubernetes cluster can reference the service name to communicate with each other. The DNS server mainly supports the following three types of DNS records, which are also the most common ones:

- A or AAAA records for forward lookups that map a DNS name to an IP address. A record maps a DNS name to an IPv4 address, whereas an AAAA record allows mapping a DNS name to an IPv6 address.
- SRV records for port lookups so that connections are established between a service and a hostname.
- PTR records for reversing IP address lookups, which is the opposite function of A and AAAA records. It matches IP addresses to a DNS name. For example, a PTR record for an IP address of `172.0. 0.10` would be stored under the `10.0. 0.172.in-addr.arpa` DNS zone.
