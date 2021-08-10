# 1 chạy postgresl hoặc có thể dùng H2 db bên trong camunda và tạo database trước proccess-engine

# 2. sau khi chạy xog phải chạy file 2.secret.yaml trước
kubectl apply -f sources/apps/camunda/2.secret.yaml

# 3. sau đó chay lệnh 
helm uninstall camunda -n kubeapps 
helm install camunda -n kubeapps camunda/camunda-bpm-platform -f sources/apps/camunda/1.camunda-values.yaml


