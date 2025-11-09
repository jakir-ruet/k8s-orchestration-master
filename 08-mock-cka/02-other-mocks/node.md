List the InternalIP of all nodes of cluster. Save the result to a file `/root/node_ips`. Answer should be in the format: `InternalIP of node01`<space>`InternalIP of node02`<space>`InternalIP of node03` (in a single line).
- Task completed

`Answer`
```bash
kubectl get nodes -o jsonpath='{.item[*].status.addresses[?(@.type=="ExternalIP")].address}'
kubectl get nodes -o jsonpath='{.item[*].status.addresses[?(@.type=="InternalIP")].address}'
kubectl get nodes -o jsonpath='{.item[*].status.addresses[?(@.type=="InternalIP")].address}' > /root/node_ips
kubectl get nodes -o jsonpath='{.item[*].status.addresses[].address}'
cat /root/node_ips
```

List all the internal IP's of all the nodes in the cluster and save it to `/doc/ip_nodes.txt`.

`Answer`
```bash
kubectl get nodes -o jsonpath='{.item[*].status.addresses[?(@.type=="InternalIP")].address}' > /doc/ip_nodes.txt
cat /doc/ip_nodes.txt
```

Use JSON path to get all the node names and store them in the file `/doc/node-names.txt`.

`Answer`
```bash
kubectl get nodes -o jsonpath='{.items[*].metadata.name}' > /doc/node-names.txt
cat /doc/node-names.txt
```

Check how many nodes are in ready state and write it to the file `/doc/ready-nodes.txt`.

`Answer`
```bash
kubectl get nodes
kubectl describe nodes | grep ready | wc -l # check ready state
kubectl describe nodes | grep ready | wc -l > /doc/ready-nodes.txt
cat /doc/ready-nodes.txt
```

Create a pod and set the environment variable `dev=dev10`.
- pod name: grey
- image: nginx

`Answer`
```bash
kubectl run grey --image=nginx --restart=Never --env-dev=dev10
kubectl exec -it grey -- sh -c 'echo $dev'
kubectl describe pod grey | grep dev
```

The node `node01` is in `NotReady` state. Investigate and bring the node back to ready state.

`Answer`
```bash
kubectl get nodes
kubectl describe node node01 # shaw NodeNotReady
ssh node01
sudo su or sudo -i
systemctl status kubelet # shaw inactive (dead)
systemctl start kubelet
systemctl enable kubelet
systemctl status kubelet # shaw active
```

Make the node `node01` unavailable and reschedule all the pods on it.

`Answer`
```bash
kubectl get pods -o wide # check pod
kubectl get nodes
kubectl cordon node01
kubectl drain node01 --ignore=daemonsets --force
kubectl get pods -o wide
kubectl get nodes
```

There's an issue with the node `node01`. The administrator is not able to schedule any pod on the node. Fix the issue and deploy `my-pod.yaml` on the node.

`Answer`
```bash
kubectl get node node01 -o wide 
kubectl describe node node01 # NodeNotSchedulable
kubectl uncordon node01
kubectl get node node01 -o wide
cat my-pod.yaml # for checking nodeName
kubectl create -f my-pod.yaml
kubectl get pod my-pod -o wide
```