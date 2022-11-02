#! /usr/bin/fish

echo "


---------------------------------------
| "(date -Ins)" |
---------------------------------------
" | tee -a $log

set log /var/log/automation/containers.restic.log
set src /data/containers

if test -z $RESTIC_REPOSITORY
    logger -t containers.bkp.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "containers.bkp.fish -- RESTIC_REPOSITORY empty. Cannot proceed" | tee -a $log
    exit
end

if test -z $RESTIC_PASSWORD
    logger -t containers.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "containers.bkp.fish -- RESTIC_PASSWORD empty. Cannot proceed" | tee -a $log
    exit
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t containers.bkp.fish "Source folder does not exist"
    echo "containers.bkp.fish -- Source folder does not exist" | tee -a $log
    exit
end
echo "containers.bkp.fish -- Source folder: $src" | tee -a $log

echo "containers.bkp.fish -- Creating restic snapshot" | tee -a $log
restic backup \
    --host=raktar \
    --tag=containers \
    $src  | tee -a $log

if test $status -ne 0
    logger -t containers.bkp.fish "There was an error during the snapshot"
    echo "containers.bkp.fish -- There was an error during the snapshot" | tee -a $log
    exit
end
logger -t containers.bkp.fish "Snapshot created successfully"
echo "containers.bkp.fish -- Snapshot created successfully" | tee -a $log

echo "containers.bkp.fish -- Forgetting snapshots" | tee -a $log
restic forget \
    --host=raktar \
    --tag=containers \
    --keep-last 1 \
    --prune | tee -a $log
if test $status -ne 0
    logger -t containers.bkp.fish "Unable to forget snapshots"
    echo "containers.bkp.fish -- Unable to forget snapshots" | tee -a $log
    exit
end
echo "containers.bkp.fish -- Snapshots forgotten successfully" | tee -a $log
