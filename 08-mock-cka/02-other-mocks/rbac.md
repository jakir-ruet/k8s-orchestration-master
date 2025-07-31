Create a new user called `jasim`. Grant him access to the cluster. Jasim should have permission to `create`, `list`, `get`, `update` and `delete` pods in the `development` namespace. The private key exists in the location: `/root/jasim.key` and csr at `/root/jasim.csr`.
- CSR: jasim-developer StatusApproved
- Role Name: developer, Namespace: development, Resource: pods
- Access User: 'jasim' has appropriate permissions

`Answer`
**CSR: jasim-developer StatusApproved**
Create private key & a Certificate Signing Request (CSR) for Jasim user
```bash
cd ${HOME}/.kube
sudo apt-get install openssl
sudo openssl genrsa -out jasim.key 2048
sudo openssl req -new -key jasim.key -out jasim.csr -subj "/CN=jasim/O=development"
# Where CN > Common Name & O > Organization
```
Provide CA keys of K8s cluster to generate the certificate
```bash
sudo openssl x509 -req -in jasim.csr -CA ${HOME}/.minikube/ca.crt -CAkey ${HOME}/.minikube/ca.key -CAcreateserial -out jasim.crt -days 45
```
View & add the user in the Kubeconfig file.
```bash
kubectl config view
kubectl config set-credentials Jasim --client-certificate ${HOME}/.kube/jasim.crt --client-key ${HOME}/.kube/jasim.key
kubectl config view
```
Add a context in the config file, that will allow this user `Jasim` to access the development namespace in the cluster.
```bash
kubectl config set-context jasim-context --cluster=minikube --namespace=development --user=jasim
```

Check certificate
```bash
ls -ltr | tail -2
kubectl api-versions | grep certif
```
Create `jasim.yaml` & save
```yaml
apiVersion: certificate.k8s.io/v1
kind: CertificateSigningRequest
metadata:
   name: jasim-developer
spec:
   request:
   usages:
   - digital signature
   - key encipherment
   - server auth
```
```bash
cat jasim.csr | base64 | tr -d "\n"
```
Copy the long string & paste to `request` variable.
```bash
nano jasim.yaml # after save
kubectl create -f jasim.yaml
kubectl get csr
kubectl certificate approve jasim-developer
kubectl get csr
```

**Role Name: developer, Namespace: development, Resource: pods**
```bash
kubectl create role developer --resource=pods --verb=create,list,get,update,delete --namespace=development
kubectl describe role developer -n development
```

**Access User: 'jasim' has appropriate permissions**
```bash
kubectl create rolebinding developer-role-binding --role=developer --user=jasim --namespace=development
kubectl -n development describe rolebinding.rbac.authorization.k8s.io developer-role-binding
```

Check the role of jasim
```bash
kubectl auth can-i update pods # result yes
kubectl auth can-i update pods --as=jasim # result no
kubectl auth can-i update pods --namespace=development --as=jasim # result yes
kubectl auth can-i list pods --namespace=development --as=jasim # result yes
kubectl auth can-i watch pods --namespace=development --as=jasim # result no
```

A new colleague `jasim` has joined your team. Create a new user and grant him access to the cluster. He should have the permission to create, list, get, update & delete pods in the `dev-team` namespace.

`Answer`
```bash
openssl genrsa -out jasim.key 2048
openssl req -new -key jasim.key -out jasim.csr # press enter
```
Save as `csr.yaml`
```yaml
apiVersion: certificates.k8s.1o/v1
kind: CertificateSigningRequest 
metadata:
   name: jasim
spec:
   request: LSOtLS1CRUdJTiBDRVJUSUZJQ0FURSBSRVFVRVNULSOtLSOKTULJQ1ZqQONBVDRDQ$
   signerName: kubernetes.io/kube-apiserver-client 
   expirationSeconds: 86400
   usages:
   - client auth
```
```bash
cat jasim.csr | base64 | tr -d "\n" # copy hash value
nano csr.yaml  # paste here in request variable & save
kubectl apply -f csr.yaml
kubectl get csr # show pending status
kubectl certificate approve jasim
kubectl get csr # show approved, issued
```
```yaml
nano role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
   namespace: dev-team
   name: pod-reader
rules:
- apiGroups: [""] # "" indicate the core API group
  resources: ["pods"]
  verbs: ["get","create","list","update","delete"]
```
```yaml
nano rolebinding.yaml
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
```bash
kubectl apply -f role.yaml
kubectl get role -n dev-team # and
kubectl create -f rolebinding.yaml
kubectl get rolebinding.rbac.authorization.k8s.io -n dev-team
kubectl auth can -i delete pods -n dev-team --as jasim # get yes
```

Create a clusterrole and a clusterrolebinding which provides `get`, `watch` & `list` access to the pods.
- cluster role name: cluster-administrator
- cluster role binding name: clusterbinding-administrator
- service account: admin-sa

`Answer`
```bash
kubectl create clusterrole cluster-administrator --verb=get,watch,list --resource=pods
kubectl create clusterrolebinding clusterbinding-administrator --clusterrole=cluster-administrator --serviceaccount=default:admin-sa
kubectl auth can -i list pods --as system:serviceaccount:default:admin-sa # got yes
```

Create a new clusterrole named `green-clusterrole` which allows you to create deployments.
- After create a new serviceaccount named `green-sa` in the `tech` namespace.
- Add finally, bind the clusterrole to the serviceaccount by creating a rolebinding named `green-rb`

`Answer`
```bash
kubectl create clusterrole green-clusterrole --verb=create --resource=deployments
kubectl create sa green-sa --namespace=tech
kubectl create rolebinding green-rb --clusterrole=green-clusterrole --serviceaccount=default:green-sa --namespace=tech
kubectl get clusterrole
kubectl get serviceaccount -n tech
kubectl get rolebinding -n tech
```