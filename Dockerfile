FROM sdd330/jsdev

# Set customizable env vars defaults.
ENV DEBIAN_FRONTEND noninteractive

# Install Java
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu precise main" | tee -a /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update
RUN apt-get -y upgrade

# Auto accept oracle jdk license
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -yq oracle-java7-installer oracle-java7-set-default ca-certificates libxext-dev libxrender-dev libxtst-dev mysql-client vim telnet dnsutils wget curl unzip git
RUN update-alternatives --display java

# Add JAVA_HOME to path.
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# Install maven
ENV MAVEN_VERSION 3.3.3

RUN curl -fsSL http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /usr/share \
  && mv /usr/share/apache-maven-$MAVEN_VERSION /usr/share/maven \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven

# Install Docker Build Maven Plugin
RUN git clone https://github.com/sdd330/dockerbuild-maven-plugin.git /plugin

RUN cd /plugin && mvn clean install

# Install Docker Compose
ENV DOCKER_COMPOSE_VERSION 1.2.0

ADD https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-Linux-x86_64 \
    /usr/local/bin/docker-compose

RUN chmod +x /usr/local/bin/docker-compose

# Clean up APT when done
RUN apt-get autoremove -yq && \
    apt-get clean -yq && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
