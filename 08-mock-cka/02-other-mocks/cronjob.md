Create a cronjob which prints the date and `Running` every minute.
- pod name: show-date-job
- image: busybox

`Answer`
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
   name: show-date-time
spec:
   schedule: "* * * * *"
   jobTemplate:
      spec:
         containers:
         - name: show-date-job
           image: busybox:1.28
           imagePullPolicy: IfNotPresent
           command:
           - /bin/sh
           - -c
           - date; echo Running
         restartPolicy: OnFailure 
```
```bash
kubectl create -f cronjob.yaml
kubectl get cronjobs
kubectl describe cronjob show-date-time
```