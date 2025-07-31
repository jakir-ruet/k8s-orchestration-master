Create a pod called `mango-pod` with image: redis with CPU request set to 1 CPU and memory request as 200MiB.

`Answer`
```yaml
apiVersion: v1
kind: pod
metadata:
   creationTimestamp: null
   labels:
      run: mango-pod
   name: mango-pod
spec:
   containers:
      image: redis
      name: mango-pod
      resources:
         requests:
            cpu: 1
            memory: 200MiB
   dnsPolicy: ClusterFirst
   restartPolicy: Always
status: {}
```
```bash
kubectl create -f mango-pod.yaml
kubectl describe pod mango-pod
kubectl get pod
```

Create a new pod called `super-user-pod` with image busybox: 1.28. Allow the pod to be able to set system_time. The container should sleep for 4800 seconds.
- Pod: super-user-pod
- Container Image: busybox: 1.28
- SYS_TIME capabilities for the container?

`Answer`
```yaml
apiVersion: v1
kind: pod
metadata:
   creationTimestamp: null
   name: super-user-pod
spec:
   containers:
      image: busybox: 1.28
      name: super-user-pod
      command: ["sleep", "4800"]
      securityContext:
        capabilities:
          add: ["SYS_TIME"]
```
```bash
kubectl create -f super-user-pod.yaml
kubectl describe pod super-user-pod
kubectl get pod
```

A pod definition file is created as `/root/use-pv.yaml`. Make use of this manifest file and mount the persistent volume called `pv-1`. Ensure the pod is running and the PV is bound. Where moundPath: /data persistentVolumeClaim Name: my-pvc.
- persistentVolume Claim configured correctly
- pod using the correct mountPath
- pod using the persistent volume claim?

`Answer`
```bash
kubectl get pv
```
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
   name: my-pvc
spec:
   accessModes: 
      - ReadWriteOnce
   resources:
      requests:
         storage: 10Gi
```
```bash
kubectl create -f pvc.yaml
kubectl get pv
```
```yaml
apiVersion: v1
kind: Pod
metadata:
   creationTimestamp: null
   labels:
      run: use-pv
   name: use-pv
spec:
   containers:
   - image: nginx
     name: use-pv
     volumeMounts:
     - mountPath: "/data"
       name: my-pod
     volumes:
     - name: my-pod
       persistentVolumeClaim:
         claimName: my-pvc  
```
```bash
kubectl create -f use-pv.yaml
kubectl describe pod use-pv
```

Create a new deployment called nginx-deploy, with image nginx: 1.26 and 1 replica. Record the version next upgrade the deployment to version 1.27 using rolling update. Make sure that the version upgrade is recorded in the resource annotation.
- Deployment: nginx-deploy, image: nginx: 1.26.
- Image: nginx: 1.26.
- Task Upgrade the version of the deployment to 1.27.
- Task: Record the changes for the image upgrade.

`Answer`
```bash
kubectl run nginx-deploy --image=nginx:1.26 --replicas=1 --record
kubectl get deployment
kubectl rollout history deployment nginx-deploy
kubectl set image deployment/nginx-deploy nginx-deploy=nginx:1.27 --record
kubectl get deployment
kubectl describe deployment nginx-deploy | grep -i image
kubectl get pods
kubectl rollout history deployment nginx-deploy
```

Create an nginx pod called `nginx-resolver` using image `nginx`, expose it internally with a service called `nginx-resolver-service`. Test that you are able to look up the service and pod names from within the cluster. Record results in `/root/nginx.svc` and `/root/nginx.pod`.
- Pod: nginx-resolver, 
- Service DNS Resolution recorded correctly
- Pod DNS resolution recorded correctly

`Answer`
First Section
```bash
kubectl run --generator=run-pod/v1 nginx-resolver --image=nginx
kubectl expose pod nginx-resolver --name=nginx-resolver-service --port=80 --target-port=80 --type=ClusterIP
kubectl describe svc nginx-resolver-service
kubectl get nginx-resolver -o wide
kubectl get svc
kubectl delete svc get nginx-resolver
kubectl get nginx-resolver -o wide
```
Second Section
```bash
kubectl run --generator=run-pod/v1 test-nslookup --image=busybox:1.28 --rm -it -- nslookup nginx-resolver-service
kubectl run --generator=run-pod/v1 test-nslookup --image=busybox:1.28 --rm -it -- nslookup nginx-resolver-service > /root/nginx.svc
cat /root/nginx.svc
kubectl get pod nginx-resolver -o wide
kubectl run --generator=run-pod/v1 test-nslookup --image=busybox:1.28 --rm -it -- nslookup PodIP.default.pod > /root/nginx.pod
cat /root/nginx.pod
```

Create a static pod on `node01` called `nginx-critical` with image `nginx`. Create this pod on `node01` and make sure that it is recreated/restarted automatically in case of failure. Use `/etc/kubernetes/manifests` as the static path for example.
- kubelet configure for static pods
- pod nginx-critical-node01 is up and running

`Answer`
```bash
kubectl get nodes
ssh node01
systemctl status kubelet
nano /var/lib/kubelet/config.yaml # set staticPodPath /etc/kubernetes/manifests
nano nginx-critical.yaml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
   creationTimestamp: null
   labels:
      run: nginx-critical
   name: nginx-critical
