# Run the DB initialization scripts, then delete the file --
# it contains the OMERO root user's password.
PGPASSWORD=$POSTGRES_PASSWORD psql -U $POSTGRES_USER -f /data/sql_scripts/init_db.sql $POSTGRES_DB
rm /data/sql_scripts/init_db.sql
