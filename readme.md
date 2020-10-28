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