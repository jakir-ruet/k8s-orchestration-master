
Resource scheduling in Kubernetes involves allocating resources such as CPU and memory to containers and ensuring that Pods are optimally placed on nodes within a cluster. Kubernetes uses a scheduler to determine which node an unscheduled Pod should run on based on resource requests, constraints, and policies.

Ways of resources allocation or scheduling

- Node Selector
- Node Affinity & Anti-Affinity
- Taints & Tolerations
- Resource Requests and Limits
- [Priority Classes](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#priorityclass)

**Node Selector** allows you to assign  pods to specific node that have specific labels & its working in key-value pairs. For example `disktype:ssd` or `env=production` etc. Limitations

- Static Scheduling
- Lack of Affinity/Anti-Affinity Rules

**Node Affinity & Anti-Affinity** A more expressive and flexible way to control pod scheduling based on node labels. Node affinity supports `requiredDuringSchedulingIgnoredDuringExecution` (similar to nodeSelector) and `preferredDuringSchedulingIgnoredDuringExecution` (soft rules or preferences).

**Taints & Tolerations**: Taints and Tolerations are concepts in Kubernetes that help control the scheduling of pods to nodes, ensuring that certain workloads run on specific nodes or are prevented from running on unsuitable ones.

- **Taints** are markers applied to nodes that repel certain pods from being scheduled on them.
- **Tolerations** are properties applied to pods that allow them to be scheduled on nodes with specific taints.

Scheduling Process

- Filtering
- Scoring
- Binding

For fulfilling this section we need a master node & at least two nodes.

Pod schedule to specified node using `node-selector`

```bash
kubectl get pod
kubectl get pod -o wide
kubectl get nodes --show-labels
kubectl label nodes nodeName assignLabel # assign expected label to node
kubectl label nodes workerone-plane disktype=ssd
kubectl get pod
kubectl get pod -o wide
```

**DaemonSet:**
A DaemonSet in Kubernetes is a controller that ensures a copy of a specified pod runs on all (or some) nodes in the cluster. It is particularly useful for deploying system-level services and background tasks that need to run on every node.

- When a new node is added to the cluster, the DaemonSet automatically deploys the pod on the new node.
- When a node is removed from the cluster, the pod managed by the DaemonSet is also removed.
- Updating the DaemonSet template triggers a rolling update across all nodes where the DaemonSet is deployed.
- Supports the ability to perform rolling updates to update pods incrementally.

**Use Cases**

- ***System Monitoring:*** Deploying monitoring agents like `Prometheus` Node Exporter or DataDog agents to gather metrics from every node.
- ***Log Collection:*** Running logging agents like `Fluentd` or Logstash on each node to collect and forward logs.
- ***Networking:*** Managing network plugins like `Calico` or Weave Net that need to run on every node for consistent network policy enforcement.
- ***Security:*** Deploying security agents like `Falco` to monitor and enforce security policies across the cluster.

**Static**: A static pod in Kubernetes is a pod that is directly managed by the `kubelet` (the node agent) on a specific node, rather than by the Kubernetes API server. Static pods are primarily used for `bootstrapping`, `running essential components`, or when you need to ensure that certain pods are always running on a particular node, even if the Kubernetes control plane is not fully functional.

**Characteristics**

- Managed by Kubelet
- No Replication Controller
- Persistent on Node
- No API Object
- Manual Management:

**Use Cases**

- Bootstrapping Control Plane Components
- Running Critical Node Services
- Disaster Recovery

**CronJob:**
CronJob is used to run jobs on a schedule. A CronJob creates Jobs on a repeating schedule.

```yaml
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

Explain

```yaml
# ┌───────────── minute (0 - 59)
# │ ┌───────────── hour (0 - 23)
# │ │ ┌───────────── day of the month (1 - 31)
# │ │ │ ┌───────────── month (1 - 12)
# │ │ │ │ ┌───────────── day of the week (0 - 6) (Sunday to Saturday)
# │ │ │ │ │                                   OR sun, mon, tue, wed, thu, fri, sat
# │ │ │ │ │
# │ │ │ │ │
# * * * * *
```
