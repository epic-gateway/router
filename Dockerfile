FROM ubuntu:20.04

# borrowed from https://github.com/pierky/dockerfiles/blob/master/bird/2.0.8/Dockerfile
RUN apt-get update && apt-get install -y \
        git \
        autoconf \
	bison \
	build-essential \
	wget \
	flex \
	libreadline-dev \
	libncurses5-dev \
	m4 \
	unzip

WORKDIR /root

RUN git clone --depth=1 --branch=v2.0.8 https://gitlab.nic.cz/labs/bird.git

RUN cd bird && \
	autoconf && \
	autoheader && \
	./configure && \
	make && \
	make install

# acnodal customization
WORKDIR /
RUN apt-get -q -y install iproute2 tcpdump iputils-ping readline-common libssh-4 inotify-tools nano
RUN mkdir -p /usr/local/var/run
COPY configlets/* /tmp/configlets/
COPY wrapper.sh /wrapper.sh
COPY reconfig.sh /reconfig.sh
COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD /wrapper.sh
