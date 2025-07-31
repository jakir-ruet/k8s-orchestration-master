Take a backup of the `etcd` cluster and save it to `/tmp/etcd-backup.db`

`Answer`
```bash
kubectl get nodes
ETCDCTL_API=3 etcdctl version # check etcd version
cd /etc/kubernetes/manifests
cat etcd.yaml
copy & ant the end 'member list' & press enter
ETCDCTL_API«3 etcdctl--endpoints-https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt --key=/etc/kuberr etes/pki/etcd/healthcheck-client.key member list # check list
ETCDCTL_API«3 etcdctl--endpoints-https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt --key=/etc/kuberr etes/pki/etcd/healthcheck-client.key save /tmp/etcd-backup.db # take backup
ETCDCTL_API«3 etcdctl--endpoints-https://[127.0.0.1]:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/healthcheck-client.crt --key=/etc/kuberr etes/pki/etcd/healthcheck-client.key status /tmp/etcd-backup.db # check status on table
```