#! /usr/bin/fish

set log /var/log/automation/home.restic.log
set src /home/francois

if test -z $RESTIC_REPOSITORY
    logger -t home.bkp.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "home.bkp.fish -- RESTIC_REPOSITORY empty. Cannot proceed" >>$log
    exit
end

if test -z $RESTIC_PASSWORD
    logger -t home.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "home.bkp.fish -- RESTIC_PASSWORD empty. Cannot proceed" >>$log
    exit
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t home.bkp.fish "Source folder does not exist"
    echo "home.bkp.fish -- Source folder does not exist" >>$log
    exit
end
echo "home.bkp.fish -- Source folder: $src" >>$log

echo "home.bkp.fish -- Creating restic snapshot" >>$log
restic backup \
    --host=raktar \
    --tag=home \
    --exclude='.cache' \
    --exclude='.vscode*' \
    --exclude='development' \
    $src >>$log
if test $status -ne 0
    logger -t home.bkp.fish "There was an error during the snapshot"
    echo "home.bkp.fish -- There was an error during the snapshot" >>$log
    exit
end
logger -t home.bkp.fish "Snapshot created successfully"
echo "home.bkp.fish -- Snapshot created successfully" >>$log

echo "home.bkp.fish -- Forgetting snapshots" >>$log
restic forget \
    --host=raktar \
    --tag=home \
    --keep-daily 14 \
    --keep-monthly 6 \
    --prune >>$log
if test $status -ne 0
    logger -t home.bkp.fish "Unable to forget snapshots"
    echo "home.bkp.fish -- Unable to forget snapshots" >>$log
    exit
end
echo "home.bkp.fish -- Snapshots forgotten successfully" >>$log
