# install cert manager first
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.6/deploy/manifests/00-crds.yaml
```bash
# install rancher
helm install rancher -n kubeapps rancher-latest/rancher -f sources/apps/rancher/rancher-values.yaml 

# run in docker local
docker run -d --restart=unless-stopped \
  --name rancher \
  -p 80:80 -p 443:443 \
  --privileged \
  rancher/rancher:latest
```