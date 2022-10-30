#! /usr/bin/fish

set log /var/log/automation/automation.restic.log
set src /data/automation

if test -z $RESTIC_REPOSITORY
    logger -t automation.bkp.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "automation.bkp.fish -- RESTIC_REPOSITORY empty. Cannot proceed" >>$log
    exit
end

if test -z $RESTIC_PASSWORD
    logger -t automation.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "automation.bkp.fish -- RESTIC_PASSWORD empty. Cannot proceed" >>$log
    exit
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t automation.bkp.fish "Source folder does not exist"
    echo "automation.bkp.fish -- Source folder does not exist" >>$log
    exit
end
echo "automation.bkp.fish -- Source folder: $src" >>$log

echo "automation.bkp.fish -- Creating restic snapshot" >>$log
restic backup \
    --host=raktar \
    --tag=automation \
    $src  >>$log

if test $status -ne 0
    logger -t automation.bkp.fish "There was an error during the snapshot"
    echo "automation.bkp.fish -- There was an error during the snapshot" >>$log
    exit
end
logger -t automation.bkp.fish "Snapshot created successfully"
echo "automation.bkp.fish -- Snapshot created successfully" >>$log

echo "automation.bkp.fish -- Forgetting snapshots" >>$log
restic forget \
    --host=raktar \
    --tag=automation \
    --keep-last 1 \
    --prune >>$log
if test $status -ne 0
    logger -t automation.bkp.fish "Unable to forget snapshots"
    echo "automation.bkp.fish -- Unable to forget snapshots" >>$log
    exit
end
echo "automation.bkp.fish -- Snapshots forgotten successfully" >>$log