spec:
   containers:
   - image: nginx
     name: nginx-critical
```
```bash
kubectl get pod
docker ps | grep -i nginx-critical
```

From the pod label environment=process, find all the pods running high CPU workloads and write the name of which is consuming the most CPU to the file `/doc/high-cpu.txt`.

`Answer`
```bash
kubectl get pods -l environment=process
kubectl top pod --sort-by cpu -l environment=process | name head -2
kubectl top pod --sort-by cpu -l environment=process | name head -2 > /doc/high-cpu.txt
cat /doc/high-cpu.txt
```

Overwrite the label of the pod named `dev-nginx-pod` with the value "env=true"

`Answer`
```bash
kubectl describe pod dev-nginx-pod # label checking
kubectl label pod/dev-nginx-pod env=true --overwrite
kubectl describe pod dev-nginx-pod # label checking again
```

Find out how which pods are available the label `env=my-green` in the cluster and write them to the file `/doc/available-pods.txt`.

`Answer`
```bash
kubectl get pods -l env=my-green
kubectl get pods -l env=my-green > /doc/available-pods.txt
cat /doc/available-pods.txt
```

The pod `nginx-pod` is failing. Find out why fix the issue.

`Answer`
```bash
kubectl get pods -o wide
kubectl describe pod nginx-pod
kubectl get pod nginx-pod -o yaml > nginx-pod.yaml
kubectl delete pod nginx-pod
nano nginx-pod.yaml # for fix
kubectl apply -f nginx-pod.yaml
kubectl get pod nginx-pod -o wide
```

Create a pod that will only be scheduled on a node with a specific label.
- pod name: my-pod
- image: nginx

`Answer`
```bash
kubectl get nodes
kubectl label nodes node01 disk=ssd # label selector
kubectl run my-pod --image=nginx --dry-run=client -o yaml > my-pod.yaml
```
Add it below `spec`
```yaml
nano my-pod.yaml
nodeSelector:
   disk: ssd
