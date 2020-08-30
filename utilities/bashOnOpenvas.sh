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
sudo docker exec -it openvas10-test bash
