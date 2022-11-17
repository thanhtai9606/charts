```
SECRET=$(kubectl get sa argo-workflows-server -n argocd -o=jsonpath='{.secrets[0].name}')
ARGO_TOKEN="Bearer $(kubectl get secret $SECRET -n argocd -o=jsonpath='{.data.token}' | base64 -d)"
echo "$ARGO_TOKEN"
```
