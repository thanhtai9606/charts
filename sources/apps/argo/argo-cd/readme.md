bash
```
# create namespace
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

#create ingress
kubectl apply -f 
kubectl apply -f sources/apps/argo/argo-cd/1.ingress.yml 
# get login password
username: admin
pwd: kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2
```