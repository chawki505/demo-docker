FROM jenkins/jenkins:2.111

USER root

RUN apt-get update \
        && apt-get install --no-install-recommends --no-install-suggests -y \
        ca-certificates \
        software-properties-common \
        vim \
        btrfs-tools

RUN apt-get update && apt-get install -y libltdl7 && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 999 docker
RUN usermod -aG 999 jenkins

RUN curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

RUN chmod +x /usr/local/bin/docker-compose

USER jenkins
