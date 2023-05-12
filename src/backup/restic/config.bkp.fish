#! /usr/bin/fish

set src "/data/config"
set log "/var/log/automation/config.restic.log"

echo "


-------------------------------------
 "(date -Ins)"
-------------------------------------
" | tee -a $log

if test -z $RESTIC_REPOSITORY
    logger -t config.bkp.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "config.bkp.fish -- RESTIC_REPOSITORY empty. Cannot proceed" | tee -a $log
    exit 1
end

if test -z $RESTIC_PASSWORD
    logger -t config.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "config.bkp.fish -- RESTIC_PASSWORD empty. Cannot proceed" | tee -a $log
    exit 1
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d "$src"
    logger -t config.bkp.fish "Source folder does not exist"
    echo "config.bkp.fish -- Source folder does not exist" | tee -a $log
    exit 1
end
echo "config.bkp.fish -- Source folder: $src" | tee -a $log

echo "config.bkp.fish -- Creating restic snapshot" | tee -a $log
pushd "$src"
restic backup \
    --host=raktar \
    --tag=config \
    .  2>&1 | tee -a $log

if test $status -ne 0
    logger -t config.bkp.fish "There was an error during the snapshot"
    echo "config.bkp.fish -- There was an error during the snapshot" | tee -a $log
    exit 1
end
popd
logger -t config.bkp.fish "Snapshot created successfully"
echo "config.bkp.fish -- Snapshot created successfully" | tee -a $log

echo "config.bkp.fish -- Forgetting snapshots" | tee -a $log
restic forget \
    --host=raktar \
    --tag=config \
    --keep-last 1  2>&1 | tee -a $log
if test $status -ne 0
    logger -t config.bkp.fish "Unable to forget snapshots"
    echo "config.bkp.fish -- Unable to forget snapshots" | tee -a $log
    exit 1
end
echo "config.bkp.fish -- Snapshots forgotten successfully" | tee -a $log
