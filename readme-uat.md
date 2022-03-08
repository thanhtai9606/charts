# create temaplte

helm create < create-name >

# check syntax template

helm lint .

# view template

helm template

# install helm

helm install -f .

helm install auth .

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


# remove pv,pvc

kubectl patch pvc pvc-pg-backup  -p '{"metadata":{"finalizers":null}}' -n kubeapps
kubectl patch pod db-74755f6698-8td72 -p '{"metadata":{"finalizers":null}}'
kubectl delete pod xx --grace-period=0 --force --namespace dwh

# copt db & share app

```
scp -r ~/app/db/ becamex@192.168.103.146:/srv/nfs/kubedata/db
```

- share app
  scp -r ~/app/kubernetes-deploy/pv-storage/ becamex@192.168.103.146:/srv/nfs/kubedata

- create ns


```bash
helm install nginx bitnami/nginx-ingress-controller -f sources/apps/nginx/bitnami-nginx-values-uat.yaml -n kubeapps
helm upgrade nginx bitnami/nginx-ingress-controller -f sources/apps/nginx/bitnami-nginx-values-uat.yaml -n kubeapps

kubectl apply -f sources/nginx/1.app-test.yaml
kubectl apply -f sources/nginx/2.app-test-ingress.yaml
```

- install nginx kubeapps

```bash
 # create secret ssl

  kubectl create -n kubeapps secret tls becamexidc-cert --key sources/certs/new-certs/pfx/becamex.com.vn.key --cert sources/certs/new-certs/cert/3.Certificate.cer
  kubectl delete -n kubeapps secret becamexidc-cert 
# old cert 1.19 kubectl apply -f sources/apps/nginx/5.secret-certificate.yaml
 helm uninstall nginx -n kubeapps
helm install nginx -n kubeapps nginx-stable/nginx-ingress -f sources/apps/nginx/nginx-values.yaml
helm upgrade nginx -n kubeapps nginx-stable/nginx-ingress -f sources/apps/nginx/nginx-values.yaml

helm install nginx -n kubeapps nginx/nginx-ingress-controller -f sources/apps/nginx/bitnami-nginx-values.yaml
helm upgrade nginx -n kubeapps bitnami/nginx-ingress-controller -f sources/apps/nginx/bitnami-nginx-values.yaml

helm install kubeapps -n kubeapps bitnami/kubeapps -f sources/apps/dasboard-k8s/3.kube-apps.yaml
# create admin account
kubectl apply -f sources/apps/dasboard-k8s/1.admin-user.yaml
# ingress dashboard
kubectl apply -f sources/apps/dasboard-k8s/4.ingress-dashboard.yaml
# get token
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
```

- create volume for db-storage

```
kubectl apply -f sources/volumes/4.db-strorage.yaml
kubectl apply -f sources/volumes/5.app-share-storage.yaml
```

- create mssql

```
helm install mssql -n kubeapps sources/apps/mssql/ -f sources/apps/mssql/values.yaml
```

set time dashboard

```bash
sửa deployment kubernetes-dashboard trong namespace kubernetes-dashboard
thêm arg sau
- --token-ttl=86400
```

- kubeapps create

````bash
# install nfs dynamic volume
add new repo first
# have been change from nfs-client-provisoner => nfs-subdir-external-provisioner
helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/

helm uninstall nfs-client -n kubeapps
helm install nfs-client -n kubeapps nfs-subdir-external-provisioner/nfs-subdir-external-provisioner -f sources/apps/nfs-client-provisioner/1.nfs-client-provisioner-values.yaml

# traefik
helm repo add traefik https://helm.traefik.io/traefik
# create ssl traefik
kubectl apply -n kubeapps -f sources/apps/traefik/000-tls-cert.yaml
helm uninstall traefik -n kubeapps
helm install traefik -n kubeapps traefik/traefik -f sources/apps/traefik/001.traefik-values.yaml
# chartmuseum
helm install chartmuseum -n kubeapps chartmuseum/chartmuseum -f sources/apps/chartmuseum/1.chartmuseum-values.yaml
helm upgrade chartmuseum -n kubeapps chartmuseum/chartmuseum -f source/app/chartmuseum/1.chartmuseum-values.yaml

# rabbitmq
helm uninstall rabbitmq -n kubeapps
helm install rabbitmq -n kubeapps bitnami/rabbitmq -f sources/apps/rabbitmq/1.rabbitmq-values.yaml

# postgres sql
# create pvc first
kubectl apply -f sources/postgresql/000-postgresql-pvc.yaml
helm install postgres -n kubeapps bitnami/postgresql -f sources/apps/postgresql/1.postgresql-values.yaml

# create backup postgresql db
kubectl apply -f source/app/postgres/001-postgres-backup-secret,yaml
kubectl apply -f source/app/postgres/002-create-pvc.yaml
kubectl apply -f source/app/postgres/999-cronjob-backup-pg.yaml

