## More About Me – [Take a Look!](http://www.mjakaria.me)

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

### [Components](https://kubernetes.io/docs/concepts/overview/components/)

A Kubernetes cluster consists of a `control plane` and `one/more worker nodes`. Here's a brief overview of the main components:

#### [Types of components](https://kubernetes.io/docs/concepts/overview/components/)

- Control Plane Components
  - [kube-apiserver](https://kubernetes.io/docs/concepts/architecture/#kube-apiserver)
  - [etcd](https://etcd.io) `It's may a separate project & different version`
  - [kube-scheduler](https://kubernetes.io/docs/concepts/architecture/#kube-scheduler)
  - [kube-controller-manager](https://kubernetes.io/docs/concepts/architecture/#kube-controller-manager)
    - node-controller
    - replication-controller
    - endpoint-controller
    - service-account-controller
  - cloud-controller-manager (Optional)
    - node-controller
    - route-controller
    - service-controller
- Worker Node Components
  - [kubelet](https://kubernetes.io/docs/concepts/architecture/#kubelet)
  - [kube-proxy](https://kubernetes.io/docs/concepts/architecture/#kube-proxy) (Optional)
  - [container runtime](https://kubernetes.io/docs/concepts/architecture/#container-runtime)
- Kubernetes
  - [DNS](https://kubernetes.io/docs/concepts/architecture/#dns)
  - [Web UI (Dashboard)](https://kubernetes.io/docs/concepts/architecture/#web-ui-dashboard)
  - [Container Resource Monitoring](https://kubernetes.io/docs/concepts/architecture/#container-resource-monitoring)
  - [Cluster-level Logging](https://kubernetes.io/docs/concepts/architecture/#cluster-level-logging)

#### [Objects](https://kubernetes.io/docs/concepts/overview/working-with-objects/)

Kubernetes objects are persistent entities in the Kubernetes system. Kubernetes uses these entities to represent the state of your cluster. Learn about the Kubernetes object model and how to work with these objects. Almost every  object includes **two** nested object fields that govern the object's configuration, first `spec` and second `status`.

#### Required fields in object

- **apiVersion**
- **kind**
- **metadata**
- **spec**

#### Sample object of `Deployment`

```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  selector:
    matchLabels:
      app: nginx
  replicas: 2 # tells deployment to run 2 pods matching the template
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

#### Server-side field validation (since Kubernetes v1.25)

- API server checks for unrecognized or duplicate fields in submitted objects
- Provides the same validation as kubectl --validate, but on the server side

- kubectl --validate options
  - strict (or true) → reject invalid fields with an error
  - warn → allow the request but show warnings for invalid fields
  - ignore (or false) → no field validation performed
- Defaults
  - kubectl --validate=true by default (strict mode)
- Fallback
  - If kubectl cannot reach an API server with field validation, it uses local (client-side) validation
  - Kubernetes 1.27+ always supports server-side field validation
  - For older clusters, check your Kubernetes version docs

#### Common Types of Objects

| **Object**                       | **Description**                                                                  |
| -------------------------------- | -------------------------------------------------------------------------------- |
| Pod                              | The smallest deployable unit; holds one or more containers                       |
| ReplicaSet                       | Ensures a specified number of identical Pods are running                         |
| Deployment                       | Manages ReplicaSets; supports easy updates/rollbacks of Pods                     |
| StatefulSet                      | Manages Pods with unique, stable identities (for stateful apps)                  |
| DaemonSet                        | Runs a copy of a Pod on every (or selected) node                                 |
| Job                              | Runs a one-time task until completion                                            |
| CronJob                          | Runs Jobs on a time-based schedule                                               |
| Service                          | Provides a stable network endpoint and load-balances traffic to Pods             |
| ConfigMap                        | Stores non-sensitive configuration data                                          |
| Secret                           | Stores sensitive data (passwords, tokens, certificates)                          |
| PersistentVolume (PV)            | Describes a piece of storage in the cluster                                      |
| PersistentVolumeClaim (PVC)      | Requests storage resources from a PV                                             |
| Namespace                        | Provides logical isolation for groups of resources                               |
| Ingress                          | Manages external HTTP/HTTPS access to Services                                   |
| Egress                           | Controls outbound network traffic (often paired with NetworkPolicy)              |
| NetworkPolicy                    | Controls network traffic rules between Pods                                      |
| ResourceQuota                    | Limits resource consumption in a namespace                                       |
| LimitRange                       | Sets default and maximum limits for resources in a namespace                     |
| HorizontalPodAutoscaler          | Automatically scales Pods based on metrics like CPU usage                        |
| PodDisruptionBudget              | Specifies how many Pods can be down during maintenance                           |
| Role / ClusterRole               | Define permissions within a namespace (Role) or across the cluster (ClusterRole) |
| RoleBinding / ClusterRoleBinding | Attach roles to users, groups, or service accounts                               |
| ServiceAccount                   | Provides an identity for Pods to interact with the Kubernetes API                |
| EndpointSlice                    | Stores network endpoint addresses of Services (more scalable than Endpoints)     |
| CustomResourceDefinition         | Lets you define your own API objects to extend Kubernetes                        |

#### [Object Management](https://kubernetes.io/docs/concepts/overview/working-with-objects/object-management/)

- Imperative Commands
- Declarative

### [Cluster](https://kubernetes.io/docs/concepts/architecture/)

It is made up of at least one master node and one or more worker nodes. The **master node makes up the control plane** of a cluster and is responsible for scheduling tasks and monitoring the state of the cluster.
![Cluster](/img/cluster.png)
CRI > Container Runtime Interface & CNI > Container Network Interface

#### [Nodes](https://kubernetes.io/docs/concepts/architecture/nodes/)

Kubernetes runs your workload by placing `containers into Pods to run on Nodes`. A node may be a virtual or physical machine, depending on the cluster. Each node is managed by the control plane and contains the services necessary to run Pods.There are **two** main ways to have Nodes added to the API server:

- The kubelet on a node self-registers to the control plane
- You (or another human user) manually add a Node object

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

##### Node Controller

- Part of the Kubernetes control plane
- Manages the lifecycle and health of nodes

**Main Roles:**

- Assigns a `CIDR` block to a node when it registers (if enabled)
- Syncs nodes with the cloud provider’s VM list and removes missing VMs
- Monitors node health:
  - Updates the `Ready` condition to `Unknown` if a node is unreachable
  - Evicts Pods on unreachable nodes after a `5-minute` default timeout
  - Checks node status every 5 seconds (can be changed with `--node-monitor-period`)

#### Communication between `Node` & `Control Plane`

##### [Node to Control Plane Communication](https://kubernetes.io/docs/concepts/architecture/control-plane-node-communication/)

- Where all node (and Pod) API calls go to the API server
- The API server listens on secure HTTPS (Port 443) with client `authentication` and `authorization`
- Nodes should have:
  - The cluster's root certificate
  - Valid client credentials (commonly client certificates, e.g., via kubelet TLS bootstrapping)
- Pods connect to the API server using a **service account** (Kubernetes injects certificates + bearer tokens automatically)
- The Kubernetes service (in `default` namespace) points to the API server via `kube-proxy`
- Control plane components also talk to the API server on the secure port
- Overall, node-to-control-plane traffic is secured and can run over public networks if needed

##### [Control Plane to Node Communication](https://kubernetes.io/docs/concepts/architecture/control-plane-node-communication/)

There are `two` primary communication paths from the control plane (the API server) to the nodes.

- The first is from the API server to the kubelet process which runs on each node in the cluster.
- The second is from the API server to any node, pod, or service through the API server's proxy functionality.

**API server to Kubelet** The connections `from the API server to the kubelet` are used for:

- Fetching logs for pods.
- Attaching (usually through kubectl) to running pods.
- Providing the kubelet's port-forwarding functionality.

These connections go to the kubelet’s HTTPS endpoint. By default, the API server does not verify the kubelet’s `certificate`, which can allow man-in-the-middle attacks on untrusted networks.

To secure it, use the `--kubelet-certificate-authority` flag so the API server can validate the kubelet’s certificate with a trusted root CA.

##### API server to nodes, pods, and services

- By default, the `API server` connects to `nodes`, `Pods`, or `Services` using `plain HTTP`
- These HTTP connections are not authenticated or encrypted
- You can use HTTPS by prefixing https: in the API URL
  - However, the API server does not verify the server’s certificate
  - No client credentials are provided
- So even if encrypted, the connection has no integrity guarantees
- These connections are not safe on untrusted or public networks

##### SSH Tunnels

- Kubernetes can use SSH tunnels to secure control-plane-to-node communication
- The API server opens an SSH tunnel to each node (on port 22)
- All traffic to the kubelet, node, Pod, or Service goes through this tunnel
- This keeps the traffic hidden from untrusted or external networks

#### [Self-Healing capabilities](https://kubernetes.io/docs/concepts/architecture/self-healing/)

- **Container-level restarts** If a container fails, Kubernetes restarts it based on the restartPolicy.
- **Replica replacement** If a Pod in a Deployment, StatefulSet, or DaemonSet fails, Kubernetes creates a replacement Pod to keep the desired replica count.
- **Persistent storage recovery** If a node running a Pod with a PersistentVolume fails, Kubernetes can reattach the volume to a new Pod on another node.
- **Load balancing for Services** If a Pod fails, Kubernetes removes it from the Service endpoints, routing traffic only to healthy Pods.

##### Couple of key components for Self-Healing

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

- **Deployment/ReplicaSet**
  - Good for stateless apps
  - Any Pod can be replaced interchangeably
- **StatefulSet**
  - For stateful apps needing stable identities
  - Can use PersistentVolumes and replicate data
- **DaemonSet**
  - Runs a Pod on every matching node
  - Useful for node-level tasks like networking plugins or monitoring
- **Job**
  - Runs a task once, until completion
- **CronJob**
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

##### ReplicaSet

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

##### StatefulSets

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

##### DaemonSet

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

##### Jobs

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

##### CronJob

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

##### ReplicationController

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

- **ClusterIP**
  - Exposes the Service on an internal cluster IP
  - Only reachable within the cluster
  - Default Service type
  - To expose it externally, use Ingress or a Gateway

- **NodePort**
  - Exposes the Service on each Node’s IP at a static port
  - Also sets up a ClusterIP behind the scenes
  - Reachable via `<NodeIP>:NodePort`

- **LoadBalancer**
  - Exposes the Service externally through an external load balancer
  - Kubernetes does not provide the load balancer directly
  - Works with cloud provider integrations

- **ExternalName**
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

### Configuration

### Security

### Policies

### Scheduling, Preemption and Eviction

### Cluster Administration

### Windows in Kubernetes

### Extending Kubernetes

**Kubernetes Component Version Compatibility:**

- kube-apiserver [`x > v1.12`]
- controller-manager [`x-1 > v1.11 or v1.12`]
- kube-scheduler [`x-1 > v1.11 or v1.12`]
- kubelet [`x-2 > v1.10 or v1.11`]
- kube-proxy [`x-2 > v1.10 or v1.11`]
- kubectl [`x-1, x+1 > v1.11, v1.13`]

[**KinD:**](https://kind.sigs.k8s.io/) kind is a tool for running local Kubernetes clusters using Docker container “nodes”.
kind was primarily designed for testing Kubernetes itself, but may be used for local development or CI.

To install Kind in Ubuntu

```bash
sudo apt update
sudo apt install -y docker.io
```

Start and enable Docker:

```bash
sudo systemctl start docker
sudo systemctl enable docker
```

You can download and install Kind using the following command for ARM & AMD. In my case ARM.

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

Or

```bash
curl -Lo ./kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

Verify the Installation

```bash
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

Interact with the Cluster

```bash
sudo snap install kubectl --classic
```

**Minikube:** is a tool that allows you to run a single-node Kubernetes cluster locally on your machine. It is designed to be a lightweight and easy-to-use solution for developers who want to develop, test, and experiment with Kubernetes applications without the need for a full-scale, multi-node cluster.

##### Install Minikube & kubectl (You may install as per your operating system.)

- Minikube [install](https://minikube.sigs.k8s.io/docs/start/) or Microk8s [install](https://microk8s.io) **Minikube Recommended**.

```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_arm64.deb
sudo dpkg -i minikube_latest_arm64.deb
```

```bash
  minikube start --force --driver=docker
```

Check the running/all container on docker

```bash
  docker ps / docker ps -a
```

```bash
  minikube dashboard
```

If it return "kubectl not found. If you need it, try: 'minikube kubectl -- get pods -A'", then

- You will Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) **Ubuntu Server Recommended**.

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

DaemonSet

|  SL   | Command                                                      | Explanation            |
| :---: | :----------------------------------------------------------- | :--------------------- |
|   1   | `kubectl get node`                                           | check available node   |
|   2   | `kubectl pod --show-labels`                                  | check node's label     |
|   3   | `kubectl label pod podName env=labelName name=labelName`     | apply the label name   |
|   4   | `kubectl run web-app --image=nginx --dry-run=client -o yaml` | see in details in yaml |
|   5   | `vi web-app.yaml`                                            | see in details in yaml |
|   6   | `kubectl apply -f web-app.yaml`                              | apply new label        |
|   7   | `kubectl get pod --show-labels`                              | check node's label     |

Replica set

|  SL   | Command                                                                                | Explanation                 |
| :---: | :------------------------------------------------------------------------------------- | :-------------------------- |
|   1   | `kubectl describe rs rsName`                                                           | describe rs                 |
|   2   | `kubectl ge rs rsName -o wide`                                                         | see details                 |
|   3   | `kubectl describe rs rsName PIPSIGN grep -i image`                                     | which images is use in a rs |
|   4   | `kubectl create deployment rsName --image=nginx --replicas=3 --dry-run=client -o yaml` | see the yaml template       |
|   5   | `kubectl get deployments.apps`                                                         | checking available app      |
|   6   | `kubectl describe deployments.apps AppName`                                            | details of available app    |
|   7   | `kubectl rollout undo deployment depltName`                                            | go back to pre version      |

Static Pod(Without APIServer)

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

##### Namespaces

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

##### Importance

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

|  SL   | Command                                | Explanation               |
| :---: | :------------------------------------- | :------------------------ |
|   1   | `kubectl get namespaces`               | Check enlisted namespaces |
|   2   | `kubectl cluster-info`                 | Check the cluster info    |
|   3   | `kubectl create namespace myNamespace` | Create namespace          |

**AWS CLI, KubeCtl & EksCtl Configuration:**

1. AWS CLI
   - Control multiple AWS services from this command line.
   - How to [Install?](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
   - Let's me check `aws --version`
   - If its okay then we will see `aws-cli/2.15.4 Python/3.11.6 Darwin/23.2.0 exe/x86_64 prompt/off`
   - Configuration using security credential
     - Go to AWS Management Console > Services > IAM
     - Select the IAM User Name: Your User Name [**NB**: You must use IAM's Information only not Root User]
     - Click on `Security credentials`
     - Click on `Create access key`
     - Copy Access ID & Secret access key
     - Go to your Terminal and implement as below format
     - `aws configure`
     - AWS Access Key ID [None]: Put your ID here and press Enter.
     - AWS Secret Access Key [None]: Put your secret key here and press Enter
     - Default region name [None]: us-east-1
     - Default output format [None]: json
     - Check the users `aws iam list-users`
   - Let's me check whether the configuration is done.
     - `aws ec2 describe-vpcs`
     - If it is done then we will see the details of the default vpc.

2. kubectl
   - Control the kubernetes clusters & objects.
   - How to [Install?](https://docs.aws.amazon.com/eks/latest/userguide/install-kubectl.html)
   - `mkdir kubectlbinary`
   - `cd kubectlbinary`
   - `curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.28.3/2023-11-14/bin/darwin/amd64/kubectl`
   - Assign the execute permissions `chmod +x ./kubectl`
   - Set the path by copying to user home directory `mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$HOME/bin:$PATH` & `echo 'export PATH=$HOME/bin:$PATH' >> ~/.bash_profile`

   - Let's me check whether the configuration is done. `kubectl version --client`
   - If it shows the following output then installation is done.
     - `Client Version: v1.28.2`
     - `Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3`

3. eksctl
   - creating-deleting clusters on AWS EKS.
   - create, autoscale & delete the node groups.
   - create fargate profiles.
   - it is powerfull tool for managing EKS clusters on AWS.
   - How to [Install?](https://docs.aws.amazon.com/emr/latest/EMR-on-EKS-DevelopmentGuide/setting-up-eksctl.html)
   - If you do not already have Homebrew installed on macOS, install it with the following command. `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`
   - Install the Weaveworks Homebrew tap. `brew tap weaveworks/tap` or `brew install weaveworks/tap/eksctl`
   - Test that your installation was successful with the following command. You must have eksctl 0.34.0 version or later. `eksctl version`
   - If it shows the following output then installation is done.
   - `0.167.0`

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
