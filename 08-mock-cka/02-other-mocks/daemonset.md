Create a daemonset.
- name: my-daemonset
- image: httpd:alpine

`Answer`
```bash
kubectl get nodes
kubectl create deployment my-daemonset --image=httpd:alpine --dry-run=client -o yaml > my-daemonset.yaml
nano my-daemonset.yaml
```
Change `kind` deployment to daemonset, remove `replicas`, `strategy` & `status` and save it.
```bash
kubectl create -f my-daemonset.yaml
kubectl get pods -o wide
```