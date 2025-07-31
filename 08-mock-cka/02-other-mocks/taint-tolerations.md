Taint a node to be unschedulable and test it by creating a pod on the node.
- Taint: key: env_type, value: production, operator: NoSchedule
- Pod 1: name: no-redis, image: redis:alpine
- Pod 2 with tolerations: name: pro-redis, image: redis-alpine

`Answer`
```bash
kubectl get nodes
kubectl taint node node02 env_type=production:NoSchedule
kubectl describe node node02 | grep -i taint
kubectl run no-redis --image=redis:alpine
kubectl describe pod no-redis
kubectl run pro-redis --image=redis:alpine --dry-run=client -o yaml > redis.yaml
nano redis.yaml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
   creationTimestamp: null
   labels:
      run: pro-redis
   name: pro-redis
spec:
   containers:
   - image: redis:alpine
     name: pro-redis
     resources: {}
   dnsPolicy: ClusterFirst
   restartPolicy: Always
   tolerations: # add only this section in this pod as toleration
   - key: env_type
     effect: NoSchedule
     operator: Equal
     value: production
status: {}
```
```bash
kubectl create -f redis.yaml
kubectl describe pod pro-redis
```

Remove the taint added to the node `node01`

`Answer`
```bash
kubectl get nodes
kubectl describe node node01 | grep Taint
# Taints:         app=production:NoSchedule 
kubectl taint nodes node01 key=production:NoSchedule # untainted
kubectl describe nodes node01 | grep Taint
```

Schedule a pod on the node `node01` by using tolerations
- pod name: my-pod
- image: nginx

`Answer`
```bash
kubectl describe node node01 | grep Taint
# Taints:         app=front:NoSchedule
kubectl run my-pod --image=nginx --dry-run=client yaml > my-pod.yaml
```

```yaml
apiVersion: v1
kind: Pod
metadata:
   creationTimestamp: null
   labels:
      run: my-pod
   name: my-pod
spec:
   containers:
   - image: nginx
     name: my-pod
     resources: {}
   dnsPolicy: ClusterFirst
   restartPolicy: Always
   tolerations:
   - effect: NoSchedule
     key: app
     operator: Equal
     value: front
```
```bash
kubectl create -f my-pod.yaml
kubectl get pod my-pod -o wide
```

Create a pod and set tolerations.
- pod name: my-pod
- image: nginx
- tolerations: spray=red:NoSchedule

`Answer`
```bash
kubectl describe node node01 | grep Taints
kubectl run my-pod --image=nginx --dry-run=client -o yaml > my-pod.yaml
nano my-pod.yaml
```
Add toleration 
```yaml
tolerations:
- effect: NoSchedule
  key: spray
  operator: Equal
  value: red
```
```bash
kubectl create -f my-pod.yaml
kubectl describe pod my-pod | grep Node:
```

Taint a node to be un-schedulable and test it by creating a pod on the node

`Answer`
```bash
kubectl get nodes -o wide
ps -aux | grep kubelet
kubectl get nodes
minikube ssh
sudo su or sudo -i
cd /etc/kubernetes/manifests/
vi my-static-pod.yaml # write pod spec
systemctl restart kubelet
kubectl get node
```