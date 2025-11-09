#### Welcome to K8s [Securing](https://kubernetes.io/docs/concepts/security/)

Kubernetes security is a broad topic due to the sophistication of the platform. It includes secure Kubernetes **nodes**, **networks**, and Kubernetes objects such as **Pods**. The Cloud Native Computing Foundation (CNCF) defines Kubernetes security in layers, which they call the four Cs of cloud-native security, taking the topic of security beyond Kubernetes and its ecosystem. The **four C**s stand for **Cloud**, **Cluster**, **Container**, and **Code**, as shown in the following diagram:
![K8s Security Layer](/img/security/security-layer.png)

- Cloud
  it is managed by the cloud provider when it is in the cloud or by the organization when it comes to a private data center.
- Cluster
  It is more about securing the Kubernetes cluster components, ensuring each component is secured and conjured correctly.
- Container
  Its includes container vulnerability scanning, hosted OS scaling, and container privileged users.
- Code
  It is focused on the application code. Different from traditional application security approaches, it now works with DevSecOps and vulnerability assessment tools.

**Service accounts versus user accounts**
In Kubernetes, we have a distinction between normal user accounts and service accounts managed by Kubernetes. An account represents an identity for a user or a service process. The main difference between a user account and a service account is as follows:

1. **User accounts** are for normal human users. In Kubernetes, the RBAC subsystem is used to determine whether the user is authorized to perform a specific operation on a specific scope. We’ll look into this further in the Kubernetes RBAC section as I discussion previous.
2. **Service accounts** are for services or processes running in a Pod in the Kubernetes cluster. The service accounts are users managed by the Kubernetes API. In Kubernetes, it is possible to use client certificates, bearer tokens, or even an authenticating proxy to authenticate API requests through an API server.

**K8s Authorization**
A request must be authenticated before it can be authorized with permissions granted to access the Kubernetes cluster resources. There are four authorization modes in Kubernetes:

1. RBAC authorization:
   K8s RBAC is more about regulating access to Kubernetes resources according to the roles with specific permissions to perform a specific task, such as reading, creating, or modifying through an API request. We’ll focus on Kubernetes RBAC in this section.
2. Node authorization:
   As the name suggests, this grants permissions to the API requests made by `kubelets agent`. This is a special - purpose authorization mode not covered in the CKA exam.
3. ABAC authorization:
   ABAC is an access control granted to users by policies and attributes such as user attributes, resource attributes, and objects. This topic is not covered in the current CKA exam.
4. Webhook authorization:
   Webhook authorization through WebHooks is an HTTP POST triggered by an event. An example of this is that the Webhook will react to a URL when triggered by certain actions. This topic is not covered in the current CKA exam.

[See](https://github.com/jakir-ruet/docker-kubernetes-learning/tree/master/02-kubernetes/03-object-management/01-rbac)
