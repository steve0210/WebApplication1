FROM centos:7.8.2003

RUN yum update -y \
  && yum install -y \
  https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm \
  ca-certificates \
  gnupg2 \
  procps \
  curl \
  which \
  wget \
  less \
  git \
  && yum install -y aspnetcore-runtime-3.1 \
  && yum clean all

WORKDIR /tmp
RUN useradd -ms /bin/bash -G disk rails \
  && mkdir -p /home/rails/.ssh

COPY scripts/.ssh /home/rails/.ssh
COPY scripts/.pgpass /home/rails/.pgpass
COPY scripts/docker/bashrc /home/rails/.bashrc
RUN chown -R rails:rails /home/rails

WORKDIR /var/www/ccapi/current
COPY . .
RUN chown -R rails:rails /var/www/ccapi
