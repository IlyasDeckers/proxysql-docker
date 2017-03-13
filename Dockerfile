FROM centos:7
MAINTAINER Ilyas Deckers <ilyas@phasehosting.io>

RUN yum install -y https://github.com/sysown/proxysql/releases/download/v1.3.4/proxysql-1.3.4-1-centos7.x86_64.rpm

RUN rpmkeys --import https://www.percona.com/downloads/RPM-GPG-KEY-percona
RUN yum install -y http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm
RUN yum install -y Percona-Server-client-56

ADD ./conf/proxysql.cnf /etc/proxysql.cnf

COPY ./scripts/watch /usr/bin/watch
RUN chmod a+x /usr/bin/watch

COPY ./scripts/adduser /usr/bin/add_user
RUN chmod a+x /usr/bin/add_user

COPY ./scripts/proxysql-entry /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

COPY jq /usr/bin/jq
RUN chmod a+x /usr/bin/jq

VOLUME /var/lib/proxysql

EXPOSE 3306 6032
ONBUILD RUN yum update -y 

CMD [""]
