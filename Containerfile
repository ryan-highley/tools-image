FROM registry.access.redhat.com/ubi9/openjdk-21:1.20

USER root

ENV APACHE_MAVEN_VERSION 3.9.9
ENV APACHE_ARTEMIS_VERSION 2.37.0
ENV JSQSH_VERSION 2.3
ENV JBANG_VERSION 0.119.0
ENV POSTGRESQL_JDBC_VERSION 42.7.4

RUN set -x \
        && microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y vim-enhanced less openssl gzip \
        && microdnf clean all \
        && rm -rf /var/cache/yum \
\
        && (curl -sfSL "https://dlcdn.apache.org/maven/maven-3/${APACHE_MAVEN_VERSION}/binaries/apache-maven-${APACHE_MAVEN_VERSION}-bin.tar.gz" | tar xzvfC - /opt) \
        && ln -s /opt/apache-maven-${APACHE_MAVEN_VERSION}/bin/mvn /usr/local/bin \
\
        && (curl -sfSL "https://dlcdn.apache.org/activemq/activemq-artemis/${APACHE_ARTEMIS_VERSION}/apache-artemis-${APACHE_ARTEMIS_VERSION}-bin.tar.gz" | tar xzvfC - /opt) \
        && ln -s /opt/apache-artemis-${APACHE_ARTEMIS_VERSION}/bin/artemis /usr/local/bin \
\
        && (curl -sfSL "https://github.com/scgray/jsqsh/releases/download/jsqsh-${JSQSH_VERSION}/jsqsh-${JSQSH_VERSION}-bin.tar.gz" | tar xzvfC - /opt) \
        && ln -s /opt/jsqsh-dist-${JSQSH_VERSION}/bin/jsqsh /usr/local/bin \
\
        && (curl -sfSL "https://github.com/jbangdev/jbang/releases/download/v${JBANG_VERSION}/jbang.tar" | tar xvfC - /opt) \
        && ln -s /opt/jbang/bin/jbang /usr/local/bin \
\
        && mkdir /opt/jdbc \
        && curl -sfSL "https://github.com/pgjdbc/pgjdbc/releases/download/REL${POSTGRESQL_JDBC_VERSION}/postgresql-${POSTGRESQL_JDBC_VERSION}.jar" -o /opt/jdbc/postgresql-${POSTGRESQL_JDBC_VERSION}.jar \
        && mv /opt/jdbc/* /opt/jsqsh-dist-${JSQSH_VERSION}/share/jsqsh/ \
        && rmdir /opt/jdbc

ENTRYPOINT [ "/bin/bash" ]
