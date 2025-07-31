#### Lets me check whether any pod available in cluster
In Kubernetes, "draining" a node refers to the process of safely evicting all the pods from a node in preparation for maintenance, decommissioning, or other administrative tasks. Draining ensures that the node can be taken out of service without disrupting the overall operation of the Kubernetes cluster.

```bash
kubectl get pods -o wide
# create 'my-draining-pod.yaml' for pod
kubectl apply -f my-draining-pod.yaml 
# create 'deployment.yaml'
kubectl apply -f deployment.yaml
kubectl get pods -o wide
kubectl drain worker1 # getting an error due to pod available
kubectl drain worker1 --ignore-daemonsets # got an error due to pod available
kubectl drain worker1 --ignore-daemonsets --force # got an error
kubectl get pods -o wide
kubectl uncordon worker1
kubectl get node
kubectl get pods -o wide
```
| Command                                                             | Purpose                           | Effect                                                         | Typical Use Cases                                        |
| ------------------------------------------------------------------- | --------------------------------- | -------------------------------------------------------------- | -------------------------------------------------------- |
| `kubectl cordon <node-name>`                                        | Mark a node as unschedulable      | Prevents new pods from being scheduled on the node             | Preparing for maintenance, testing without new workloads |
| `kubectl uncordon <node-name>`                                      | Mark a node as schedulable        | Allows new pods to be scheduled on the node                    | Re-enabling a node after maintenance, scaling up         |
| `kubectl drain <node-name> --ignore-daemonsets --delete-local-data` | Safely evict all pods from a node | Evicts all non-DaemonSet pods, respecting PodDisruptionBudgets | Node decommissioning, maintenance, troubleshooting       |

A DaemonSet in Kubernetes is a type of controller that ensures a copy of a pod is running on each node (or a subset of nodes) in a cluster. DaemonSets are typically used to deploy system-level services and other background tasks that need to run on all (or specific) nodes.