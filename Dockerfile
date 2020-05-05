FROM openjdk:13.0.2-jdk

ARG USER_HOME_DIR="/root"
ARG GAUGE_JAVA_VERSION=0.7.7
ARG NODES=30

WORKDIR /gauge

USER root

RUN \
  yum install -y wget unzip && \
  wget -O /tmp/gauge.zip `curl -s https://api.github.com/repos/getgauge/gauge/releases | grep browser_download_url | grep 'linux.x86_64.zip' | head -n 1 | cut -d '"' -f 4` && \
  unzip -d /tmp/gauge /tmp/gauge.zip && \
  cp /tmp/gauge/gauge /usr/local/bin/ && \
  rm -rf /tmp/gauge /tmp/gauge.zip ~/.gauge/config ~/.gauge/logs && \
  rm -rf gauge gauge.zip ~/.gauge/config ~/.gauge/logs && \
  yum clean all && \
  chmod 777 /gauge

RUN gauge install java --version ${GAUGE_JAVA_VERSION}

ENTRYPOINT ["./gradlew", "clean", "gauge"]