### Welcome to Demystifying Networking

#### Networking Model

Kubernetes is designed to facilitate the desired state management to host containerized workloads –these workloads take advantage of sharable compute resources. Kubernetes networking resolves the challenge of how to allow different Kubernetes components to communicate with each other and applications on Kubernetes to communicate with other applications, as well as the services outside of the Kubernetes cluster. Now, we are going to break them down one by one in this section.

- Container to Container
- Pod to Pod
- Pod to Service
- External to Service
- Node to Node

**Container to Container**
Container-to-container communication mainly refers to the communication between containers inside a pod – a multi-container pod is a good example of this. A multi-container pod is a pod that contains multiple containers and is seen as a single unit. Within a pod, every container shares the networking, which includes the IP address and network ports so that those containers can communicate with one another through localhost or standard **Inter Process Communications** (**IPC**) such as **SystemV semaphores** or **POSIX** shared memory. All listening ports are accessible to other containers in the pod even if they’re not exposed outside the pod. The following figure shows how those containers share a local network with each other inside the same pod:
![Multi-Container](/img/storage/multi-container.png)

**Pod to Pod**
In K8s, each pod has been given a **unique IP address** based on the **podCIDR** range of that worker node. Although this IP assignment is **not permanent**, as the pod eventually fails or restarts, the new pod will be assigned a **new IP address**. By default, pods can communicate with all pods on all nodes through pod networking without setting up **Network Address Translation** (**NAT**). This is also where we set up host networking. All pods can communicate with each other without NAT.

**Pod to Service**
Effective communication between pods and services entails letting the service expose an application running on a set of pods. The service accepts traffic from both inside and outside of the cluster. The set of pods can load - balance across them – each pod is assigned its own IP address and a single DNS.

**External to Service**
For effective communication between user to K8s this section is very vital. The challenge with external-to-service communication challenge is also resolved by the service. Service types such as a NodePort or a LoadBalancer can receive traffic from outside the Kubernetes cluster. Type of services

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
