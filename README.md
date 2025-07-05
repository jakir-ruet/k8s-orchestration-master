## More About Me – [Take a Look!](http://www.mjakaria.me)

### Kubernetes

Kubernetes is a portable, extensible, open source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. It has a large, rapidly growing ecosystem. Kubernetes services, support, and tools are widely available. It was originally developed by Google and is now maintained by the **Cloud Native Computing Foundation** (CNCF).

#### Salient Feature

- **Service discovery and load balancing**
  - Expose containers via DNS or IP.
  - Load balances traffic to keep deployments stable.
- **Storage orchestration**
  - Automatically mount local or cloud storage.
  - Such as local storages, public cloud providers.
- **Automated Rollouts and Rollbacks**
  - Manage container updates safely and gradually.
  - Automate replacing or adopting containers.
- **Automatic bin packing**
  - Efficiently place containers based on CPU/RAM needS.
  - It's can fit containers onto your nodes to make the best use of your resources.
- **Self-healing**
  - Restart, replace, or remove unhealthy containers automatically.
  - Doesn't advertise them to clients until they are ready to serve.
- **Secret and configuration management**
  - Securely store and manage secrets (passwords, tokens, etc.)
  - Update configs without rebuilding images
- **Batch execution**
  - Manage batch or CI jobs, restart failed containers
- **Horizontal scaling**
  - Scale apps up/down via commands, UI, or automatically.
- **IPv4/IPv6 dual-stack**
  - Supports allocating both IPv4 and IPv6 addresses
- **Designed for extensibility**
  - Easily add features without changing Kubernetes core

#### [Components](https://kubernetes.io/docs/concepts/overview/components/)

A Kubernetes cluster consists of a `control plane` and `one/more worker nodes`. Here's a brief overview of the main components:

##### [Types of components](https://kubernetes.io/docs/concepts/overview/components/)

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

##### Required fields in object

- **apiVersion**
- **kind**
- **metadata**
- **spec**

##### Sample object of `Deployment`

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

##### Server-side field validation (since Kubernetes v1.25)

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

##### Common Types of Objects

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

