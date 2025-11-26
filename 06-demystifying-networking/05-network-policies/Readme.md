### Overview

> By default, all Pods can talk to all Pods.
> NetworkPolicy allows restricting traffic.

### Create a deny-all policy

```bash
kubectl apply -f deny-all.yaml
```

> Now traffic to Pods will be blocked.

### Allow only test pod to access myapp

```bash
kubectl apply -f allow-test.yaml
```

### Test

```bash
kubectl exec -it test -- wget -qO- http://clusterip-service
```

> Allowed

### Try from another Pod

```bash
kubectl run test2 --image=busybox -it -- sh
wget -qO- http://myapp-service
```

> Blocked
