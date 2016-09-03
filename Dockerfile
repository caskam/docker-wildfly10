FROM frolvlad/alpine-oraclejdk8:cleaned

ARG CONFIG_DIR=/etc/wildfly/config.d/ 
ARG WILDFLY_VERSION=10.1.0.Final
ARG APPS_BASE=/apps
ARG WILDFLY_RUNTIME_BASE_DIR=/var/run/wildfly

COPY s6-overlay-amd64.tar.gz /tmp/s6-overlay.tar.gz
COPY wildfly-dist-10.1.0.Final.zip /tmp/wildfly.zip
RUN \
#  apk add --no-cache --virtual build-dependencies wget ca-certificates && \
#  echo "fetching s6-overlay" && \
#  wget -qO /tmp/s6-overlay.tar.gz https://github.com/just-containers/s6-overlay/releases/download/v1.18.1.5/s6-overlay-amd64.tar.gz && \
#  echo "fetching wildfly" && \
#  wget -qO /tmp/wildfly.zip http://search.maven.org/remotecontent?filepath=org/wildfly/wildfly-dist/${WILDFLY_VERSION}/wildfly-dist-${WILDFLY_VERSION}.zip && \
  tar -zxf /tmp/s6-overlay.tar.gz -C / && \
  mkdir $APPS_BASE && \
  unzip -qd /apps /tmp/wildfly.zip && \
  ln -s $APPS_BASE/wildfly-${WILDFLY_VERSION} $APPS_BASE/wildfly && \
  rm /tmp/s6-overlay.tar.gz && \
  rm /tmp/wildfly.zip

RUN \
  mv $APPS_BASE/wildfly/standalone $APPS_BASE/wildfly/standalone.OEM && \
  ln -s $WILDFLY_RUNTIME_BASE_DIR $APPS_BASE/wildfly/standalone && \
  mkdir -p $CONFIG_DIR

COPY cont-init.d/ /etc/cont-init.d/

EXPOSE 8080 9990
ENTRYPOINT ["/init"]
CMD ["/apps/wildfly/bin/standalone.sh"]
