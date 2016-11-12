export OMERO=$OMERO_HOME/bin/omero

# Wait for data directory to be up
while [ ! -d $(dirname $OMERO_DATA_DIR) ]
do
    echo "Waiting for $(dirname $OMERO_DATA_DIR) directory to be up."
    sleep 5s;
done

HOST="omero-pg"
PORT="5432"

# Wait for PG server to be up
while ! pg_isready -h $HOST -p $PORT -d $POSTGRES_DB -U $POSTGRES_USER --quiet; do
    echo "Waiting for database server to be up."
    sleep 5s;
done

if [ -f "/data/config.sh" ]; then
    bash /data/config.sh || (echo "Something failed while running config.sh"; exit 1);
fi

mkdir -p $OMERO_SCRIPTS_DIR
chown omero $OMERO_SCRIPTS_DIR
ln -s $OMERO_SCRIPTS_DIR $OMERO_HOME/lib/scripts/custom_scripts

mkdir -p $OMERO_VAR_DIR
chown omero $OMERO_VAR_DIR
rm -rf $OMERO_HOME/var
ln -s $OMERO_VAR_DIR $OMERO_HOME/var

mkdir -p $OMERO_DATA_DIR
chown omero $OMERO_DATA_DIR

echo "Setting configuration settings"
gosu omero $OMERO config set omero.db.host $HOST
gosu omero $OMERO config set omero.db.port $PORT
gosu omero $OMERO config set omero.db.name $POSTGRES_DB
gosu omero $OMERO config set omero.db.user $POSTGRES_USER
gosu omero $OMERO config set omero.db.pass $POSTGRES_PASSWORD
gosu omero $OMERO config set omero.data.dir $OMERO_DATA_DIR

echo "Starting OMERO"
exec gosu omero $OMERO admin start --foreground
