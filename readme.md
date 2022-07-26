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
# add repo stable and bitnami
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add stable https://charts.helm.sh/stable

 # create secret ssl
 kubectl apply -f sources/apps/nginx/5.secret-certificate.yaml 
 helm upgrade nginx bitnami/nginx-ingress-controller -f sources/apps/nginx/4.nginx-values.yaml -n kubeapps
 helm install kubeapps -n kubeapps bitnami/kubeapps -f sources/apps/dasboard-k8s/3.kube-apps.yaml

 # create dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml 
# create admin account
kubectl apply -f sources/apps/dasboard-k8s/1.admin-user.yaml 
# ingress dashboard
kubectl apply -f sources/apps/dasboard-k8s/4.ingress-dashboard.yaml
# get token
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```
# add repo bitnami & stable
```
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add stable https://charts.helm.sh/stable
```
* create dynamic volume
```
helm uninstall nfs-client -n kubeapps
helm install nfs-client -n kubeapps stable/nfs-client-provisioner -f sources/apps/nfs-client-provisioner/nfs-client-provisioner-values.yaml

```
* #create nginx ingress
helm install nginx bitnami/nginx-ingress-controller -f sources/apps/nginx/4.nginx-values.yaml -n kubeapps
helm install nginx bitnami/nginx -f sources/apps/nginx/6.nginx-values.yaml -n kubeapps
helm uninstall nginx -n kubeapps
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

# metaLB LoadBalancer ko phải nguyên nhân chính đâu
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml
# On first install only
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"

kubectl apply -f sources/apps/metalb/1.metab.yaml 

# install kubeapp

helm uninstall kubeapp -n kubeapps
helm install kubeapp -n kubeapps bitnami/kubeapps -f sources/apps/kubeapps/1.kubeapp-values.yaml 

# nfs client
helm uninstall nfs-client -n kubeapps
# nfs server
# helm uninstall nfs-server -n kubeapps
# helm install nfs-server -n kubeapps stable/nfs-server-provisioner -f sources/apps/nfs-client-provisioner/3.nfs-server-provisioner.yaml 

# rabbitmq
helm uninstall rabbitmq -n kubeapps 
helm install rabbitmq -n kubeapps bitnami/rabbitmq -f sources/apps/rabbitmq/1.rabbitmq-values.yaml 


# rabbitmq
helm uninstall keycloak -n kubeapps 
helm install keycloak -n kubeapps bitnami/keycloak -f sources/apps/keycloak/1.keycloak-values.yaml 

# argo-workflows
helm uninstall argo-workflows -n kubeapps 
helm install argo-workflows -n kubeapps bitnami/argo-workflows -f sources/apps/argo-workflows/1.argo-workflows-values.yaml 
helm upgrade argo-workflows -n kubeapps bitnami/argo-workflows -f sources/apps/argo-workflows/1.argo-workflows-values.yaml 

# postgres sql
helm uninstall postgres -n kubeapps 
helm install postgres -n kubeapps bitnami/postgresql -f sources/apps/postgresql/1.postgresql-values.yaml 
# pgadmin
helm uninstall pgadmin -n kubeapps 
helm install pgadmin -n kubeapps cetic/pgadmin -f sources/apps/postgresql/2.pgadmin-values.yaml

# camunda
kubectl apply -f sources/apps/camunda/2.secret.yaml
helm uninstall camundadev -n kubeapps 
helm install camundauat -n kubeapps camunda/camunda-bpm-platform -f sources/apps/camunda/1.camunda-values.yaml

# redmine
helm uninstall redmine  -n kubeapps 
helm install redmine -n kubeapps sources/apps/redmine/ -f sources/apps/redmine/1.redmine-values.yaml

# wordpress
helm uninstall wordpress  -n kubeapps 
helm install wordpress -n kubeapps bitnami/wordpress -f sources/apps/wordpress/1.wordpress-values.yaml

# discourse
helm uninstall discourse  -n kubeapps 
helm install discourse -n kubeapps bitnami/discourse -f sources/apps/discourse/1.discourse-values.yaml 

# elasticsearch bitnami/elasticsearch
helm uninstall elasticsearch  -n kubeapps 
helm install elasticsearch -n kubeapps bitnami/elasticsearch -f sources/apps/elasticsearch/1.elasticsearch-values.yaml 

# kibana 
helm uninstall kibana  -n kubeapps 
# helm install kibana -n kubeapps bitnami/kibana -f sources/apps/elasticsearch/2.kibana-values.yaml 
helm install kibana -n kubeapps sources/my-apps/kibana -f sources/my-apps/kibana/values.yaml

#fluentd 
helm uninstall fluentd  -n kubeapps 
helm install fluentd -n kubeapps bitnami/fluentd -f sources/apps/elasticsearch/3.fluentd-values.yaml 

#open-distro Have to delete storage in server first
# first way
helm package sources/apps/opendistro-build/helm/opendistro-es/ #Package open-distro or no need package
helm install opendistro -n kubeapps opendistro-es-1.13.2.tgz  # if we're package it

# second way if not package
helm uninstall opendistro  -n kubeapps 
helm install opendistro -n kubeapps sources/apps/opendistro-build/helm/opendistro-es/ -f sources/apps/opendistro-build/helm/opendistro-es/values.yaml
helm upgrade opendistro -n kubeapps sources/apps/opendistro-build/helm/opendistro-es/ -f sources/apps/opendistro-build/helm/opendistro-es/values.yaml


#fluentbit
# add helm char
helm repo add fluent https://fluent.github.io/helm-charts
```bash
# create root-ca.pem first
# create file root-ca.pem
kubectl exec -it -n kubeapps opendistro-opendistro-es-client-5fd4987d56-8jhlx cat /usr/share/elasticsearch/config/root-ca.pem > es-root-ca.pem
# check root-ca.pem
cat es-root-ca.pem
# create secret es-root-ca
kubectl delete secret es-root-ca -n kubeapps
kubectl create secret generic es-root-ca --from-file=es-root-ca.pem -n kubeapps

