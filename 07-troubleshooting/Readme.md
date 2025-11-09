### Welcome to K8s Troubleshooting

**Monitoring on a cluster node**
Monitoring is essential for Kubernetes administrators when it comes to getting a clear understanding of what’s going on in your Kubernetes cluster. You need to know all of the different metrics to help you get on track in terms of the health of your Kubernetes cluster components. You also need to make sure that your components are operating as expected and that all workloads that are deployed on your worker nodes are functional and have enough resources, such as CPU, memory, and storage.Moreover, you should also check whether any worker nodes are available and have sufficient resources to scale or schedule more workloads.
In Kubernetes, Metrics Server collects CPU/memory metrics and to some extent adjusts the resources needed by containers automatically. Metrics Server collects those metrics every 15 seconds from the kubelet agent and then exposes them in the API server of the Kubernetes master via the Metrics API. This process is described in the following figure:
![Metric server working process](/img/troubleshoot/metric-server.png)
Users can use the `kubectl top` command to access metrics collected by Metrics Server. At the time of writing this chapter, Metrics Server supports scaling up to 5,000 Kubernetes worker nodes, which is the maximum number of nodes that Kubernetes currently supports (Kubernetes v1.24 supports clusters with up to 5,000 nodes).

**Metrics Server**

```bash
kubectl get nodes
kubectl top node minikube # or
kubectl get pods -n kube-system | grep metrics-server
```

**Installing Metrics Server**
If you’re on a vanilla Kubernetes cluster, you can install Metrics Server by deploying a YAML definition or through Helm charts; the latter will require Helm to be installed. [Metrics Server Download](https://github.com/kubernetes-sigs/metrics-server)

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/high-availability.yaml # If you’re on a cluster with at least two nodes
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm upgrade --install metrics-server metrics-server/metrics-server
```

**Using minikube add-ons**
If you’re using a minikube cluster, Metrics Server comes in the form of a built-in add-on that can be enabled and disabled via the minikube addons command. You can use the following to list the currently supported add-ons:

```bash
minikube addons list
minikube addons list | grep metrics-server
minikube addons enable metrics-server
kubectl get pod,svc -n kube-system # or
kubectl get pods -n kube-system | grep metrics-server
kubectl top node minikube # check out CPU/Memory metric
```

**Monitoring the resource usage of an application**

```bash
kubectl top pod nginx # here nginx is pod name
kubectl top pod nginx --containers
kubectl top pod --all-namespaces # orr
kubectl top pod -A
```

**Using the sort flag**

```bash
kubectl top pod --sort-by=cpu
kubectl top pod –-sort-by=memory
kubectl top pod -A --sort-by=memory
```

**Monitoring cluster events**

```bash
kubectl get events
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl get events --watch
```

**Managing logs at the cluster node and Pod levels**
Logs are very handy when it comes to troubleshooting issues. The information collected in a log is usually helpful in understanding what has happened, figuring out why certain issues happened, and finding remediations to prevent them from happening again later on.

**Cluster-level logging**
In Kubernetes, the notion of cluster-level logging is widely recognized. This means logs are meant to be stored in a separate backend, so the lifecycles of those logs are independent of what’s been logged down to the **worker node**, **pod**, or even **container** level.
Kubernetes itself does not provide a comprehensive native logging framework, but it can be integrated with lots of third-party open source logging solutions in the community, such as **Grafana Loki** or the **EFK stack**, which includes **Elasticsearch**, **Fluentd**, and **Kibana** for log searching, querying, and tracing.

[Logging in Kubernetes](https://kubernetes.io/docs/concepts/cluster-administration/logging/) involves a set of patterns that are implemented by the community with different open source solutions. There are the following three patterns:

- Using a node-level logging agent that runs on every node:
  The agent is often in a DaemonSet so it will be evenly distributed on each node, and this agent pushes the logs to a backend. In this case, there are no code changes for the application.
- Using a dedicated sidecar container to log information from the application in the same Pod:
  This case can be in conjunction with a logging agent running on the node or streaming the logs out, and it is usually recommended to write log entries with the same formats to the same log stream for convenient processing.
- Directly streaming the logs from the application to an external backend:
  This can work with external object storage, as such storage supports lifecycle policies, which allows the setup of data retention policies and the archiving of old logs based on the policy. Most object storage also

**Managing container stdout and stderr logs**
In the Unix and Linux OSs, there are three I/O streams, called STDIN, STDOUT, and STDERR. Here, we’ll talk about STDOUT and STERR in Linux containers, which are typically what the kubectl logs command shows to us.

```bash
kubectl logs nginx
kubectl logs logger
kubectl logs logger - conName
kubectl logs -f logger # f means follow the logs
kubectl logs --since=1h # log check as per use time
```

Node Status

```bash
systemctl status kubelet
systemctl start kubelet
systemctl enable kubelet
```
