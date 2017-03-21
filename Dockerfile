FROM centos:7
MAINTAINER Ilyas Deckers <ilyas@phasehosting.io>

RUN yum install -y https://github.com/sysown/proxysql/releases/download/v1.3.4/proxysql-1.3.4-1-centos7.x86_64.rpm && \
rpmkeys --import https://www.percona.com/downloads/RPM-GPG-KEY-percona && \
yum install -y http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm && \
yum install -y Percona-Server-client-56

ADD ./conf/proxysql.tmpl /etc/proxysql.tmpl

RUN mkdir /opt/proxysql
COPY ./opt/proxysql/* /opt/proxysql/
COPY ./entrypoint.sh /entrypoint.sh
COPY ./bin/* /usr/bin/
COPY .env /etc/.env

RUN mkdir /var/backup && \
chmod a+x /usr/bin/* && \
chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

VOLUME /var/lib/proxysql

EXPOSE 3306 6032
ONBUILD RUN yum update -y 

CMD [""]
