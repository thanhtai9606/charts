# install cert manager first
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest

kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/00-crds.yaml
```bash
# install rancher
helm uninstall rancher -n kubeapps
helm install rancher -n kubeapps rancher-latest/rancher -f sources/apps/rancher/rancher-values.yaml 
```