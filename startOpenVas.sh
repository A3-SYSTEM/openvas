#! /usr/bin/env bash

#    .---------- constant part!
#    vvvv vvvv-- the code from above
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

set -x
set -v

NOW=`date +%Y-%m-%d-%H-%M-%S`
sudo printf "Now is : ${GREEN}${NOW}${NC}"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DATA_DIR=${DIR}/data

if [ -f ${DIR}/config/params.sh ] 
then
	source ${DIR}/config/params.sh
	printf "Parameter file loaded correctly.\n"
	# TODO check the parameters are ok
else
	printf "${RED}No parameter file found.\n \n \n ${NC}"	
	exit 1
fi

printf "Data directory (${DATA_DIR}) : "
if [ -d ${DATA_DIR} ]
then
	printf "${GREEN}exists${NC} \n"
else
	mkdir -p ${DATA_DIR}
	printf "${GREEN}Has been created${NC}"
fi


sudo docker run -d -p 443:443 -e PUBLIC_HOSTNAME=${PUBLIC_HOSTNAME} -v ${DATA_DIR}:/var/lib/openvas/mgr/ -e OV_PASSWORD=${OV_PASSWORD} --name ${IMAGE_NAME} mikesplain/openvas
