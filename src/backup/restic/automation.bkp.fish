#! /usr/bin/fish

set src "/data/automation"
set log "/var/log/automation/automation.restic.log"

echo "


-------------------------------------
 "(date -Iseconds)"
-------------------------------------
" | tee -a $log


if test -z $RESTIC_REPOSITORY
    logger -t automation.bkp.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "automation.bkp.fish -- RESTIC_REPOSITORY empty. Cannot proceed" | tee -a $log
    exit 1
end

if test -z $RESTIC_PASSWORD_FILE
    logger -t automation.bkp.fish "RESTIC_PASSWORD_FILE empty. Cannot proceed"
    echo "automation.bkp.fish -- RESTIC_PASSWORD_FILE empty. Cannot proceed" | tee -a $log
    exit 1
end

if test ! -e $RESTIC_PASSWORD_FILE
    logger -t automation.bkp.fish "RESTIC_PASSWORD_FILE does not exist. Cannot proceed"
    echo "automation.bkp.fish -- RESTIC_PASSWORD_FILE does not exist. Cannot proceed" | tee -a $log
    exit 1
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d "$src"
    logger -t automation.bkp.fish "Source folder does not exist"
    echo "automation.bkp.fish -- Source folder does not exist" | tee -a $log
    exit 1
end
echo "automation.bkp.fish -- Source folder: $src" | tee -a $log

echo "automation.bkp.fish -- Creating restic snapshot" | tee -a $log
pushd "$src"
restic backup \
    --host=raktar \
    --tag=automation \
    .  2>&1 | tee -a $log
if test $status -ne 0
    logger -t automation.bkp.fish "There was an error during the snapshot"
    echo "automation.bkp.fish -- There was an error during the snapshot" | tee -a $log
    exit 1
end
popd
logger -t automation.bkp.fish "Snapshot created successfully"
echo "automation.bkp.fish -- Snapshot created successfully" | tee -a $log

echo "automation.bkp.fish -- Forgetting snapshots" | tee -a $log
restic forget \
    --host=raktar \
    --tag=automation \
    --keep-last 1  2>&1 | tee -a $log
if test $status -ne 0
    logger -t automation.bkp.fish "Unable to forget snapshots"
    echo "automation.bkp.fish -- Unable to forget snapshots" | tee -a $log
    exit 1
end
echo "automation.bkp.fish -- Snapshots forgotten successfully" | tee -a $log
