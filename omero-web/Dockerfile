FROM omero-base

ENV OMERO_WEB_CERTS_DIR /data/web_certs
ENV OMERO_WEB_USE_SSL yes
ENV OMERO_WEB_DEVELOPMENT no
ENV OMERO_WEB_DEVELOPMENT_APPS /data/omero_web_apps

RUN add-apt-repository -y ppa:nginx/stable && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    supervisor && \
  pip install \
    'django==1.8.16' \
    'django-debug-toolbar==1.6' \
    'gunicorn==19.6.0' && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/root/.cache/*

COPY nginx_omero.conf $OMERO_HOME/nginx_omero.conf
COPY nginx_omero_ssl.conf $OMERO_HOME/nginx_omero_ssl.conf

RUN rm /etc/nginx/sites-enabled/default
RUN mv $OMERO_HOME/nginx_omero.conf /etc/nginx/sites-available/nginx_omero.conf
RUN mv $OMERO_HOME/nginx_omero_ssl.conf /etc/nginx/sites-available/nginx_omero_ssl.conf

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

COPY supervisor.conf /supervisor.conf
COPY start_nginx.sh /start_nginx.sh
COPY start_omero_web.sh /start_omero_web.sh
RUN chown omero /start_omero_web.sh

CMD ["/usr/bin/supervisord", "-c", "/supervisor.conf", "-e", "info"]
