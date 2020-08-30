#! /usr/bin/env bash
#
# A3 SYSTEM sprl-bvba
# All rights reserved 2006-2020, A3-SYSTEM sprl-bvba
# ##############################################################################################################################################

#    .---------- constant part!
#    vvvv vvvv-- the code from above
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

set -v
set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

sudo printf "${GREEN}Building the django Docker & the NGINX \n**********************************************************************  ${NC}\n"


BUILD_FILE=Dockerfile-basicDebian

if [ -f ${BUILD_FILE} ]
then
    sudo docker build -f ${BUILD_FILE}   -t builddebian-test  .
    RET_CODE=$?
    echo "Return code captured"
    if [ $RET_CODE -eq 0 ];
    then
        printf "Building the django Docker : ${GREEN} OK ${NC}\n"
    else
        printf "${RED}Building the django Docker : NOT OK ${NC}\n"
        exit ${RET_CODE}
    fi
else
    printf "${RED}Building the django Docker. File is missing ${BUILD_FILE}  ${NC}\n"
    exit 1
fi




# END of file