# mariadb sql
# create pvc first
kubectl apply -f sources/apps/mysql/000-mariadb-pvc.yaml

# metallb
helm repo add metallb https://metallb.github.io/metallb
helm install metallb -n kubeapps metallb/metallb -f sources/apps/metallb/metallb-values-uat.yaml
helm upgrade metallb -n kubeapps metallb/metallb -f sources/apps/metallb/metallb-values-uat.yaml
helm uninstall metallb -n kubeapps

#mongodb

helm install mongodb -n kubeapps bitnami/mongodb -f sources/apps/mongo/1.mongodb-values.yaml
helm upgrade mongodb -n kubeapps bitnami/mongodb -f sources/apps/mongo/1.mongodb-values.yaml

helm uninstall -n kubeapps mariadb
helm install mariadb -n kubeapps bitnami/mariadb -f sources/apps/mysql/1.mariadb-values.yaml

# phpmyadmin
helm install phpmyadmin -n kubeapps bitnami/phpmyadmin -f sources/apps/mysql/3.phpmyadmin-values.yaml
helm uninstall phpmyadmin -n kubeapps
# pgadmin
helm repo add cetic https://cetic.github.io/helm-charts
helm repo update

helm uninstall pgadmin -n kubeapps
helm install pgadmin -n kubeapps cetic/pgadmin -f sources/apps/postgresql/2.pgadmin-values.yaml

# redmine
# create pvc manual
kubectl apply -f sources/apps/redmine/000-redmine-pvc.yaml

helm uninstall redmine  -n kubeapps
helm install redmine -n kubeapps sources/apps/redmine/ -f sources/apps/redmine/1.redmine-values.yaml
helm upgrade redmine -n kubeapps sources/apps/redmine/ -f sources/apps/redmine/1.redmine-values.yaml


# wordpress
helm uninstall wordpress  -n kubeapps
helm install wordpress -n kubeapps bitnami/wordpress -f sources/apps/wordpress/1.wordpress-values.yaml

# discourse
helm uninstall discourse  -n kubeapps
helm install discourse -n kubeapps bitnami/discourse -f sources/apps/discourse/1.discourse-values.yaml
# elasticsearch bitnami/elasticsearch
helm uninstall elasticsearch  -n kubeapps
helm install elasticsearch -n kubeapps bitnami/elasticsearch -f sources/apps/elasticsearch/1.elasticsearch-values.yaml

# camunda
helm repo add camunda https://helm.camunda.cloud
kubectl apply -f sources/apps/camunda/2.secret.yaml
helm uninstall camunda -n kubeapps
# removed helm install camunda -n kubeapps camunda/camunda-bpm-platform -f sources/apps/camunda/1.camunda-values.yaml
 helm install camunda -n kubeapps sources/apps/camunda/camunda-bpm-platform/ -f sources/apps/camunda/camunda-bpm-platform/values.yaml
 helm upgrade camunda -n kubeapps sources/apps/camunda/camunda-bpm-platform/ -f sources/apps/camunda/camunda-bpm-platform/values.yaml

# kibana
helm uninstall kibana  -n kubeapps
# helm install kibana -n kubeapps bitnami/kibana -f sources/apps/elasticsearch/2.kibana-values.yaml
helm install kibana -n kubeapps sources/my-apps/kibana -f sources/my-apps/kibana/values.yaml
# remove by logstash
kubectl apply -f sources/apps/opendistro/4.job-remove-log.yaml

# fluentd
helm uninstall fluentd  -n kubeapps
helm install fluentd -n kubeapps bitnami/fluentd -f sources/apps/elasticsearch/3.fluentd-values.yaml

# kong
helm uninstall kong  -n kubeapps
helm install kong -n kubeapps bitnami/kong -f sources/apps/kong/1.kong-values.yaml
helm install kong -n kubeapps sources/apps/kong/ -f sources/apps/kong/values.yaml

#open-distro Have to delete storage in server first
# install nfs-elastic
helm uninstall nfs-elastic -n kubeapps
helm install nfs-elastic -n kubeapps nfs-subdir-external-provisioner/nfs-subdir-external-provisioner -f sources/apps/nfs-client-provisioner/2.nfs-elastic-provisioner-values.yaml
helm upgrade nfs-elastic -n kubeapps  nfs-subdir-external-provisioner/nfs-subdir-external-provisioner -f sources/apps/nfs-client-provisioner/2.nfs-elastic-provisioner-values.yaml

# add repo becamexidc
helm repo add becamex https://chart.becamex.com.vn 
helm repo update

# second way if not package
helm uninstall opendistro  -n kubeapps
helm install opendistro -n kubeapps becamex/opendistro-es -f sources/apps/opendistro/1.opendistro-values.yaml
helm upgrade opendistro -n kubeapps becamex/opendistro-es -f sources/apps/opendistro/1.opendistro-values.yaml
# after install opendistro, haveto install fluentbit for logstash in kibana

