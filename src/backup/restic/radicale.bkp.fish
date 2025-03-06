#! /usr/bin/fish

set src "/data/containers/radicale"
set log "/var/log/automation/radicale.restic.log"
set script (status basename)

echo "


-------------------------------------
 "(date -Iseconds)"
-------------------------------------
" | tee -a $log

if test -z $RESTIC_REPOSITORY
    logger -t $script "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "$script -- RESTIC_REPOSITORY empty. Cannot proceed" | tee -a $log
    exit 1
end

if test -z $RESTIC_PASSWORD_FILE
    logger -t $script "RESTIC_PASSWORD_FILE empty. Cannot proceed"
    echo "$script -- RESTIC_PASSWORD_FILE empty. Cannot proceed" | tee -a $log
    exit 1
end

if test ! -e $RESTIC_PASSWORD_FILE
    logger -t $script "RESTIC_PASSWORD_FILE does not exist. Cannot proceed"
    echo "$script -- RESTIC_PASSWORD_FILE does not exist. Cannot proceed" | tee -a $log
    exit 1
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d "$src"
    logger -t $script "Source folder does not exist"
    echo "$script -- Source folder does not exist" | tee -a $log
    exit 1
end
echo "$script -- Source folder: $src" | tee -a $log

echo "$script -- Creating restic snapshot" | tee -a $log
pushd "$src"
restic backup \
    --host=raktar \
    --tag=radicale \
    .  2>&1 | tee -a $log
if test $status -ne 0
    logger -t $script "There was an error during the snapshot"
    echo "$script -- There was an error during the snapshot" | tee -a $log
    exit 1
end
popd
logger -t $script "Snapshot created successfully"
echo "$script -- Snapshot created successfully" | tee -a $log

echo "$script -- Forgetting snapshots" | tee -a $log
restic forget \
    --host=raktar \
    --tag=radicale \
    --keep-last=3 2>&1 | tee -a $log
if test $status -ne 0
    logger -t $script "Unable to forget snapshots"
    echo "$script -- Unable to forget snapshots" | tee -a $log
    exit 1
end
echo "$script -- Snapshots forgotten successfully" | tee -a $log
