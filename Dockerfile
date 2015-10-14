#set up base image
FROM centos:centos7

# File Author / Maintainer
MAINTAINER Tim Tutt <tim.tutt@gmail.com>

#update nameservers in resolve .conf to google nameservers
#RUN echo 'nameserver 8.8.8.8' | cat - /etc/resolve.conf > temp && mv temp /etc/resolve.conf

#update yum and get epel
RUN \
  yum -y update && \
  yum -y install epel-release && \
  yum -y groupinstall "Compatibility libraries" && \
  yum -y install glibc.i686 && \
  yum -y install libstdc++.i686

#set up ssh
RUN \
  yum install -y passwd && \
  yum install -y openssh-server openssh-clients && \
  echo P@ssword123 | passwd root --stdin && \
  ssh-keygen -A


#supervisor will run /usr/sbin/sshd -D

#Install Delta RPM and development utils
RUN yum -y install deltarpm gcc-c++ openssl-devel make wget supervisor

#install java
RUN yum -y install java-1.8.0-openjdk-devel.x86_64

#now grab elasticsearch and set it up
RUN useradd -ms /bin/bash elasticsearch && \
  su elasticsearch && \
  cd /opt && \
  wget https://download.elasticsearch.org/elasticsearch/release/org/elasticsearch/distribution/tar/elasticsearch/2.0.0-rc1/elasticsearch-2.0.0-rc1.tar.gz && \
  tar -xvf elasticsearch*.tar.gz && \
  rm *.tar.gz && \
  ln -s elasticsearch* elasticsearch

#grab kibana and set it up
RUN su elasticsearch && cd /opt && \
  wget https://download.elastic.co/kibana/kibana/kibana-4.2.0-beta2-linux-x86.tar.gz && \
  tar -xvf kibana*.tar.gz && \
  rm *.tar.gz && \
  ln -s kibana* kibana

#set up the data stores point
RUN \
    mkdir -p /data/es/logs && \
    mkdir /data/es/store && \
    mkdir -p /data/kibana/store && \
    mkdir /data/kibana/logs && \
    mkdir -p /data/sshd/logs && \
    chown -R elasticsearch:elasticsearch /data && \
    chown -R elasticsearch:elasticsearch /opt/elasticsearch* && \
    chown -R elasticsearch:elasticsearch /opt/kibana*

COPY opt/elasticsearch/config/*.yml /opt/elasticsearch/config/
COPY opt/kibana/config/*.yml /opt/elasticsearch/config/
COPY etc/supervisord.conf /etc/supervisord.conf

#create volume for data and logs
#VOLUME /data

#Expose some ports to the world for es, kibana, and ssh
EXPOSE 9200 9300 5601 22

CMD ["/usr/bin/supervisord"]
