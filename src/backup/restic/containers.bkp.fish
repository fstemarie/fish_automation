#! /usr/bin/fish

set src "/data/containers"
set log "/var/log/automation/containers.restic.log"

echo "


-------------------------------------
 "(date -Iseconds)"
-------------------------------------
" | tee -a $log

if test -z $RESTIC_REPOSITORY
    logger -t containers.bkp.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "containers.bkp.fish -- RESTIC_REPOSITORY empty. Cannot proceed" | tee -a $log
    exit 1
end

if test -z $RESTIC_PASSWORD
    logger -t containers.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "containers.bkp.fish -- RESTIC_PASSWORD empty. Cannot proceed" | tee -a $log
    exit 1
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d "$src"
    logger -t containers.bkp.fish "Source folder does not exist"
    echo "containers.bkp.fish -- Source folder does not exist" | tee -a $log
    exit 1
end
echo "containers.bkp.fish -- Source folder: $src" | tee -a $log

echo "containers.bkp.fish -- Creating restic snapshot" | tee -a $log
pushd "$src"
restic backup \
    --host=raktar \
    --tag=containers \
    --iexclude='log*' --iexclude='cache*' --iexclude='keys' \
    --exclude='__pycache__' \
    --exclude='airsonic/.java' \
    --exclude='qbittorrent/ipc-socket' \
    --exclude='caddy/autosave.json' \
    --exclude='Jackett/DataProtection' \
    .  2>&1 | tee -a $log
if test $status -ne 0
    logger -t containers.bkp.fish "There was an error during the snapshot"
    echo "containers.bkp.fish -- There was an error during the snapshot" | tee -a $log
    exit 1
end
popd
logger -t containers.bkp.fish "Snapshot created successfully"
echo "containers.bkp.fish -- Snapshot created successfully" | tee -a $log

echo "containers.bkp.fish -- Forgetting snapshots" | tee -a $log
restic forget \
    --host=raktar \
    --tag=containers \
    --keep-monthly=3 \
    --keep-weekly=3  2>&1 | tee -a $log
if test $status -ne 0
    logger -t containers.bkp.fish "Unable to forget snapshots"
    echo "containers.bkp.fish -- Unable to forget snapshots" | tee -a $log
    exit 1
end
echo "containers.bkp.fish -- Snapshots forgotten successfully" | tee -a $log
