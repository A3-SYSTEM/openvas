#! /usr/bin/env bash
# 
# This has been build based on the site : https://kifarunix.com/install-openvas-10-gvm-on-debian-10-buster/



#    .---------- constant part!
#    vvvv vvvv-- the code from above
RED='\033[0;31m'
NC='\033[0m' # No Color
GREEN='\033[0;32m'

set -x
set -v

NOW=`date +%Y %m %d %H:%M:%S`
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
sudo printf "Now is : ${GREEN}${NOW}${NC}"

NOW=`date +%Y-%m-%d-%H-%M-%S`

apt update
apt upgrade 

apt install -yq bison cmake gcc gcc-mingw-w64 heimdal-dev libgcrypt20-dev libglib2.0-dev libgnutls28-dev libgpgme-dev libhiredis-dev libksba-dev libmicrohttpd-dev git libpcap-dev libpopt-dev libsnmp-dev libsqlite3-dev libssh-gcrypt-dev xmltoman libxml2-dev perl-base pkg-config python3-paramiko python3-setuptools uuid-dev curl redis doxygen libical-dev python-polib gnutls-bin  wget  vim nano xsltproc texlive-latex-base texlive-latex-extra rsync

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

apt update
apt install -y yarn

# Create a temporary directory to store source codes.
mkdir /tmp/gvm10
cd /tmp/gvm10

# Download GVM Libraries
wget https://github.com/greenbone/gvm-libs/archive/v10.0.1.tar.gz -O gvm-libs-v10.0.1.tar.gz

# Download OpenVAS Scanner
wget https://github.com/greenbone/openvas/archive/v6.0.1.tar.gz -O openvas-scanner-v6.0.1.tar.gz 

wget https://github.com/greenbone/gvmd/archive/v8.0.1.tar.gz -O gvm-v8.0.1.tar.gz

# Download Greenborne Security Assistant (GSA)
wget https://github.com/greenbone/gsa/archive/v8.0.1.tar.gz -O gsa-v8.0.1.tar.gz

# Download Open Scanner Protocol Daemon (OSPd)
wget https://github.com/greenbone/ospd/archive/v1.3.2.tar.gz -O ospd-v1.3.2.tar.gz

# Download OpenVAS SMB
wget https://github.com/greenbone/openvas-smb/archive/v1.0.5.tar.gz -O openvas-smp-v1.0.5.tar.gz

# You should now have at least 5 major components source codes;
ls -la

for i in *.tar.gz; do tar xzf $i; done

# Build and Install GVM Libraries
cd gvm-libs-10.0.1/
mkdir build
cd build/
cmake ..
make
make install

# Build and Install OpenVAS SMB
cd /tmp/gvm10/openvas-smb-1.0.5
mkdir build
cd build
cmake ..
make
make install

# Build and Install OSPd
cd /tmp/gvm10/ospd-1.3.2
python3 setup.py install

# Build and Install OpenVAS Scanner
cd /tmp/gvm10/openvas-6.0.1/
mkdir build
cd build
cmake ..
make
make install


# Configure Redis Server
# ######################
# To improve the performance of Redis server, make the following configurations.
#
#     Increase the value of somaxconn in order to avoid slow clients connections issues.
#
echo "net.core.somaxconn = 1024"  >> /etc/sysctl.conf

#    Redis background save may fail under low memory condition. To avoid this, enable memory overcommit (man 5 proc).
echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf

#    To avoid creation of latencies and memory usage issues with Redis, disable Linux Kernel’s support for Transparent Huge Pages (THP). 
#    To easily work around this, create a systemd service unit for this purpose.




