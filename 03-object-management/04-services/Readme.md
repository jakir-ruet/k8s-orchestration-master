In Kubernetes, a [Service](https://kubernetes.io/docs/concepts/services-networking/service/) is a method for exposing a network application that is running as one or more Pods in your cluster.
- its used to access the pods from outer world
- its abstract layer between pods & client
- its provides a way to expose application as a set of pods.

***Service Routing***
- client make request to service, which route traffic to pods in ***load balancer*** manner.

***EndPoints***
Each Service has a Type. ServiceType define how and where Service will Expose the Application.
- its backend entities, to which service route traffic.
- each pod have endpoint associate with service
```bash
kubectl get endpoints serviceName
```

***Service Types***
- [ClusterIP](https://kubernetes.io/docs/concepts/services-networking/service/#type-clusterip)
  - ClusterIP Service expose Application within Cluster Network.
  - Use ClusterIP, when client is Other Pods within the Cluster.
    how the client can access to pod via service,
    requirements
    1. deployment (pod)
    2. clusterip-service
    3. tmp-pod (due to service only accessible in k8s network)
```bash
kubectl apply -f deployment.yaml
kubectl describe deployment nginx-server-deployment
kubectl exec -it PodNameHere -c ContainerNameHere -- curl --version
kubectl exec -it PodNameHere -c curl-installer-- curl --version
kubectl get pods -o wide # available 3 pods
kubectl get pod -o wide --show-labels
kubectl apply -f svc-clusterip.yaml
kubectl describe service nginx-service
curl nginx-service:8080 # getting an error, due its work only within k8s network, so we need temp pod
kubectl apply -f svc-test-pod.yaml
kubectl exec -it svc-test-pod -- curl --version
kubectl exec svc-test-pod -- curl nginx-service:8080 # see nginx default page
```
    
- [NodePort](https://kubernetes.io/docs/concepts/services-networking/service/#type-nodeport)
  - NodePort Service expose Application Outside Cluster Network.
  - Use NodePort, when client is accessing the Service from Outside the Cluster.
```bash
kubectl apply -f svc-nodeport.yaml
kubectl describe nginx-service-nodeport
curl localhost:35005
# after allow this port 35005 in AWS/GCP in inbound policy
http://IPofInstance:35005
```

- [LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer)
  - Load Balancer Service also expose Application to Outer World but Cloud LB is required.
- [ExternalName](https://kubernetes.io/docs/concepts/services-networking/service/#externalname)

***Service DNS***
- Kubernetes DNS assign DNSNames to Services, allow applications within Cluster to easily locate the Service.
- Service Fully Qualified Name has the following format- `Service-name.namespace-name.svc.cluster-domain.example`
- Default Cluster Domain is `cluster.local`

***Service DNS & Namespaces***
- Service fully qualified Domain Name can be used to reach service from within any Namespace in Cluster. `service-name.namespace-name.svc.cluster.local`
- Pods within the same NameSpace can use the Service Name Only.
`service-name`

Accessing to service from same & cross namespace.
```bash
kubectl get services -o wide
kubectl get pods -o wide --show-labels
kubectl apply -f svc-test-pod.yaml
kubectl create namespace service-namespace
kubectl get namespaces --show-labels
kubectl get pods -o wide --show-labels -n service-namespace
kubectl apply -f svc-dns-pod.yaml
kubectl exec podName -- curl serviceName:8080
kubectl exec svc-test-pod -- curl nginx-service:8080
```

[Ingress]()
- Manage the External Access to Service.
- Apart from NodePort Service, Ingress is capable of many more.
- Provide the SSL Termination, Load Balancing, NameBase Virtual Hosting.

[Ingress Controllers](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/)
- In order for the Ingress resource to work, the cluster must have an ingress controller running.
- Variety of Ingress Controller available in K8s to provide the multiple mechanism for external access of Service.
- You can deploy any number of Ingress Controller.
- Ingress define a set of Routing Rules.
- Each Rule has a set of Paths, each with a Backend. Request matching a path will be routed to associated Backend.
- If Service Use ***NamedPort***, ingress can also use the port’s name to choose to which port it will route.

```bash
kubectl apply -f nginx-deployment.yaml
kubectl describe deployment nginx-ingress-deployment
kubectl apply -f nginx-service.yaml
kubectl describe service nginx-service
kubectl apply -f own-nginx-deployment.yaml
kubectl describe deployment own-nginx-ingress-deployment
kubectl apply -f own-nginx-service.yaml
kubectl describe service own-nginx-service
minikube start --driver=docker # for run the minikube
minikube addons enable ingress
minikube service nginx-ingress-service --curl
curl http://192.168.12.102:35006 # see nginx default page
minikube service own-nginx-ingress-service --curl
curl http://192.168.12.103:35006 # see nginx home page
kubectl apply -f ingress-controller.yaml
kubectl describe ingress nginx-rules
minikube ip
192.168.49.2
curl 192.168.49.2 -H 'Host: nginx-ingress.example.com' # see default nginx page 
curl 192.168.49.2 -H 'Host: own-nginx-ingress.example.com' # see default nginx home page 
```