### Overview

`Labels`, `Selectors`, and `Annotations` are core concepts in Kubernetes for organizing, identifying, and managing resources.

#### Labels

Key–value pairs attached to Kubernetes objects (Pods, Services, Deployments, etc.) for identification and organization. It's Used to group, filter, or select resources.

```bash
metadata:
  labels:
    app: web
    env: prod
```

> Use Case:

- Identify application components (`frontend`, `backend`)
- Manage environments (`dev`, `test`, `prod`)
- Enable service discovery and scaling

#### Label Selectors

Queries used to filter or match resources based on their labels. Types of Selectors:

- Equality-based (Match labels with exact values)

```bash
selector:
  matchLabels:
    app: web
```

- Set-based (Match labels from a set of values)

```bash
selector:
  matchExpressions:
    - key: env
      operator: In
      values: ["dev", "test"]
```

> Use Cases

Controllers (Deployments, ReplicaSets), Services, and NetworkPolicies to target specific Pods.

#### Annotations

Key–value metadata used to store non-identifying information about objects.
Unlike labels, annotations are not used for selection. Its use to store additional info for tooling, automation, or documentation.

```bash
metadata:
  annotations:
    description: "Nginx web server for production"
    contact: "devops@company.com"
```

> Use Case:

- Add build or version info
- Store monitoring or audit data
- Include URLs, contact info, or configuration hints

#### Quick Summary

| Concept        | Type      | Used For                   | Selectable? | Example                      |
| -------------- | --------- | -------------------------- | ----------- | ---------------------------- |
| **Label**      | Key–Value | Identify & group resources | Yes         | `app: frontend`              |
| **Selector**   | Query     | Filter resources by label  | Yes         | `env in (dev,prod)`          |
| **Annotation** | Key–Value | Store extra metadata       | No          | `description: "backend API"` |
