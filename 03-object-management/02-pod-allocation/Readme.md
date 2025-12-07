### Resource scheduling

Resource scheduling in Kubernetes involves allocating resources such as `CPU` and `memory` to containers and ensuring that Pods are optimally placed on nodes within a cluster. Kubernetes uses a scheduler to determine which node an unscheduled Pod should run on based on resource requests, constraints, and policies.

#### Ways of resources allocation or scheduling

- Node Selector
- Node Affinity & Anti-Affinity
- Taints & Tolerations
- Resource Requests and Limits
- [Priority Classes](https://kubernetes.io/docs/concepts/scheduling-eviction/pod-priority-preemption/#priorityclass)

#### Node Selector

Assigns Pods to nodes with specific labels (key-value pairs), like `disktype:ssd` or `env=production`.

> Limitations

- Static scheduling only
- No support for soft preferences or anti-affinity rules

```bash
kubectl label nodes worker-node-1 disktype=ssd
kubectl get pods -o wide
```

#### Node Affinity & Anti-Affinity

More flexible and expressive than NodeSelector. Controls Pod placement based on node labels with hard or soft rules.

##### Types of Node Affinity

1. `requiredDuringSchedulingIgnoredDuringExecution`
   - Hard requirement.
   - Pod will not schedule unless the rule is satisfied.

2. `preferredDuringSchedulingIgnoredDuringExecution`
   - Soft preference.
   - Scheduler tries to place the Pod according to the rule but can override if needed.

##### Affinity vs Anti-Affinity

- `Affinity:` Prefer or require Pods on nodes with specific labels.
- `Anti-Affinity:` Prefer or require Pods not to be scheduled on nodes with specific labels.

#### Taints & Tolerations

- `Taints:` Applied to nodes to repel Pods.
- `Tolerations:` Applied to Pods to allow them on tainted nodes.
- Ensures that Pods only schedule on suitable nodes.

#### Scheduling Process

- `Filtering:` Remove nodes that cannot satisfy Pod constraints.
- `Scoring:` Rank remaining nodes based on preferences.
- `Binding:` Assign Pod to the best-scored node.

#### Resource Requests and Limits

- Define how much CPU and memory a Pod requests and the maximum it can use.
- Helps the scheduler make placement decisions and prevents resource contention.

### DaemonSet

A DaemonSet ensures a copy of a Pod runs on all or selected nodes in a cluster, ideal for system-level services and background tasks.

> Key Features:

- Automatically deploys Pods to new nodes and removes them from deleted nodes.
- Supports rolling updates across all nodes.
- Incrementally updates Pods when the template changes.

> Use Cases:

- `System Monitoring:` Prometheus Node Exporter, DataDog agents
- `Log Collection:` Fluentd, Logstash
- `Networking:` Calico, Weave Net
- `Security:` Falco agents

### Static pod

A Static Pod is managed directly by the kubelet on a specific node, not the API server.

> Characteristics:

- Managed by Kubelet
- No replication controller
- Persistent on node
- No API object
- Requires manual management

> Use Cases:

- Bootstrapping control plane components
- Running critical node services
- Disaster recovery

### CronJob

CronJob is used to run jobs on a schedule. A CronJob creates Jobs on a repeating schedule. Cron Syntax Explanation:

* * * * *
│ │ │ │ │
│ │ │ │ └─ Day of week (0-6 or sun-sat)
│ │ │ └── Month (1-12)
│ │ └─── Day of month (1-31)
│ └──── Hour (0-23)
└───── Minute (0-59)

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
