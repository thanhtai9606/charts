# create temaplte
helm create < create-name >

# check syntax template
helm lint . 
# view template 
helm template

# install helm
helm install -f .

helm install auth .

# heml upgrade
helm upgrade nginx-ingress bitnami/nginx-ingress-controller -f nginx-values.yaml

# set hostNetwork for access in localhost
hostNetwork: true

# rewrite for route
nginx.ingress.kubernetes.io/rewrite-target: /$1 #set rewrite


# merger kuber-context
not working
scp root@192.168.103.144:/etc/kubernetes/admin.conf ~/.kube/config-uat-cluster
# export config for 9ks
export KUBECONFIG=~/.kube/config

export KUBECONFIG=~/.kube/config:~/.kube/config-uat-cluster
kubectl config view --flatten > ~/.kube/config_temp
mv ~/.kube/config_temp ~/.kube/config

# references 
https://github.com/nhtua/charts

# test kube
kubectl apply -f https://k8s.io/examples/controllers/nginx-deployment.yaml


# create secret certs

kubectl create secret tls becamex-secret-cert --cert=./sources/certs/becamex.com.vn.crt --key=./sources/certs/becamex.com.vn.key

kubectl create -n becamex-xlnt-dev \
   secret generic nginx-ui-config \
   --from-file=./sources/certs/default.conf

# remove pv,pvc

kubectl patch pvc db-pv-claim -p '{"metadata":{"finalizers":null}}'
kubectl patch pod db-74755f6698-8td72 -p '{"metadata":{"finalizers":null}}'

# lưu ý ingress
```
đối với ingress phải chỉnh lại hostNetwork =true
```

```
* phải stop firewalld quan trọng
systemctl stop firewalld
```

# copt db & share app
```
scp -r ~/app/db/ becamex@192.168.103.146:/srv/nfs/kubedata/db
```
* share app
scp -r ~/app/kubernetes-deploy/pv-storage/ becamex@192.168.103.146:/srv/nfs/kubedata

* create ns
```
kubectl create ns xlnt
kubectl create ns nginx-ingress
kubectl create ns db-storage
kubectl create ns kubeapps
```

* test ingress
```bash
helm install nginx bitnami/nginx-ingress-controller -f sources/apps/nginx/4.nginx-values.yaml -n kubeapps

kubectl apply -f sources/nginx/1.app-test.yaml 

kubectl apply -f sources/nginx/2.app-test-ingress.yaml 
```

* install nginx kubeapps 

```bash
 helm install nginx bitnami/nginx-ingress-controller -f sources/apps/nginx/4.nginx-values.yaml -n kubeapps
 helm install kubeapps -n kubeapps bitnami/kubeapps -f sources/apps/dasboard-k8s/3.kube-apps.yaml
# create admin account
kubectl apply -f sources/apps/dasboard-k8s/1.admin-user.yaml 
# ingress dashboard
kubectl apply -f sources/apps/dasboard-k8s/4.ingress-dashboard.yaml
# get token
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```

* create dynamic volume
```
helm install nfs-client -n kubeapps stable/nfs-client-provisioner -f sources/apps/nfs-client-provisioner/nfs-client-provisioner-values.yaml

```

* create volume for db-storage
```
kubectl apply -f sources/volumes/4.db-strorage.yaml 
kubectl apply -f sources/volumes/5.app-share-storage.yaml

```
* create mssql 
```
helm install mssql -n kubeapps sources/apps/mssql/ -f sources/apps/mssql/values.yaml
```

set time dashboard
```bash
sửa deployment kubernetes-dashboard trong namespace kubernetes-dashboard
thêm arg sau
- --token-ttl=86400
```

* kubeapps create
```bash
# rabbitmq
helm install rabbitmq -n kubeapps bitnami/rabbitmq -f sources/apps/rabbitmq/rabbitmq-values.yaml 

```