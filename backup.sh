#!/bin/sh

TIMESTAMP=$(date +"%Y-%m-%d")
BACKUP_DIR="db_backups/$TIMESTAMP"

echo "** STARTING BACKUP PROCESS **\n"

cd "$(dirname "$0")"
export $(cat .env | xargs)

# Create backup directory in case it doesn't exist
mkdir -p "$BACKUP_DIR"

# Get list of databases that need to backed up. Ignore system DBs
databases=$(mysql -u$DB_USERNAME -p$DB_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")

for db in $databases; do
    echo "* Backing up $db *\n"

    # Create temporary DB backup
    mysqldump -u$DB_USERNAME -p$DB_PASSWORD --databases $db >"$BACKUP_DIR/$db.sql"
    gzip $BACKUP_DIR/$db.sql

    # Use rclone to upload files to the remote backup server
    rclone copy $BACKUP_DIR/ $RCLONE_REMOTE:$BACKUP_DIR

    # Delete file
    rm $BACKUP_DIR/$db.sql.gz

    echo "* Finished backing up $db *\n"
done

# Delete DB backup file
rmdir $BACKUP_DIR

echo "** BACKUP PROCESS DONE. **"
