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
scp -r ~/app/db/ root@172.16.10.2:/srv/nfs/kubedata
```
* share app
scp -r ~/app/kubernetes-deploy/pv-storage/ root@172.16.10.2:/srv/nfs/kubedata

* create ns
```
kubectl create ns xlnt
kubectl create ns nginx-ingress
kubectl create ns db-storage
```

* test ingress
```
helm install nginx bitnami/nginx-ingress-controller -f sources/nginx/4.nginx-values.yaml -n nginx-ingress

 kubectl apply -f sources/nginx/1.app-test.yaml 

kubectl apply -f sources/nginx/2.app-test-ingress.yaml 

```