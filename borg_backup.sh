#!/bin/sh


#!/bin/sh
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
"$SCRIPT_DIR"/your_script.sh
date=$(date)
date_formatted=$(date +%Y%m%d)
echo "Starting backup for $date"
echo

# setup script variables
export BORG_PASSPHRASE="secret-passphrase-here!"
export BORG_REPO="/path/to/repo"
export BACKUP_TARGETS="/path1/to/backup /path2/to/backup"
export BACKUP_NAME="backup-and-remote-folder-name"

# create borg backup archive
cmd="borg create ::${date_formatted}-$BACKUP_NAME $BACKUP_TARGETS --stats"
$cmd

# prune old archives to keep disk space in check
borg prune -v --list --keep-daily=3 --keep-weekly=2

# sync backups to offsite storage
b2 authorize-account accountID applictionKey
b2 sync --delete --replaceNewer $BORG_REPO b2://bucket-name/$BACKUP_NAME

# all done!
echo "Backup complete at $date";
