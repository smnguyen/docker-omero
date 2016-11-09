HOST="omero-db"
PORT="5432"

if psql -h "$HOST" -p "$PORT" -U postgres -lqt | cut -d \| -f 1 | grep -w omero; then
    echo "Database already exist";
    exit 0;
fi

echo "Setting up database"
gosu omero $OMERO_HOME/bin/omero db script -f /tmp/init_db.sql --password $PASSWORD
createuser -h "$HOST" -p "$PORT" -U postgres -s omero
createdb -h "$HOST" -p "$PORT" -U omero -O omero omero
psql -h "$HOST" -p "$PORT" -U omero omero -f /tmp/init_db.sql
rm -f /tmp/init_db.sql
