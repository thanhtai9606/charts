# Install pgadmin
```bash
helm uninstall pgadmin -n kubeapps 
helm install pgadmin -n kubeapps stable/pgadmin -f sources/apps/postgresql/2.pgadmin-values.yaml 
```