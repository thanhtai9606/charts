#!/bin/sh
# sample script 
# velero schedule create ns-schedule --schedule="@every 1d" --include-namespaces microservice
# Color
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

namespace_array=(argocd becamex-apps becamex-crm-prod becamex-digimaps becamex-eiu becamex-hospital becamex-xlnt customer-portal dwh esign gis kubeapps)
cron_job="@every 1d"
echo -e "${YELLOW}===== Begin make Schedule =====${NC}"
for i in ${namespace_array[@]}
do
  # echo $cron_job $i
   velero schedule create schedule-$i --schedule="$cron_job" --include-namespaces $i
   echo -e "${GREEN}***** Making schedule for namespace #$i *****${NC}"
done
 echo -e "${YELLOW}===== ALL COMPLETED =====${NC}"
