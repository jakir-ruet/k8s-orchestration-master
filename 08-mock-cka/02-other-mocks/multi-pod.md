Create a `multi-pod` with two containers & add the command "sleep 3600" to container 2.
- Name container 1: micro, image: nginx
- Name container 2: mega, image: busybox

`Answer`
```bash
kubectl run mega --image=busybox --command sleep 3600 --dry-run=client -o yaml > multi-pod.yaml
nano multi-pod.yaml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
   creationTimestamp: null
   labels:
      run: mega
   name: multi-pod
spec:
   containers:
   - command:
      - sleep
      - "3600"
      image: busybox
      name: mega
      resource: {}
   - name: micro
     image: nginx
   dnsPolicy: ClusterFirst
   restartPolicy: Always
status: {}   
```
```bash
kubectl create -f multi-pod.yaml
kubectl get pods -o wide
```

Create a multi-pod with three containers:
- name container 1: container01, image: nginx
- name container 2: container02, image: redis
- name container 3: container03, image: alpine

`Answer`
```bash
kubectl run multi-pod --image=nginx --dry-run=client -o yaml > multi-pod.yaml
nano multi-pod.yaml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
   creationTimestamp: null
   labels:
      run: multi-pod
   name: multi-pod
spec:
   containers:
   - image: nginx
     name: container01
   - image: redis
     name: container02
   - image: alpine
     name: container03
   dnsPolicy: ClusterFirst
   restartPolicy: Always
status: {}
```
```bash
kubectl create -f multi-pod.yaml
kubectl get pods
```

Create a pod called `multi-pod` with two containers. 
- Container 1, name: alpha, image: nginx.
- Container 2, name: beta, image: busybox, command `sleep 4800`
Environment variables: container 1, name: alpha, container 2, name: beta
- Pod Name: multi-pod
- Container 1: alpha
- Container 2: beta
- Container beta commands set correctly?
- Container 1 environment value set
- Container 2 environment value set