```
```bash
kubectl create -f my-pod.yaml
kubectl get pod my-pod -o wide
kubectl describe node node01
```

Create a pod echo's "Welcome to DevOps" and then exits. The pod should be deleted automatically when its completed.
- pod name: my-pod
- image: busybox

`Answer`
```bash
kubectl run my-pod --image=busybox -it --rm --restart=Never -- /bin/sh -c 'echo Welcome to DevOps'
```

You just created the pod `my-pod`, but its not scheduling on the node. Troubleshoot and fix the issue.

`Answer`
```bash
kubectl get pod my-pod -o wide
kubectl describe pod my-pod # see not scheduling due wrong node selector
kubectl describe node node01 | grep labels
kubectl get pod my-pod -o yaml > my-schedule-pod.yaml
nano my-schedule-pod.yaml # update node selector
kubectl replace --force -f my-schedule-pod.yaml
kubectl get pod my-pod -o wide
kubectl describe pod my-pod # pod scheduled
```

Create a pod and set `SYS_TIME` sleep 3600.
- pod name: my-pod
- image: busybox

`Answer`
```bash
kubectl run my-pod --image=busybox --command sleep 3600 --dry-run=client -o yaml > my-pod.yaml
nano my-pod.yaml
```
Add this section below `my-pod` name
```yaml
securityContext:
   capabilities:
      add: ["SYS_TIME"]
```
```bash
kubectl create -f my-new-pod.yaml
kubectl get pod my-pod -o wide
kubectl get pod my-pod -o yaml # lets check security context
```

Get the IP address of the `my-pod` pod and write it to the file `/doc/ip-address.txt`.

`Answer`
```bash
kubectl get pods
kubectl describe pod my-pod | grep Labels
kubectl get pods -l run=my-pod -A -o jsonpath='{range.items[*]}{@.status.podIP}{""}{"\n"}{end}'
kubectl get pods -l run=my-pod -A -o jsonpath='{range.items[*]}{@.status.podIP}{""}{"\n"}{end}' > /doc/ip-address.txt
cat /doc/ip-address.txt
```

Use jsonpath and get a list of all the pods with name and namespace, and write to the file `/doc/pods-namespace.txt`.
```bash
kubectl get pods --all-namespaces
kubectl get pods -A -o jsonpath='{range.items[*]}{.metadata.name}{"\t"}{.metadata.namespace}{"\n"}{end}'
kubectl get pods -A -o jsonpath='{range.items[*]}{.metadata.name}{"\t"}{.metadata.namespace}{"\n"}{end}' > /doc/pods-namespace.txt
cat /doc/pods-namespace.txt
```

List the `my-pod` pod with the custom columns `POD_STATUS` and `POD_NAME` and write to the file `/doc/status.txt`.

`Answer`
```bash
kubectl get pod my-pod
kubectl get pod my-pod -o=custom-columns="POD_NAME:metadata.name,POD_STATUS:.status.containerStatuses[].state"
kubectl get pod my-pod -o=custom-columns="POD_NAME:metadata.name,POD_STATUS:.status.containerStatuses[].state" > /doc/status.txt
cat /doc/status.txt
```

For the my-pod, set CPU memory requests and limits.
- REQUESTS: CPU=20m, memory=40Mi
- LIMITS: CPU=160m, memory=200Mi

`Answer`
```bash
kubectl get pods
kubectl describe pod my-pod
kubectl get pod my-pod -o yaml > my-new-pod.yaml
nano my-new-pod.yaml
```
Update this section
```yaml
resources:
   limits:
      cpu: 160m
      memory: 200Mi
   requests:
      cpu: 20m
      memory: 40Mi
