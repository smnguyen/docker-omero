FROM omero-base

# Install Postgres client
RUN apt-get update && \
  buildDeps='wget' && \
  apt-get install -y --no-install-recommends $buildDeps && \
  add-apt-repository -y "deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main" && \
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  apt-get update && \
  apt-get install -y --no-install-recommends postgresql-client-9.6 && \
  apt-get purge -y --auto-remove $buildDeps && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Path variables
ENV OMERO_DATA_DIR /data/omero_data
ENV OMERO_VAR_DIR /data/omero_var
ENV OMERO_SCRIPTS_DIR /data/omero_scripts

# Default password for admin user (root) of OMERO.server
ENV PASSWORD password

COPY start.sh /start.sh
COPY init.sh /init.sh

EXPOSE 4064

CMD ["bash", "/start.sh"]
