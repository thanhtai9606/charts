# Kiểm tra các lần cập nhật của deployment

kubectl rollout history deploy deployapp

# Coi chi tiết các lần cập nhật
kubectl rollout history deploy deployapp --revision=2


# rollback lại revision trước đó
kubectl rollout undo deployment/deployapp --to-revision=2

# manual scale replicaset in deployment
kubectl scale deploy/deployapp --replicas=10

# auto scale
kubectl autoscale deploy/deployapp --min=3 --max=8 
# hoặc chạy trong file 2.hpa.yaml


# tự xác thực ssl
openssl req -nodes -newkey rsa:2048 -keyout tls.key  -out ca.csr -subj "/CN=dunglt.net"
openssl x509 -req -sha256 -days 365 -in ca.csr -signkey tls.key -out tls.crt


# Tạo Secret tên secret-nginx-cert chứa các xác thực
# Thi hành lệnh sau để tạo ra một Secret (loại ổ đĩa chứa các thông tin nhạy cảm, nhỏ), Secret này kiểu tls, tức chứa xác thức SSL

kubectl create secret tls secret-nginx-cert --cert=certs/tls.crt  --key=certs/tls.key
# Secret này tạo ra thì mặc định nó đặt tên file là tls.crt và tls.key có thể xem với lệnh

kubectl describe secret/secret-nginx-cert


# cho phép node master cũng được triển khai dịch vụ và các pod
kubectl taint node master.xtl node-role.kubernetes.io/master-



# Tham khảo: Cài NFS trên CentOS

yum install nfs-utils
systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-lock
systemctl enable nfs-idmap
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-lock
systemctl start nfs-idmap

# Tạo export
vi /etc/exports

/data/mydata  *(rw,sync,no_subtree_check,insecure)
# Lưu thông lại, và thực hiện

# Tạo thư mục
mkdir -p /data/mydata
chmod -R 777 /data/mydata

# export và kiểm tra cấu hình chia sẻ
exportfs -rav
exportfs -v
showmount -e

# Khởi động lại và kiểm tra dịch vụ
systemctl stop nfs-server
systemctl start nfs-server
systemctl status nfs-server

```
Check share nfs between servers
```

mount -t nfs 172.16.10.2:/srv/nfs/kubedata /mnt
mount | grep kubedata
