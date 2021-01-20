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
/srv/nfs/kubedata  *(rw,sync,no_subtree_check,no_root_squash,no_all_squash,insecure)
# bash
sudo exportfs -rav
sudo exportfs -v
sudo showmount -e
```
# check nfs share
```bash
# check
ssh vagrant@172.18.8.102
sudo apt install nfs-kernel-server -y
sudo mkdir /home/data

# Gắn ổ đĩa
mount -t nfs 172.18.8.101:/srv/nfs/kubedata /home/data/

# Kiểm tra xong, hủy gắn ổ đĩa
umount /home/data
```