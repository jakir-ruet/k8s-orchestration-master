Change the requested storage size of the PersistentVolumeClaim `storage-pvc` to 800Mi.

`Answer`
```bash
kubectl get pvc
kubectl describe pvc storage-pvc
kubectl get pvc storage-pvc -o yaml > storage-pvc.yaml
nano storage-pvc.yaml
```
Update this section on storage-pvc.yaml
```yaml
requests:
   storage: 800Mi
```
```bash
kubectl replace -f storage-pvc.yaml
kubectl describe pvc storage-pvc
```