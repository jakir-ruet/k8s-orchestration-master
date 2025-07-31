### Welcome to Demystifying Storage
#### Container Storage Interface (CSI)
It is a specification that defines a standard for exposing ***block*** and ***file storage systems*** to containerized workloads on Container Orchestration Systems (COS) like Kubernetes. Its offers several benefits and addresses various challenges related to storage management in containerized environments.

Features
- Integrate different storage system with K8s
- Supports to multiple storage options
- Dynamic storage provisioning
- Snapshotting & cloning
- Seamless migration
A volume can support local storage, on-premises software-defined storage, cloud-based storage (such as blob, block, or file storage), or a network file system (NFS).

Types of volume in K8s
1. Ephemeral volume
   Its targeted to the application need to hold the data, but they don’t care about data loss in the case that the pod fails or restarts – the lifecycle of the ephemeral volume is aligned with the pod lifecycle. Several types of ephemeral volume

   - emptyDir (its an empty directory when pod start, pod stop/restart directory deleted permanently)
   - CSI Ephemeral volumes (Driver compatible volumes, provide external storage)
   - Generic Ephemeral volumes (its general drivers with some additional features available such as snapshotting, storage cloning, storage resizing, and storage capacity tracking)
   - Projected volumes (Configuration data is mounted to the Kubernetes pods – this data was injected into a pod through the sidecar pattern)
   
```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
   name: my-pv
spec:
   storageClassName: local-storage
   capacity:
      storage: 1Gi
   accessModes:
      - ReadWriteOnce
```

2. Persistent volume
   Its independent type of storage, means keeping some data or information to continue beyond the life of the container when the container is deleted or replaced. K8s allows us to work with persistent storage through the notion of persistent volumes and persistent volume claims:
   
   - Persistent Volume (PV)
     It is a storage resources provisioned dynamically based on the storage classes with a set of features to fulfill the user’s requirements.
   - Persistent Volume Claim (PVC)
     It is the abstraction layer between the pod and the PV requested by the user, with a set of requirements including the specific level of resources and the access modes.
As shown in the following, Figure, the PV and PVC are defined in the Kubernetes cluster, while the physical storage is outside of the Kubernetes cluster:
![Persistent volume](/img/volumes/persistent-volume.png)

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
   name: my-pvc
spec:
   storageClassName: local-storage
accessModes:
       - ReadWriteOnce
   resources:
     requests:
        storage: 512Mi
```


[The Storage Class](https://kubernetes.io/docs/concepts/storage/storage-classes/)
The StorageClass resource in Kubernetes classifies the Kubernetes storage class. As a matter of fact, a StorageClass contains a provisioner, parameters, and reclaimPolicy field. For example of different provisioners are ***Azure Disk***, ***AWS EBS***, and ***Glusterfs***.
![Storage class](/img/volumes/storage-class.png)

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: aws-ebs
provisioner: kubernetes.io/aws-ebs
parameters:
  type: gp2 # or io1, st1, sc1
  fsType: ext4 # or xfs
  encrypted: "true" # optional, if you want the EBS volume to be encrypted
  kmsKeyId: <your-kms-key-id> # optional, specify your KMS key ID for encryption
  iopsPerGB: "10" # optional, only for io1 type
  zone: us-west-2a # optional, specify the availability zone
reclaimPolicy: Retain # or Delete
allowVolumeExpansion: true # optional, allow volume expansion
mountOptions:
  - debug # optional, mount options for the filesystem
volumeBindingMode: Immediate # or WaitForFirstConsumer
```

Volume modes
It is indicate the type of consumption of the volume – this can either be a 
- ***filesystem*** or a (When volumeMode is set to Filesystem, it mounts into the pods as a directory)
- ***block device*** (When volumeMode is set to Block, we use it as a raw block)

Access modes
When a PV is mounted to a pod, we can specify different access modes. The access modes represent the way that the data in the storage resources is being consumed. They can be summarized as shown in the following table:
|  SL   | Access modes     | Abbreviated |
| :---: | :--------------- | :---------: |
|   1   | ReadWriteOnce    |     RWO     |
|   2   | ReadOnlyMany     |     ROX     |
|   3   | ReadWriteMany    |     RWX     |
|   4   | ReadWriteOncePod |    RWOP     |