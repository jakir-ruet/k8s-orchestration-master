#### Lets get started
Kubernetes RBAC is a key security control to ensure that cluster users and workloads have only the access to resources required to execute their roles. It is important to ensure that, when designing permissions for cluster users, the cluster administrator understands the areas where privilege escalation could occur, to reduce the risk of excessive access leading to security incidents. ***NB:*** Attribute-Based Access Control (ABAC) has been deprecated since Kubernetes version 1.6 in favour of RBAC.

***Role*** is a type of resource that defines a set of permissions for a specific namespace. It allows you to grant access to Kubernetes resources within that namespace to users, groups, or service accounts.

Role Example
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: default
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]       
```

***ClusterRole*** is a type of resource that defines a set of permissions across the entire cluster, rather than within a specific namespace like a Role does. ClusterRoles are used to grant access to Kubernetes resources that span multiple namespaces or are cluster-wide.
ClusterRole Example
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cluster-admin
rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "watch", "list"]
```

| Aspect                    | Role                                                 | ClusterRole                                                                                |
| ------------------------- | ---------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| Scope                     | Namespace-wide                                       | Cluster-wide                                                                               |
| Definition                | Defines permissions within a specific namespace      | Defines permissions that are available cluster-wide                                        |
| Resources Managed         | Resources within a single namespace                  | Resources across all namespaces and cluster-wide resources                                 |
| Typical Use Case          | Granting permissions to resources within a namespace | Granting permissions to cluster-level resources (like nodes) or across multiple namespaces |
| Binding Mechanism         | RoleBinding                                          | ClusterRoleBinding or RoleBinding                                                          |
| Example Resources Managed | Pods, Services, ConfigMaps, Secrets                  | Nodes, PersistentVolumes, CustomResourceDefinitions (CRDs)                                 |
                                  
***RoleBinding*** is a resource that binds a Role to a user, group, or service account within a specific namespace. RoleBindings are used to grant permissions defined in a Role to entities (subjects) that need access to Kubernetes resources within a particular namespace. 

Role Binding Example
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: User
  name: jasim
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

***ClusterRoleBinding*** in Kubernetes is a resource that binds a ClusterRole to a user, group, or service account across the entire Kubernetes cluster. Unlike RoleBindings, which are limited to a specific namespace, ClusterRoleBindings apply permissions cluster-wide, allowing subjects to access resources across all namespaces or in specified contexts.

ClusterRole Binding Example
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: read-nodes
subjects:
- kind: User
  name: jasim
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io
```

| Aspect                | RoleBinding                                      | ClusterRoleBinding                                   |
| --------------------- | ------------------------------------------------ | ---------------------------------------------------- |
| Scope                 | Applies to resources within a specific namespace | Applies across all namespaces or cluster-wide        |
| Role/ClusterRole Type | Binds a Role                                     | Binds a ClusterRole                                  |
| API Version           | rbac.authorization.k8s.io/v1                     | rbac.authorization.k8s.io/v1                         |
| Resources Managed     | Resources within a single namespace              | Resources across multiple namespaces or cluster-wide |
| Subject               | User, Group, or ServiceAccount                   | User, Group, or ServiceAccount                       |
| Purpose               | Grants permissions within a namespace            | Grants permissions across namespaces or cluster-wide |

***Granular access control*** in Kubernetes refers to the practice of finely defining permissions and restrictions at various levels within the Kubernetes cluster. This approach ensures that users, applications, or services only have access to the resources they require to perform their intended tasks, thereby enhancing security and adhering to the principle of ***least privilege***. Here are some key aspects and strategies for achieving granular access control in Kubernetes:
- Namespace Isolation
- Role-Based Access Control (RBAC)
- Cluster-Wide Permissions
- Resource Quotas and Limit Ranges
- Network Policies
- Pod Security Policies

##### [Add user named Jasim in K8s Cluster](https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/#normal-user)
Create namespace named 'development'
```bash
kubectl create namespace development
```
Create private key & a Certificate Signing Request (CSR) for Jasim user
```bash
cd ${HOME}/.kube
sudo apt-get install openssl
sudo openssl genrsa -out Jasim.key 2048
sudo openssl req -new -key Jasim.key -out Jasim.csr -subj "/CN=Jasim/O=development"
# Where CN > Common Name & O > Organization
```
Provide CA keys of K8s cluster to generate the certificate
```bash
sudo openssl x509 -req -in Jasim.csr -CA ${HOME}/.minikube/ca.crt -CAkey ${HOME}/.minikube/ca.key -CAcreateserial -out Jasim.crt -days 45
```
View & add the user in the Kubeconfig file.
```bash
kubectl config view
kubectl config set-credentials Jasim --client-certificate ${HOME}/.kube/Jasim.crt --client-key ${HOME}/.kube/Jasim.key
kubectl config view
```
Add a context in the config file, that will allow this user (Jasim) to access the development namespace in the cluster.
```bash
kubectl config set-context Jasim-context --cluster=minikube --namespace=development --user=Jasim
```

##### Create a role for user Jasim
Test access by attempting to list pods
```bash
kubectl get pods --context=Jasim-context 
```
Create a role resource using manifest & create role & verify role
```bash
sudo touch pod-reader-role.yaml
kubectl apply -f pod-reader-role.yaml
kubectl get role -n development
```

##### Bind the role to the Jasim & verify your setup works
Create role binding, test access by attempting to list pods & create pod
```bash
sudo touch pod-reader-role-binding.yaml
kubectl apply -f pod-reader-role-binding.yaml
kubectl get pods --context=Jasim-context
kubectl run nginx --image=nginx --context=Jasim-context
```
