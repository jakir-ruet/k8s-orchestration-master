### Multi-Container Pods in Kubernetes

In Kubernetes, a Pod can contain one or more containers that share the same:

- Network namespace (same IP, same ports)
- Storage volumes
- Lifecycle (start, stop, restart together)

These containers are tightly coupled and usually work as a single logical unit like

- A main application container
- A sidecar for logging, monitoring, or proxying traffic
- An init container that runs setup tasks before the main app starts

#### Why Use Multi-Container Pods?

You use multiple containers in a Pod when the containers need to cooperate closely and share resources.

| Pattern        | Description                                               | Example                                 |
| -------------- | --------------------------------------------------------- | --------------------------------------- |
| **Sidecar**    | Enhances the main container by adding extra functionality | Logging agent, proxy, metrics exporter  |
| **Adapter**    | Transforms data before sending it                         | Converts logs or metrics formats        |
| **Ambassador** | Provides a helper service                                 | Local proxy to external systems or APIs |

