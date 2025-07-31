Create a NetworkPolicy that allows all pods in the `ns-pro-deploy` namespace to have communication only on a single port.
- NetworkPolicy name: ns-pro-deploy
- Port: 80/TCP

`Answer`
```bash
kubectl label namespace ns-pro-deploy app=ns-pro-deploy
```
Create network policy
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
   name: pro-network-policy
   namespace: ns-pro-deploy
spec:
   podSelector: {}
   policyTypes:
   - Ingress
   ingress:
   - from:
     - namespaceSelector
         matchLabels: 
            app: ns-pro-deploy # come app level
      ports:
      - protocol: TCP
        port: 80
```
```bash
kubectl create -f network-policy.yaml
kubectl describe networkpolicy ns-pro-deploy -n ns-pro-deploy
```

Create a network policy and allow traffic from the `my-pod` pod to the `finance-service` and the `data-service`.
- policy name: internal-policy
- policy type: egress
- label pod: role=post
- egress allow: finance
- finance port: 8080
- egress allow: data
- data port: 5432

`Answer`
```bash
nano my-network-policy.yaml
```
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
   name: internal-policy
   namespace: default
spec:
   podSelector:
      matchLabels:
         role: post
   policyTypes:
   - Egress
   egress:
   - to:
      - podSelector:
           matchLabels:
              name: finance
        ports:
        - protocol: TCP
          port: 8080
   - to:
      - podSelector:
           matchLabels:
              name: data
        ports:
        - protocol: TCP
          port: 5432
```
```bash
kubectl create -f my-network-policy.yaml
```

Create a NetworkPolicy which denies all the ingress traffic.

`Answer`
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
   name: default-deny-ingress
spec:
   podSelector: {}
   policyTypes:
   - Ingress
```
```bash
kubectl create -f default-deny-ingress.yaml
kubectl get networkpolicy
kubectl describe networkpolicy default-deny-ingress
```