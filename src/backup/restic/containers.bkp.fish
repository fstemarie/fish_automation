#! /usr/bin/fish

set log /var/log/automation/containers.restic.log
set src /data/containers

if test -z $RESTIC_REPOSITORY
    logger -t containers.bkp.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "containers.bkp.fish -- RESTIC_REPOSITORY empty. Cannot proceed" >>$log
    exit
end

if test -z $RESTIC_PASSWORD
    logger -t containers.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "containers.bkp.fish -- RESTIC_PASSWORD empty. Cannot proceed" >>$log
    exit
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t containers.bkp.fish "Source folder does not exist"
    echo "containers.bkp.fish -- Source folder does not exist" >>$log
    exit
end
echo "containers.bkp.fish -- Source folder: $src" >>$log

echo "containers.bkp.fish -- Creating restic snapshot" >>$log
restic backup \
    --host=raktar \
    --tag=containers \
    $src  >>$log

if test $status -ne 0
    logger -t containers.bkp.fish "There was an error during the snapshot"
    echo "containers.bkp.fish -- There was an error during the snapshot" >>$log
    exit
end
logger -t containers.bkp.fish "Snapshot created successfully"
echo "containers.bkp.fish -- Snapshot created successfully" >>$log

echo "containers.bkp.fish -- Forgetting snapshots" >>$log
restic forget \
    --host=raktar \
    --tag=containers \
    --keep-last 1 \
    --prune >>$log
if test $status -ne 0
    logger -t containers.bkp.fish "Unable to forget snapshots"
    echo "containers.bkp.fish -- Unable to forget snapshots" >>$log
    exit
end
echo "containers.bkp.fish -- Snapshots forgotten successfully" >>$log
