K8s has capability to auto restart the containers when they fails, this process is known as restart policies.
 
Restart policies
- Always - Default applied on container & pod.
- OnFailure - If container process exit with error code & liveness probe determine container unhealthy.
- Never - Allow container to never automatically restart even the container liveness probe failed.
