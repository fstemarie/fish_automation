#! /usr/bin/fish

set log /var/log/automation/config.restic.log
set src /data/config

if test -z $RESTIC_REPOSITORY
    logger -t config.bkp.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "config.bkp.fish -- RESTIC_REPOSITORY empty. Cannot proceed" >>$log
    exit
end

if test -z $RESTIC_PASSWORD
    logger -t config.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "config.bkp.fish -- RESTIC_PASSWORD empty. Cannot proceed" >>$log
    exit
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t config.bkp.fish "Source folder does not exist"
    echo "config.bkp.fish -- Source folder does not exist" >>$log
    exit
end
echo "config.bkp.fish -- Source folder: $src" >>$log

echo "config.bkp.fish -- Creating restic snapshot" >>$log
restic backup \
    --host=raktar \
    --tag=config \
    $src  >>$log

if test $status -ne 0
    logger -t config.bkp.fish "There was an error during the snapshot"
    echo "config.bkp.fish -- There was an error during the snapshot" >>$log
    exit
end
logger -t config.bkp.fish "Snapshot created successfully"
echo "config.bkp.fish -- Snapshot created successfully" >>$log

echo "config.bkp.fish -- Forgetting snapshots" >>$log
restic forget \
    --host=raktar \
    --tag=config \
    --keep-last 1 \
    --prune >>$log
if test $status -ne 0
    logger -t config.bkp.fish "Unable to forget snapshots"
    echo "config.bkp.fish -- Unable to forget snapshots" >>$log
    exit
end
echo "config.bkp.fish -- Snapshots forgotten successfully" >>$log
