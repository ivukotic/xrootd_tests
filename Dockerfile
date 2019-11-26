FROM rucio/rucio-clients:latest

LABEL maintainer Ilija Vukotic <ivukotic@cern.ch>


RUN yum -y update

# Create app directory
WORKDIR /usr/src/app

RUN mkdir -p /opt/rucio/etc
COPY rucio.cfg /opt/rucio/etc/

# for CA certificates

RUN mkdir -p /etc/grid-security/certificates /etc/grid-security/vomsdir 

RUN yum localinstall https://repo.opensciencegrid.org/osg/3.5/osg-3.5-el7-release-latest.rpm -y

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; \
    curl -s -o /etc/pki/rpm-gpg/RPM-GPG-KEY-wlcg http://linuxsoft.cern.ch/wlcg/RPM-GPG-KEY-wlcg; \
    curl -s -o /etc/yum.repos.d/wlcg-centos7.repo http://linuxsoft.cern.ch/wlcg/wlcg-centos7.repo; \
    curl -s -o /etc/yum.repos.d/xrootd-stable-slc7.repo http://www.xrootd.org/binaries/xrootd-stable-slc7.repo

RUN yum install -y \
    voms \
    fetch-crl \
    xrootd-client \
    xrootd \
    python-pip \
    python36


RUN pip install elasticsearch

COPY . .

# build  
RUN echo "Timestamp:" `date --utc` | tee /image-build-info.txt

ENV X509_USER_PROXY /etc/grid-security/x509up

CMD [ "python", "xroot_test.py" ]

