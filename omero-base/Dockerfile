FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

# Install gosu
ENV GOSU_VERSION 1.10
RUN set -x && \
  buildDeps='ca-certificates wget' && \
  dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
  apt-get update && \
  apt-get install -y --no-install-recommends $buildDeps && \
  wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" && \
  wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" && \
  export GNUPGHOME="$(mktemp -d)" && \
  gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 && \
  gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu && \
  rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc && \
  chmod +x /usr/local/bin/gosu && \
  gosu nobody true && \
  apt-get purge -y --auto-remove $buildDeps && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install OMERO dependencies
RUN apt-get update && \
  buildDeps='gcc' && \
  apt-get install -y --no-install-recommends software-properties-common $buildDeps && \
  add-apt-repository -y ppa:openjdk-r/ppa && \
  add-apt-repository -y ppa:fkrull/deadsnakes-python2.7 && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    openjdk-7-jre \
    python python-dev \
    python-pip \
    python-virtualenv \
    python-matplotlib python-scipy python-tables \
    # Dependencies for Pillow
    libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev \
    libwebp-dev tcl8.6-dev tk8.6-dev && \
  pip install --upgrade pip && \
  pip install 'Pillow==2.9.0' && \
  apt-get purge -y --auto-remove $buildDeps && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/root/.cache/*

# Install Ice 3.6
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 5E6DA83306132997 && \
  apt-add-repository "deb http://zeroc.com/download/apt/ubuntu`lsb_release -rs` stable main" && \
  apt-get update && \
  buildDeps='gcc g++' && \
  apt-get install -y --no-install-recommends $buildDeps && \
  apt-get install -y --no-install-recommends \
    db5.3-util libssl-dev libbz2-dev libmcpp-dev libdb++-dev libdb-dev \
    zeroc-ice-all-runtime zeroc-ice-all-dev && \
  pip install 'zeroc-ice==3.6.3' && \
  apt-get purge -y --auto-remove $buildDeps && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/root/.cache/*

ENV BRANCH 5.2.6
ENV ICE 3.6

# Path variables
ENV OMERO_DIR /omero
ENV OMERO_HOME $OMERO_DIR/OMERO.server

# Add omero user and install omego tools
RUN useradd -m omero && \
  mkdir $OMERO_DIR && \
  chown omero $OMERO_DIR && \
  pip install omego && \
  rm -rf /home/root/.cache/*

# Download OMERO with omego
USER omero
WORKDIR $OMERO_DIR
RUN omego download --branch=$BRANCH --ice $ICE --unzipdir . -v server && \
  rm OMERO.server*zip && \
  ln -s OMERO.server-* $OMERO_HOME
USER root

ENV PATH $OMERO_HOME/bin:$PATH
