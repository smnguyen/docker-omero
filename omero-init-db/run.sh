export SQL_SCRIPTS=/data/sql_scripts

# If `SQL_SCRIPTS` already exists, we assume the database has already
# been initialized, so we don't need to create the database init script.
if [ ! -d $SQL_SCRIPTS ]; then
    mkdir -p $SQL_SCRIPTS
    chown omero $SQL_SCRIPTS

    exec gosu omero omero db script -f $SQL_SCRIPTS/init_db.sql --password $PASSWORD
fi