#install fulentbit
helm uninstall fluentbit  -n kubeapps 
helm install fluentbit -n kubeapps fluent/fluent-bit -f sources/apps/fluentbit/fluentbit-values.yaml
helm upgrade fluentbit -n kubeapps fluent/fluent-bit -f sources/apps/fluentbit/fluentbit-values.yaml
# second ways
 kubectl create namespace logging
 kubectl apply -f sources/apps/fluentbit/1.fluent-bit-service-account.yaml
 kubectl apply -f sources/apps/fluentbit/2.fluent-bit-role.yaml 
 kubectl apply -f sources/apps/fluentbit/3.fluent-bit-role-binding.yaml
 kubectl apply -f sources/apps/fluentbit/4.fluent-bit.configmap.yaml
 kubectl apply -f sources/apps/fluentbit/5.fluent-bit-ds.yaml
```

# mysql
helm uninstall mysql  -n kubeapps 
helm install mysql -n kubeapps bitnami/mysql -f sources/apps/mysql/2.mysql-values.yaml 

# mariadb
helm uninstall mariadb  -n kubeapps 
helm install mariadb -n kubeapps bitnami/mariadb -f sources/apps/mysql/1.mariadb-values.yaml 

# redis
helm uninstall redis  -n kubeapps 
helm install redis -n kubeapps bitnami/redis -f sources/apps/redis/1.redis-values.yaml 

# phpmyadmin
helm uninstall myadmin  -n kubeapps 
helm install phpmyadmin -n kubeapps bitnami/phpmyadmin -f sources/apps/mysql/3.phpmyadmin-values.yaml 
helm upgrade phpmyadmin -n kubeapps bitnami/phpmyadmin -f sources/apps/mysql/3.phpmyadmin-values.yaml 

# konga
helm uninstall konga  -n kubeapps 
helm install konga -n kubeapps sources/apps/konga/ -f sources/apps/konga/values.yaml 

# racher
```
#remove message unhealthy in master 
sed -i 's|- --port=0|#- --port=0|' /etc/kubernetes/manifests/kube-scheduler.yaml
sed -i 's|- --port=0|#- --port=0|' /etc/kubernetes/manifests/kube-controller-manager.yaml
systemctl restart kubelet

```

# kong
helm uninstall kong  -n kubeapps 
# with bitnami
helm install kong -n kubeapps sources/apps/kong -f sources/apps/kong/values.yaml 
helm upgrade kong -n kubeapps sources/apps/kong -f sources/apps/kong/values.yaml 

# with kong

helm repo add kong https://charts.konghq.com
helm repo update
helm install kong -n kubeapps kong/kong -f sources/apps/kong/1.kong-values.yaml 
helm uninstall kong -n kubeapps
helm upgrade kong -n kubeapps kong/kong -f sources/apps/kong/1.kong-values.yaml 

# delete namespace is stuck

kubectl get namespace "esign-dev" -o json \
  | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" \
  | kubectl replace --raw /api/v1/namespaces/esign-dev/finalize -f -
```

```
# reset new Cert K8s
kubeadm alpha  certs renew all

kubeadm alpha certs check-expiration
https://programmer.help/blogs/how-to-use-kubeadm-to-manage-certificates.html
```
