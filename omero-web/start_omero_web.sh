export PYTHONPATH=$OMERO_WEB_DEVELOPMENT_APPS:$PYTHONPATH

if [ $OMERO_WEB_DEVELOPMENT == "no" ]; then
    if [ $OMERO_WEB_USE_SSL == "yes" ]; then
        # Setup ssl certificates if it is not already here
        if [ ! -f $OMERO_WEB_CERTS_DIR/omero.crt ]; then
            mkdir -p $OMERO_WEB_CERTS_DIR
            openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $OMERO_WEB_CERTS_DIR/omero.key -out $OMERO_WEB_CERTS_DIR/omero.crt -batch
        fi
    fi

    # Load applications from /data/omero_web_apps/deploy.sh
    bash $OMERO_WEB_DEVELOPMENT_APPS/deploy.sh
else
    mkdir -p $OMERO_WEB_DEVELOPMENT_APPS

    gosu omero omero config set omero.web.application_server development
    gosu omero omero config set omero.web.debug True
    gosu omero omero config set omero.web.application_server.host 0.0.0.0
    gosu omero omero config set omero.web.application_server.port 4080
fi

gosu omero omero config set omero.web.server_list "[[\"omero-server\", 4064, \"omero\"]]"
exec gosu omero omero web start --foreground
