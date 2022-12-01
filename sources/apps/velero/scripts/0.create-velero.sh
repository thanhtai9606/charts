#!/bin/sh
# revemo velero
# velero uninstall
bucket="velero"
tenant="prod"
base_dir=$(dirname $0)
velero install \
   --provider aws \
   --plugins velero/velero-plugin-for-aws:v1.5.2 \
   --bucket $bucket \
   --prefix $tenant \
   --use-volume-snapshots=false \
   --secret-file $base_dir/minio.credentials \
   --backup-location-config region=minio,s3ForcePathStyle="true",s3Url=http://192.168.103.167:9000