```
```bash
kubectl delete pod my-pod
kubectl create -f my-new-pod.yaml
kubectl get pods
kubectl describe pod my-pod
```

Troubleshoot the failed pod `my-pod` and make it running again.

`Answer`
```bash
kubectl get pod my-pod -o wide # see ErrImagePull
kubectl describe pod my-pod
kubectl get pod my-pod -o yaml > my-correct-pod.yaml # troubleshoot here
kubectl create -f my-correct-pod.yaml
kubectl get pod my-pod -o wide # see Running
kubectl describe pod my-pod
```

Expose the `my-pod` pod internally and create a `my-test-pod` for look-up.
- port: 80
- service name: my-pod-service
- test pod name: my-test-pod, image: busybox:1.28
- type: ClusterIP

`Answer`
```bash
kubectl get pods
kubectl expose pod my-pod --name=my-pod-service --port=80 --target-port=80 --type=ClusterIP
kubectl get services
kubectl run my-test-pod --image:busybox:1.28 --rm -it --restart=Never -- nslookup my-pod-service
```

Create a pod and assign it to the node `node01`.
- pod name: my-pod
- image: nginx

`Answer`
```bash
kubectl get node node01 -o wide
kubectl run my-pod --image=nginx --dry-run=client -o yaml > my-pod.yaml
nano my-pod.yaml
```
Add `nodeName=node01` below specification and save
```bash
kubectl create -f my-pod.yaml
kubectl get pod my-pod -o wide
```

Find all the pods with the label `env=dev-team` and write to the file `/doc/all-pod-label.txt`.

`Answer`
```bash
kubectl get pods -l env=dev-team
kubectl get pods -l env=dev-team > /doc/all-pod-label.txt
cat /doc/all-pod-label.txt
```

Check the image version of the `my-pod` pod without using the describe command and write to the file `/doc/image-version-pod.txt`.

`Answer`
```bash
kubectl get pod my-pod -o jsonpath='{.spec.containers[].image}{"\n"}'
kubectl get pod my-pod -o jsonpath='{.spec.containers[].image}{"\n"}' > /doc/image-version-pod.txt
cat /doc/image-version-pod.txt
```

Print the pod names and times to the file `/doc/pod-start-time.txt`.

`Answer`
```bash
kubectl get pods -o jsonpath='{range.items[*]}{.metadata.name}{"\t"}{.status.startTime}{"\n"}{end}'
kubectl get pods -o jsonpath='{range.items[*]}{.metadata.name}{"\t"}{.status.startTime}{"\n"}{end}' > /doc/pod-start-time.txt
cat /doc/pod-start-time.txt
```

Create a pod and run the command which shows "Welcome to DevOps" and sleeps for 100 seconds.
- pod name: my-pod
- image: busybox

`Answer`
```bash
kubectl run my-pod --image=busybox --dry-run=client -o yaml > my-pod.yaml
nano my-pod.yaml
```
Add this code under containers
```yaml
command: ["/bin/sh"]
args: ["-c", "while true; do echo Welcome to DevOps; sleep 100; done"]
```
```bash
kubectl create -f my-pod.yaml
kubectl get pods
kubectl logs my-pod
```

Create two pods with different labels.
- pod 1 name: pod01
- image: nginx
- label: env=green

- pod 2 name: pod02
- image: nginx
- label: env=red

`Answer`
```bash
kubectl run pod01 --image=nginx -l env=green
kubectl get pods -l env=green
kubectl run pod02 --image=nginx -l env=red
kubectl get pods -l env=red
```

Delete the `white-shark` pod without any delay.

`Answer`
```bash
kubectl get pods
kubectl delete pod white-shark --grace-period=0 --force
kubectl get pods
```

Get a list of all the pods which were recently deleted. Write the list to the file `/doc/recent-delete.txt`.

`Answer`
```bash
kubectl get events -o custom-columns=NAME:.metadata.name | cut -d "." -f1
kubectl get events -o custom-columns=NAME:.metadata.name | cut -d "." -f1 | cut -d "m" -f1
kubectl get events -o custom-columns=NAME:.metadata.name | cut -d "." -f1 | cut -d "m" -f1 | uniq
kubectl get events -o custom-columns=NAME:.metadata.name | cut -d "." -f1 | cut -d "m" -f1 | uniq | sed 's/\<NAME/>//g'
kubectl get events -o custom-columns=NAME:.metadata.name | cut -d "." -f1 | cut -d "m" -f1 | uniq | sed 's/\<NAME/>//g' | sed '/^$/d'
kubectl get events -o custom-columns=NAME:.metadata.name | cut -d "." -f1 | cut -d "m" -f1 | uniq | sed 's/\<NAME/>//g' | sed '/^$/d' > /doc/recent-delete.txt
cat /doc/recent-delete.txt
```

There is something wrong with the `dark-blue-pod` pod. Troubleshoot and fix the issue.

`Answer`
```bash
kubectl get pods
kubectl describe pod dark-blue-pod
kubectl get pod dark-blue-pod -o yaml > dark-blue-pod.yaml
nano dark-blue-pod.yaml
kubectl delete pod dark-blue-pod
kubectl create -f dark-blue-pod.yaml
kubectl get pods
```

Create a pod and add `runAsUser: 2000` and `fsGroup: 5000`.
- pod name: sec-pod
- image: nginx

`Answer`
```bash
kubectl run sec-pod --image=nginx --dry-run=client -o yaml > sec-pod.yaml
nano sec-pod.yaml
```
```yaml
apiVersion: v1
kind: Pod
metadata:
   creationTimestamp: null
   labels:
      run: sec-pod
   name: sec-pod
