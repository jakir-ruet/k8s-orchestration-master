**Deployments**
A Deployment manages a set of Pods to run an application workload, usually one that doesn't maintain state. A Deployment provides declarative updates for `Pods` and `ReplicaSets`.

**Feature**

- Declarative Updates
- Scaling
- Rolling Updates
- Rollback
- Self-Healing
- Declarative Configuration

**Use Cases**

- Stateless Applications
- Continuous Delivery
- Blue-Green and Canary Deployments

Application scaling

- app scaling
  - vertical scaling (up-down)
  - horizontal scaling (left-right)
- stateless application
  - not save any data
  - not maintain the state for next state
  - can be scaled horizontally
- stateful application
  - save data (cannot split multiple instances)
  - maintain the state for next state
  - can be scaled vertically
- replication controller
  - manage the app scaling
  - ensure the specified of pod replicas are running at any point of time
  - ensure a pod/set of pod is always up & available

Horizontal scale

```bash
kubectl scale --replicas=numberOfPod replicationcontroller/repicationControllerName
# here create more 3 pods (previous 3 + 3)
kubectl scale --replicas=6 replicationcontroller/my-replica-controller
# descale I mean remove 3 recently created pods
kubectl scale --replicas=3 replicationcontroller/my-replica-controller
# delete all pod using this command
kubectl delete -f replication-controller.yaml
```

```bash
kubectl apply -f deployment.yaml
kubectl get deployment nginx-deployment
kubectl rollout status deployment deployment
kubectl describe deployment
kubectl rollout history deployment/nginx-deployment
kubectl rollout status deployment
kubectl describe deployment
kubectl delete -f deployment.yaml
```

**ReplicaSet**

- ReplicaSet?
- ReplicaSet vs ReplicationController
- ReplicaSet vs Bare Pods (Standalone Pods)

**ReplicaSet**: A ReplicaSet in Kubernetes is a controller that ensures a specified number of pod replicas are running at any given time. It maintains a stable set of replica pods, even if some of them fail or are unexpectedly terminated, making sure the desired number of replicas is always available.

**ReplicationController**: A ReplicationController in Kubernetes is an older mechanism for ensuring that a specified number of pod replicas are running at any given time. Similar to a ReplicaSet, a ReplicationController manages the lifecycle of a set of pods, ensuring that the desired number of replicas is always available.

**Bare Pods (Standalone Pods)**: Bare Pods (Standalone Pods) are Kubernetes pods that are not managed by any higher-level controller like a Deployment, ReplicaSet, StatefulSet, or DaemonSet. They are created directly and manually, without using any of the Kubernetes workload controllers that provide additional features like replication, rolling updates, and self-healing.

ReplicaSet vs ReplicationController

- ReplicaSet is enhanced version of ReplicationController
- ReplicaSet support for [set-based & equality-based](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/) selectors but ReplicationController not support
- ReplicaSet generally used with deployments
- ReplicaSet

```bash
spec:
   replicas: 3
   selector:
   matchExpression:
      - {key: app, operator: In, values: [example, example, rs]}
      - {key: tier, operator: NotIn, values: [production]}
   template:
      metadata:
```

- ReplicationController

```bash
spec:
   replicas: 3
   selector:
      app: alpine-app
   template:
      metadata:
```

| Bare Pod                                | ReplicaSet                                                    |
| :-------------------------------------- | :------------------------------------------------------------ |
| Its not have labels                     | Its have labels                                               |
| Suitable for simple, non-critical tasks | Suitable for production workloads requiring high availability |
| not self-healing, and not scalability   | self-healing, and scalability                                 |
| No Scaling                              | Scaling                                                       |