- Volume
- Service
- Ingress
- Egress
- Deployment (pod's blue print)
- StatefulSet
- ConfigMap
- Secret

It is made up of at least one master node and one or more worker nodes. The **_master node makes up the control plane_** of a cluster and is responsible for scheduling tasks and monitoring the state of the cluster.
![Cluster](/img/cluster.png)
CRI > Container Runtime Interface & CNI > Container Network Interface

**Version** Its Mandatory in same version

- kube-apiserver [`x > v1.12`]
- controller-manager [`x-1 > v1.11 or v1.12`]
- kube-scheduler [`x-1 > v1.11 or v1.12`]
- kubelet [`x-2 > v1.10 or v1.11`]
- kube-proxy [`x-2 > v1.10 or v1.11`]
- kubectl [`x-1, x+1 > v1.11, v1.13`]

##### [Services](https://kubernetes.io/docs/concepts/services-networking/service/)

It is a logical abstraction for a deployed group of pods in a cluster (which all perform the same function). if one is crash then another will ready to work. The core attributes of a Kubernetes service are:

- A label selector that locates pods
- The clusterIP IP address and assigned port number
- Port definitions
- Optional mapping of incoming ports to a targetPort

##### Types of Service

- _**ClusterIP:**_
Exposes a service which is only accessible from within the cluster. It is the default type of service, which is used to expose a service on an IP address internal to the cluster. Access is only permitted from within the cluster.

- _**NodePort**_
Exposes a service via a static port on each node’s IP.

- _**LoadBalancer**_
Exposes the service via the cloud provider’s load balancer like AWS or Azure.

- _**ExternalName**_
Maps a service to a predefined externalName field by returning a value for the CNAME record.

_**Sample Service**_

``` YAML
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

##### Pods (Containers)

Pods are the smallest deployable units of computing that you can create and manage in Kubernetes. A Pod (as in a pod of whales or pea pod) is a group of **_one or more containers_**, with shared **_storage_** and **_network resources_**, and a **_specification_** for how to run the containers. A Pod's contents are always co-located and co-scheduled, and run in a shared context.

``` YAML
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

##### Nodes (VM)

A node may be a virtual or physical machine, depending on the cluster. Each node is managed by the control plane and contains the services necessary to run Pods.

```JSON
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

A Kubernetes cluster is made up of one **_master_** node and several **_worker_** nodes. The worker nodes are responsible for running the containers and doing any work assigned to them by the master node. The master node looks after or manage the cluster.

- Master Node
  - **_kube-apiserver (cluster gateway) (some request > apiserver > validates request > others process > pod):_** It is entry-point to the Kubernetes cluster, which itself is a container. This is the process that allows communication between different Kubernetes clients and the cluster. We can run several instances of kube-apiserver and balance traffic between those instances. It is designed to scale horizontally—that is, it scales by deploying more instances. it is working as gatekeeper for authentication.
  - **_etcd (cluster brain):_** is a distributed key-value store that plays a critical role in the architecture of Kubernetes. Consistent and highly-available key value store used as Kubernetes' backing store for all cluster data. If your Kubernetes cluster uses etcd as its backing store, make sure you have a back up plan for the data. application data is not stored in etcd.
  - **_kube scheduler (schedule new pod > apiserver > scheduler > where put pod > kubelet):_** Scheduler ensures proper pod placement on the worker nodes based on several factors such as the available resources and the current load on the cluster.
  - **_kube controller manager (kcm > scheduler > kubelet > pod):_** Logically, each controller is a separate process, but to reduce complexity, they are all compiled into a single binary and run in a single process. its can detects cluster state changes. There are many different types of controllers some of them below;
    - **_Node controller:_** Responsible for noticing and responding when nodes go down.
    - **_Job controller:_** Watches for Job objects that represent one-off tasks, then creates Pods to run those tasks to completion.
    - **_EndpointSlice controller:_** Populates EndpointSlice objects (to provide a link between Services and Pods).
    - **_ServiceAccount controller:_** Create default ServiceAccounts for new namespaces.
  - **_cloud controller manager:_** lets you link your cluster into your cloud provider's API, and separates out the components that interact with that cloud platform from components that only interact with your cluster.The following controllers can have cloud provider dependencies:
    - **_Node controller:_** For checking the cloud provider to determine if a node has been deleted in the cloud after it stops responding
    - **_Route controller:_** For setting up routes in the underlying cloud infrastructure
    - **_Service controller:_** For creating, updating and deleting cloud provider load balancers

- Worker Node: here three process shown below;

  - **_kubelet:_** An agent that runs on each node in the cluster. It makes sure that containers are running in a Pod. The kubelet takes a set of PodSpecs that are provided through various mechanisms and ensures that the containers described in those PodSpecs are running and healthy. Its interacts with container & node.

  - **_kube proxy:_** kube-proxy is a network proxy that runs on each node in your cluster, implementing part of the Kubernetes Service concept. kube-proxy maintains network rules on nodes. These network rules allow network communication to your Pods from network sessions inside or outside of your cluster.

  - **_container runtime:_** A fundamental component that empowers Kubernetes to run containers effectively. It is responsible for managing the execution and lifecycle of containers within the Kubernetes environment.

_**kubectl (kube control):**_ is the command-line tool for interacting with Kubernetes clusters. It allows users to perform various operations on Kubernetes resources, such as creating and managing pods, services, deployments, and more.

[_**KinD:**_](https://kind.sigs.k8s.io/) kind is a tool for running local Kubernetes clusters using Docker container “nodes”.
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

_**Minikube:**_ is a tool that allows you to run a single-node Kubernetes cluster locally on your machine. It is designed to be a lightweight and easy-to-use solution for developers who want to develop, test, and experiment with Kubernetes applications without the need for a full-scale, multi-node cluster.

##### kubectl cli vs minikube cli?

| Feature                                   | **kubectl CLI**                                                                                 | **minikube CLI**                                                                                                          |
| ----------------------------------------- | ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| **Purpose**                               | The primary command-line tool for interacting with Kubernetes clusters.                         | A tool specifically for managing a local Kubernetes cluster created by Minikube.                                          |
| **Cluster Scope**                         | Can interact with any Kubernetes cluster, local or remote, as long as kubeconfig is configured. | Primarily used for managing local Kubernetes clusters created by Minikube.                                                |
| **Command Types**                         | Commands to interact with Kubernetes resources (pods, services, deployments, etc.).             | Commands to manage the Minikube environment (start, stop, status, etc.).                                                  |
| **Functionality**                         | Used for deployment, troubleshooting, and managing Kubernetes resources.                        | Used for creating, stopping, and configuring Minikube clusters.                                                           |
| **Cluster Context**                       | Works with any cluster configured in the kubeconfig file.                                       | Works only with the Minikube local cluster, though it can switch between multiple Minikube clusters.                      |
| **Common Commands**                       | `kubectl get`, `kubectl apply`, `kubectl delete`, `kubectl logs`, `kubectl describe`, etc.      | `minikube start`, `minikube stop`, `minikube status`, `minikube dashboard`, `minikube ssh`, etc.                          |
| **Configuration**                         | Configuration is typically managed through a `kubeconfig` file.                                 | Configuration is specific to Minikube and stored in Minikube's settings.                                                  |
| **Cluster Creation**                      | Does not create clusters, only manages existing ones.                                           | Manages the creation of local Kubernetes clusters using VirtualBox, Docker, etc.                                          |
| **Integration with Kubernetes Resources** | Fully integrated with all Kubernetes resources for cluster management.                          | Provides limited integration as it's focused on managing the local Minikube instance.                                     |
| **Cluster Management**                    | Requires a cluster to be already set up (can interact with local or cloud-based clusters).      | Fully manages local Kubernetes clusters, including starting, stopping, and inspecting the state of the Minikube cluster.  |
| **Use Case**                              | For users interacting with any Kubernetes cluster (local, cloud, on-premise).                   | For users working with local Minikube clusters for development or testing.                                                |
| **Interaction with Docker**               | Interacts with Kubernetes' Docker (or container runtime) for container management.              | Minikube CLI interacts with Docker (if Minikube is set to use Docker) to manage containers in the local Minikube cluster. |

##### Install Minikube & kubectl (You may install as per your operating system.)

- Minikube [install](https://minikube.sigs.k8s.io/docs/start/) or Microk8s [install](https://microk8s.io) _**Minikube Recommended**_.

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

- You will Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/) _**Ubuntu Server Recommended**_.

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

##### See (2-yaml-file-parts) for yaml understanding. Recommended to read docs of [kubernetes](https://kubernetes.io/docs/home/)

##### See (3-complete-deployment) for complete deployment. Recommended to read docs of [kubernetes](https://kubernetes.io/docs/home/)

#### [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/#:~:text=The%20Ingress%20concept%20lets%20you,define%20via%20the%20Kubernetes%20API.&text=An%20API%20object%20that%20manages,and%20name%2Dbased%20virtual%20hosting.)

Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the Ingress resource. Here is a simple example where an Ingress sends all its traffic to one Service:
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

#### [Egress](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

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

##### [Pods](https://kubernetes.io/docs/concepts/workloads/pods/)

Pods are the smallest deployable units of computing that you can create and manage in Kubernetes. [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)

##### [Containers](https://kubernetes.io/docs/concepts/containers/)

Each container that you run is repeatable; the standardization from having dependencies included means that you get the same behavior wherever you run it.

##### [Volumes](https://kubernetes.io/docs/concepts/storage/)

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

**Features of StorageClass**

- **Dynamic Provisioning:** A StorageClass enables dynamic provisioning of Persistent Volumes (PVs). When a user creates a Persistent Volume Claim (PVC) that references a StorageClass, Kubernetes automatically provisions a Persistent Volume that matches the desired storage properties defined in the StorageClass.
- **Abstracts Underlying Storage:** It abstracts the details of the underlying storage infrastructure (such as type, performance, availability zone, etc.). Users only need to specify the required class of storage (e.g., fast, slow, ssd) without needing to know the specifics of how it is implemented.
- **Supports Different Backends:** StorageClasses can be configured to support various storage backends such as AWS EBS, Google Cloud Persistent Disks, Azure Disks, NFS, Ceph, GlusterFS, and more. This flexibility allows Kubernetes to work with different types of storage solutions.
- **Customizable Parameters:** Each StorageClass can define a set of parameters that affect how the storage is provisioned. These parameters are specific to the storage backend and can include details such as disk type, IOPS, redundancy level, and more.
- **Reclaim Policy:** StorageClasses define a reclaim policy that dictates what happens to a dynamically provisioned Persistent Volume when it is released (e.g., deleted). The reclaim policy can be Retain (keep the storage intact), Delete (delete the storage), or Recycle (wipe and reuse the storage).

##### [ConfigMaps](https://kubernetes.io/docs/concepts/configuration/configmap/)

A ConfigMap is an API object used to store non-confidential data in key-value pairs. Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a volume.

#### [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)

It is a workload API object used to manage stateful applications. Unlike a `Deployment`, which is used for stateless applications, a StatefulSet provides unique network identities and stable, persistent storage for each of its pods. A StatefulSet runs a group of Pods, and maintains a sticky identity for each of those Pods. This is useful for managing applications that need persistent storage or a stable, unique network identity.

**Using StatefulSets**
StatefulSets are valuable for applications that require one or more of the following.

- Stable, unique network identifiers.
- Stable, persistent storage.
- Ordered, graceful deployment and scaling.
- Ordered, automated rolling updates.

StatefulSet Example

```yaml
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
````

##### [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/)

A Secret is an object that contains a small amount of sensitive data such as a password, a token, or a key. Such information might otherwise be put in a Pod specification or in a container image. Using a Secret means that you don't need to include confidential data in your application code.

1. AWS CLI
   - Control multiple AWS services from this command line.
   - How to [Install?](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
   - Let's me check `aws --version`
   - If its okay then we will see `aws-cli/2.15.4 Python/3.11.6 Darwin/23.2.0 exe/x86_64 prompt/off`
   - Configuration using security credential
     - Go to AWS Management Console > Services > IAM
     - Select the IAM User Name: Your User Name [_**NB**_: You must use IAM's Information only not Root User]
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