spec:
   securityContext:
      runAsUser: 2000
      fsGroup: 5000
   containers:
   - image: nginx
     name: sec-pod
     resources: {}
   dnsPolicy: ClusterFirst
   restartPolicy: Always
status: {} 
```
```bash
kubectl create -f sec-pod.yaml
kubectl get pod sec-pod
```

Create a pod named `sec-pod` with the image `nginx` and set `NET_ADMIN`.

`Answer`
```yaml
apiVersion: v1
kind: Pod
metadata:
   name: sec-pod
spec:
   containers:
      name: sec-pod
      image: nginx
      securityContext:
        capabilities:
          add: ["NET_ADMIN"]
```
```bash
kubectl create -f sec-pod.yaml
kubectl get pods
```

Delete all the pods with the label `env:orange`

`Answer`
```bash
kubectl get pods -l env=orange
kubectl delete pods -l env=orange
kubectl get pods -l env=orange
```

Replace the `my-pod` pod with the existing yaml file `pod-replace.yaml` and verify after.

`Answer`
```bash
kubectl get pods -o wide
kubectl describe pod my-pod
kubectl replace -f pod-replace.yaml --force
kubectl get pods -o wide
kubectl describe pod my-pod
```

Edit the existing pod `my-nginx` and the command `sleep 3600`.

`Answer`
```bash
kubectl get pod my-nginx -o yaml > my-nginx.yaml
nano my-nginx.yaml
```

Add this section under containers

`Answer`
```yaml
command: ["sleep", "3600"]
```
```bash
kubectl delete pod my-nginx
kubectl create -f my-nginx.yaml
kubectl get pods
kubectl describe pod my-nginx
```

Create a pod with the labels, pod name: mango-pod, image: redis:alpine, labels: tier=redis.
NB: redis:alpine means Redis container will be created using the Redis image built on Alpine Linux

`Answer`
```bash
kubectl run mango-pod --image=redis:alpine -l tier=redis
kubectl describe pod mango-pod # check labels
kubectl exec -it mango-pod – redis-cli ping
```

Create a pod in the ‘fruit-ns’ namespace, pod name: banana-pod, image: redis:alpine
kubectl create namespace fruit-ns

`Answer`
```bash
kubectl run banana-pod --image=redis:alpine -n fruit-ns
kubectl get ns
kubectl describe pod banana-pod -n fruit-ns
```

Create a pod & expose it where pod name: mango-pod, image: redis:alpine, service name: my-pod-service, port: 8090, target port: 80

`Answer`
```bash
kubectl run mango-pod --image=redis:alpine
kubectl expose pod mango-pod --name=my-pod-service --port=8090 --target-port=80
kubectl describe service my-pod-service
```

Create a static pod & use the command “sleep 1000”, where pod name: my-static-pod, image: busybox

`Answer`
```bash
kubectl create deployment nginx-deployment --image=nginx:1.26.0 --replicas=3 --dry-run=client -o yaml > nginx-deployment.yaml
kubectl apply -f nginx-deployment.yaml
kubectl get deployments -o wide
kubectl set image deployment/nginx-deployment nginx=nginx:1.27.0 --record
kubectl get deployments -o wide
kubectl rollout history deployment nginx-deployment # check history
```

Create a static pod and use the command “sleep 1000”, where pod name: static-box, image: busybox

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