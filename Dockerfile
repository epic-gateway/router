FROM ubuntu:18.04
RUN apt update && apt -y upgrade && apt-get -q -y install iproute2 tcpdump iputils-ping readline-common libreadline7 libssh-4
RUN mkdir -p /usr/local/var/run
COPY bird /usr/local/sbin/bird
COPY birdc /usr/local/sbin/birdc
COPY routerid.conf /usr/local/include/routerid.conf
COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["bird",  "-fR"]