#install fulentbit
helm uninstall fluentbit  -n kubeapps
helm install fluentbit -n kubeapps fluent/fluent-bit -f sources/apps/fluentbit/6.fluent-bit-values.yaml
helm upgrade fluentbit -n kubeapps fluent/fluent-bit -f sources/apps/fluentbit/6.fluent-bit-values.yaml
# second ways
 kubectl create namespace logging
 kubectl apply -f sources/apps/fluentbit/1.fluent-bit-service-account.yaml
 kubectl apply -f sources/apps/fluentbit/2.fluent-bit-role.yaml
 kubectl apply -f sources/apps/fluentbit/3.fluent-bit-role-binding.yaml
 kubectl apply -f sources/apps/fluentbit/4.fluent-bit.configmap.yaml
 kubectl apply -f sources/apps/fluentbit/5.fluent-bit-ds.yaml
 
# filebeat
helm uninstall filebeat  -n kubeapps
helm install filebeat -n kubeapps elastic/filebeat -f sources/apps/opendistro/2.filebeat-values.yaml

# longhorn
helm repo add longhorn https://charts.longhorn.io
helm repo update
helm install longhorn longhorn/longhorn -f sources/apps/longhorn/1.longhorn-value.yaml --namespace longhorn-system --create-namespace
helm upgrade longhorn longhorn/longhorn -f sources/apps/longhorn/1.longhorn-value.yaml --namespace longhorn-system --create-namespace

# logstash
helm uninstall logstash  -n kubeapps
helm install logstash -n kubeapps elastic/logstash -f sources/apps/opendistro/3.logstash-values.yaml

# minioi
helm uninstall minio  -n kubeapps
helm install minio -n kubeapps bitnami/minio -f sources/apps/minio/1.minio-bitnami-values.yaml
helm upgrade minio -n kubeapps bitnami/minio -f sources/apps/minio/1.minio-bitnami-values.yaml


helm install minio -n kubeapps minio/minio -f sources/apps/minio/2.minio-values.yaml
helm upgrade minio -n kubeapps minio/minio -f sources/apps/minio/2.minio-values.yaml
#fluentbit
# add helm char
helm repo add fluent https://fluent.github.io/helm-charts
```bash
# create root-ca.pem first
# create file root-ca.pem
kubectl exec -it -n kubeapps opendistro-opendistro-es-client-5fd4987d56-8jhlx cat /usr/share/elasticsearch/config/root-ca.pem > es-root-ca.pem
# check root-ca.pem
cat es-root-ca.pem

# create secret es-root-ca -n kubeapps
kubectl delete secret es-root-ca -n kubeapps
kubectl create secret generic es-root-ca --from-file=es-root-ca.pem -n kubeapps

# create secret es-root-ca
kubectl delete secret es-root-ca -n logging
kubectl create secret generic es-root-ca --from-file=es-root-ca.pem -n logging

# metric server
 kubectl apply -f sources/apps/metric-server/metric-server.yaml
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

#k10
 helm repo add kasten https://charts.kasten.io/
 helm install k10 -n kasten-io kasten/k10 -f sources/apps/k10/k10-values.yaml
 helm upgrade k10 -n kasten-io kasten/k10 -f sources/apps/k10/k10-values.yaml
 helm uninstall k10 -n kasten-io
````

# kibana

helm uninstall sws -n kubeapps
helm install sws -n kubeapps bitnami/odoo -f sources/apps/odoo/1.odoo-values.yaml

# rancher

helm uninstall rancher -n kubeapps
helm install rancher -n kubeapps rancher-latest/rancher -f sources/apps/rancher/rancher-values.yaml

helm upgrade rancher -n kubeapps rancher-latest/rancher -f sources/apps/rancher/rancher-values.yaml

# install flutter + android studio

1. install android studio on repository arch
2. install flutter in repository
3. fix sdk tools chain not validate in flutter doctor
   a. sudo flutter config --android-sdk ~/Android/Sdk
   b. argee sdk license => Open Android Studio => File => Settings => Search Android SDK => Tab SDK Tools => check Android SDK Command \_line Tools => apply
   ```
   sudo flutter doctor --android-licenses
   ```
   b. google chrome not valid
   ```
   sudo ln -s /usr/bin/google-chrome-stable /usr/local/bin/google-chrome
   ```

#delete all pods Failed
kubectl delete pods --field-selector status.phase=Failed -n dwh

# delete namespace is stuck

kubectl get namespace "cattle-system" -o json \
 | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" \
 | kubectl replace --raw /api/v1/namespaces/cattle-system/finalize -f -

```

```

# reset new Cert K8s

kubeadm alpha certs renew all

kubeadm alpha certs check-expiration

https://programmer.help/blogs/how-to-use-kubeadm-to-manage-certificates.html

```

```
