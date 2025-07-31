### MERN Full Stack App Configure & Deployment on Docker & Kubernetes as well.
Its required some important steps
#### MERN Environment Configuration with Install MongoDB on Docker
```bash
docker pull mongo
docker run --name mongodb-server -p 27017:27017 -d mongo:latest
docker exec -it mongodb-server bash
```

#### Making an Application

#### Requirement of complete deployment analysis
1. Deployments/Pods [2]
   - MongoDB (Private Interaction)
   - MongoExpress (Public Interaction)
2. Services [2]
   - Internal Service
   - External Service
3. ConfigMap (Database URL) [1]
4. Secret (DB UserName & Password) [1]

#### Find the base64 value of username & password
```bash
   echo -n 'username' | base64
```

```bash
   echo -n 'password' | base64
```

#### After configuring the mongo-deployment.yaml & mongo-secret.yaml
- deploying the mongo-deployment.yaml by following command [we must run the minikube ```minikube start```]
```bash
   kubectl apply -f mongo-deployment.yaml
```
After it will make a pod named "mongo-deployment"
```bash
   kubectl get pod
```
See in details of the pod
```bash
   kubectl describe pod PodName
```

#### type service code in mongo-deployment.yaml file
```bash
   apiVersion: v1
   kind: Service
   metadata: 
   name: mongodb-service
   spec:
   selector:
      app: mongodb
   ports:
      - protocol: TCP
      port: 27017
      targetPort: 27017
```
Reapply & check service
```bash
   kubectl apply -f mongo-deployment.yaml
```
```bash
   kubectl get service
```