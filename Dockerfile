#
# A3 SYSTEM sprl-bvba
# All rights reserved 2006-2020, A3-SYSTEM sprl-bvba
# Based on https://kifarunix.com/install-openvas-10-gvm-on-debian-10-buster/

FROM debian:buster

LABEL maintainer=Thomas.Smets@a3-system.eu

ENV DEBUG=True
ENV DEBIAN_FRONTEND noninteractive

RUN apt update && \
    apt upgrade && \
    apt install -y bison cmake gcc gcc-mingw-w64 heimdal-dev libgcrypt20-dev libglib2.0-dev libgnutls28-dev libgpgme-dev libhiredis-dev libksba-dev libmicrohttpd-dev git libpcap-dev libpopt-dev libsnmp-dev libsqlite3-dev libssh-gcrypt-dev xmltoman libxml2-dev perl-base pkg-config python3-paramiko python3-setuptools uuid-dev curl redis doxygen libical-dev python-polib gnutls-bin  wget  vim nano xsltproc texlive-latex-base texlive-latex-extra rsync \
    -yq --no-install-recommends

# Install Yarn JavaScript package manager
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt update
RUN apt install -y yarn

# You can confirm the required dependencies for each module on the INSTALL.md file on the source code directory.
# Download Greenborne Vulnerability Manager Source code

# Installation of OpenVAS 10 (GVM 10) on Debian 10 Buster involves building different modules from the source code.
# Hence, run the commands below to download the source code of each module required to build OpenVAS 10 (Greenborne Vulnerability Manager).

# Create a temporary directory to store source codes.

RUN mkdir -pv /tmp/gvm10
WORKDIR /tmp/gvm10

# Download GVM Libraries
RUN wget https://github.com/greenbone/gvm-libs/archive/v10.0.1.tar.gz          -O gvm-libs-v10.0.1.tar.gz

# Download OpenVAS Scanner
RUN wget https://github.com/greenbone/openvas/archive/v6.0.1.tar.gz            -O openvas-scanner-v6.0.1.tar.gz

# Download Greenborne Vulnerability Manager (GVM)
RUN wget https://github.com/greenbone/gvmd/archive/v8.0.1.tar.gz               -O gvm-v8.0.1.tar.gz

# Download Greenborne Security Assistant (GSA)
RUN wget https://github.com/greenbone/gsa/archive/v8.0.1.tar.gz                -O gsa-v8.0.1.tar.gz

# Download Open Scanner Protocol Daemon (OSPd)
RUN wget https://github.com/greenbone/ospd/archive/v1.3.2.tar.gz               -O ospd-v1.3.2.tar.gz

# Download OpenVAS SMB
RUN wget https://github.com/greenbone/openvas-smb/archive/v1.0.5.tar.gz        -O openvas-smp-v1.0.5.tar.gz

# Check
RUN ls -la

# Extract the OpenVAS 10 (GVM) Source Codes
# Next extract the source codes to current directory.
RUN for i in *.tar.gz; do tar xzf $i; done

# Check
RUN ls -la

# Build and Install GVM Libraries
WORKDIR /tmp/gvm10/gvm-libs-10.0.1
RUN     mkdir build
WORKDIR /tmp/gvm10/gvm-libs-10.0.1/build
RUN     cmake ..
RUN     make
RUN     make install

# Build and Install OpenVAS SMB
WORKDIR /tmp/gvm10/openvas-smb-1.0.5
RUN     mkdir build
WORKDIR /tmp/gvm10/openvas-smb-1.0.5/build
RUN     cmake ..
RUN     make
RUN     make install

# Build and Install OSPd
WORKDIR /tmp/gvm10/ospd-1.3.2
RUN     python3 setup.py install

# Build and Install OpenVAS Scanner
WORKDIR /tmp/gvm10/openvas-6.0.1
RUN     mkdir build
WORKDIR /tmp/gvm10/openvas-6.0.1/build
RUN     cmake ..
RUN     make
RUN     make install

# Configure Redis Server
# ########################
# To improve the performance of Redis server, make the following configurations.
#
#    Increase the value of somaxconn in order to avoid slow clients connections issues.
RUN echo "net.core.somaxconn = 1024"  >> /etc/sysctl.conf
#    Redis background save may fail under low memory condition. To avoid this, enable memory overcommit (man 5 proc).
RUN echo 'vm.overcommit_memory = 1' >> /etc/sysctl.conf
#    To avoid creation of latencies and memory usage issues with Redis, disable Linux Kernel’s support for Transparent Huge Pages (THP).
#    To easily work around this, create a systemd service unit for this purpose.

COPY ./etc /etc

RUN mv /etc/redis/redis.conf /etc/redis/redis.conf.bak
RUN cp -vf /tmp/gvm10/openvas-6.0.1/build/doc/redis_config_examples/redis_4_0.conf  /etc/redis/redis.conf










ENV BUILD=""

CMD [ bash ]

EXPOSE 443 9390