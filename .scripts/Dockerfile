FROM ubuntu:latest
RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && apt-get install \
    vim \
    net-tools \
    iputils-ping \
  && rm -rf /var/lib/apt/lists/*
RUN useradd -ms /bin/bash shay
USER shay