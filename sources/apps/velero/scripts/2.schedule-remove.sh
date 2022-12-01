#!/bin/sh
#!/bin/sh
# sample script 
# velero schedule delete --all

# Color
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

namespace_array=(microservice becamex-apps-dev)
echo -e "${YELLOW}===== Begin remove schedule =====${NC}"
for i in ${namespace_array[@]}
do
   velero schedule delete schedule-$i
   echo "Y"
   echo -e "${GREEN}***** Deleting schedule for namespace #$i *****${NC}"
done
 echo -e "${YELLOW}===== ALL COMPLETED =====${NC}"

