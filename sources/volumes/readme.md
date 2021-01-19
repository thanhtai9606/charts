# install nfs
```bash
sudo apt install nfs-kernel-server -y

sudo mkdir -p /srv/nfs/kubedata
sudo chown nobody: /srv/nfs/kubedata
sudo chmod -R 777 /srv/nfs/kubedata
sudo systemctl start nfs-server
```
# create vim nfs
```bash
sudo vim /etc/exports
/srv/nfs/kubedata  *(rw,sync,no_subtree_check,insecure)
# bash
sudo exportfs -rav
sudo exportfs -v
sudo showmount -e
```