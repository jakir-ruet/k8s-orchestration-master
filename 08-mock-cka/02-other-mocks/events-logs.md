List all the events sorted by the timestamp and write the result to file `/doc/events.log`.

`Answer`
```bash
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl get events --sort-by=.metadata.creationTimestamp > /doc/events.log
cat /doc/events.log
```