### Maintaining, Monitoring, and Troubleshooting

overview of Maintaining, Monitoring, and Troubleshooting Kubernetes, with practical tools and best practices for each area.

#### Maintenance

Maintenance ensures that your cluster remains secure, performant, and up to date.

- Cluster Upgrades.
  - Upgrade Kubernetes Components.
  - Upgrade Add-ons (e.g., CNI, CSI, CoreDNS, kube-proxy).
  - Check Deprecations: Review release notes for API version changes `kubectl get --raw / | jq .`.
- Backup and Restore
  - etcd Backups `ETCDCTL_API=3 etcdctl snapshot save snapshot.db`
  - Store snapshots in secure, versioned storage (e.g., S3, GCS).
  - Cluster State Backup: Tools like `Velero` back up persistent volumes and cluster resources.
  - Disaster Recovery Testing: Regularly restore from backups in test environments.
- Resource and Node Management
- Autoscaling
  - Cluster Autoscaler adjusts node count.
  - Horizontal Pod Autoscaler (HPA) adjusts pod replicas.

#### Monitoring

Monitoring ensures visibility into cluster health, performance, and workload behavior.

##### Core Monitoring Tools

| Area                  | Tools                                                          |
| --------------------- | -------------------------------------------------------------- |
| Metrics & Performance | **Prometheus + Grafana**, **Metrics Server**                   |
| Logs                  | **Fluentd**, **Fluent Bit**, **Elastic Stack (ELK)**, **Loki** |
| Tracing               | **Jaeger**, **OpenTelemetry**, **Zipkin**                      |
| Events & Alerts       | **Alertmanager**, **PagerDuty**, **Opsgenie**                  |

##### Key Metrics to Track

- `Cluster Level:` Node CPU, memory, disk usage, API server latency, etcd health.
- `Pod Level:` Pod restarts, resource requests vs. limits, container logs.
- `Application Level:` HTTP request latency, error rates, throughput.

##### Dashboards & Visualization Grafana Dashboards for

- Cluster health
- Namespace resource usage
- Network performance
- Application latency

#### Troubleshooting

When something breaks, structured diagnosis is key. Common Troubleshooting Steps.

- Check Cluster Health
- Inspect Pod Issues
- Network Issues
- Storage Problems
- Node Problems

> Debugging Tools

- `kubectl debug` (ephemeral debug containers)
- `kubectl exec` (run commands inside containers)
- `Lens`, `K9s`, or `Octant` for visual cluster exploration
- `Stern` or `kubetail` for aggregated log viewing

#### Prerequisites

- Access to the `control plane` node (where etcd runs)
- `etcdctl` installed
- Knowledge of etcd’s `API version` (v3 for Kubernetes ≥ 1.13)
- Access to the `certificate files` used by etcd
