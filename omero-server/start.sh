export OMERO=$OMERO_HOME/bin/omero

# Wait for data directory to be up
while [ ! -d $(dirname $OMERO_DATA_DIR) ]
do
    echo "Waiting for $(dirname $OMERO_DATA_DIR) directory to be up."
    sleep 5s;
done

HOST="omero-db"
PORT="5432"

# Wait for PG server to be up
while ! pg_isready -h $HOST -p $PORT -d omero -U omero --quiet; do
    echo "Waiting for database server to be up."
    sleep 5s;
done

# Init the database for OMERO.server if data dir does not exist
if [ ! -d "$OMERO_DATA_DIR" ]; then
    bash /init.sh || (echo "Something failed during the initialisation"; exit 1);
fi

cd $OMERO_HOME/

if [ -f "/data/config.sh" ]; then
    bash /data/config.sh || (echo "Something failed while running config.sh"; exit 1);
fi

mkdir -p $OMERO_SCRIPTS_DIR/
chown omero $OMERO_SCRIPTS_DIR
ln -s $OMERO_SCRIPTS_DIR/ $OMERO_HOME/lib/scripts/custom_scripts

mkdir -p $OMERO_VAR_DIR/
chown omero $OMERO_VAR_DIR/
rm -rf $OMERO_HOME/var/  # TODO Will this remove existing logs after the first launch?
ln -s $OMERO_VAR_DIR $OMERO_HOME/var

mkdir -p $OMERO_DATA_DIR/
chown omero $OMERO_DATA_DIR

echo "Setting configuration settings"
gosu omero $OMERO config set omero.db.host $HOST
gosu omero $OMERO config set omero.db.port $PORT
gosu omero $OMERO config set omero.data.dir $OMERO_DATA_DIR

echo "Starting OMERO"
exec gosu omero $OMERO admin start --foreground
