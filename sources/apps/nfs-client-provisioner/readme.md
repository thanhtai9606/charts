```bash
# create pvc hostpath
kubectl delete -f sources/apps/nfs-client-provisioner/1.pvc-hostpath.yml 
kubectl apply -f sources/apps/nfs-client-provisioner/1.pvc-hostpath.yml 
# create sample pvc 
kubectl delete -f sources/apps/nfs-client-provisioner/2.sample-busybox.yaml 
kubectl apply -f sources/apps/nfs-client-provisioner/2.sample-busybox.yaml 
```