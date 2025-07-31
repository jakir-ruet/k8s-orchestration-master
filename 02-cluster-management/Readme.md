#### Welcome to maintaining-clusters
- High Availability?
  A highly available configuration where multiple nodes work together to ensure that applications and services remain continuously operational even if parts of the system fail. This involves distributing components across multiple nodes and zones, using redundancy and failover mechanisms to prevent single points of failure, and ensuring that there are always enough resources to handle the workload.
- HA Control Plane
  - Multiple API Servers
  - etcd Cluster 
    - Odd number quorum (Min No. of Node) member [Recommended]
    - Find Quorum (`Majority`) by this Formula `Quorum = N/2 + 1`); Where, N is Node.
    - Table 
      | Instance (`Node`) | Quorum (`Majority`) | Fault Tolerance (`C1-C2`) |
      | :---------------: | :-----------------: | :-----------------------: |
      |         1         |          1          |             0             |
      |         2         |          2          |             0             |
      |       **3**       |          2          |             1             |
      |         4         |          3          |             1             |
      |       **5**       |          3          |             2             |
      |         6         |          4          |             2             |
      |       **7**       |          4          |             3             |
      |         8         |          5          |             3             |
      |         9         |          5          |             4             |
    - Instance/Node/Manager is Recommended (Odd).
  - Controller Manager &
  - Scheduler
- Etch Management
  - Stacked Etcd
    ![Stacked Etcd](/img/high-availability/stacked-etch.png)
  - External Etcd
    ![External Etcd](/img/high-availability/external-etcd.png)
- K8s Management Tools
  - Kubectl
    - Kubectl is oﬃcial CLI for K8s.
    - We will see using kubectl thought-out this course.
  - Kubeadm
    - Kubeadm tool is used to easily creating the K8s Cluster.
    - Helping user to set-up and make cluster functional.
  - Minikube (Kind & others)
    - K8s Developers tool
    - Local single node cluster
  - Helm
    - Powerful tool for K8s Template & Package Manager
    - Use for complex multi config template.
  - Kompose
    - Translate Docker Compose files into a K8s Objects
    - Ship containers from compose to K8s
  - Kustomize
    - Configuration management tool for K8s objects configuration
    - Similar to Helm and have ability to create re-useable templates for K8s.

#### Lets get started Drain/Remove Node From Cluster
- Node Draining
- How to Drain a Node
- Ignore DaemonSets
- Uncordoning a Node

#### Lets get started Upgrade the cluster
- Master node upgrade
  - Drain node
  - Upgrade plan
  - Apply upgrade
  - Upgrade kubectl & kubelet
  - Uncordon node & Join
- Worker node upgrade
  - Drain node
  - Upgrade kubeadm
  - Upgrade kubelet config
  - Upgrade kubectl & kubelet
  - Uncordon node
