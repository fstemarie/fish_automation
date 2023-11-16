#! /usr/bin/fish

set src "$HOME/development"
set log "/var/log/automation/development.restic.log"

echo "


-------------------------------------
 "(date -Iseconds)"
-------------------------------------
" | tee -a $log

if test -z $RESTIC_REPOSITORY
    logger -t development.bkp.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "development.bkp.fish -- RESTIC_REPOSITORY empty. Cannot proceed" | tee -a $log
    exit 1
end

if test -z $RESTIC_PASSWORD
    logger -t development.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "development.bkp.fish -- RESTIC_PASSWORD empty. Cannot proceed" | tee -a $log
    exit 1
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d "$src"
    logger -t development.bkp.fish "Source folder does not exist"
    echo "development.bkp.fish -- Source folder does not exist" | tee -a $log
    exit 1
end
echo "development.bkp.fish -- Source folder: $src" | tee -a $log

echo "development.bkp.fish -- Creating restic snapshot" | tee -a $log
pushd "$src"
restic backup \
    --host=raktar \
    --tag=development \
    --exclude='.venv' \
    --exclude='node_modules' \
    .  2>&1 | tee -a $log
if test $status -ne 0
    logger -t development.bkp.fish "There was an error during the snapshot"
    echo "development.bkp.fish -- There was an error during the snapshot" | tee -a $log
    exit 1
end
popd
logger -t development.bkp.fish "Snapshot created successfully"
echo "development.bkp.fish -- Snapshot created successfully" | tee -a $log

echo "development.bkp.fish -- Forgetting snapshots" | tee -a $log
restic forget \
    --host=raktar \
    --tag=development \
    --keep-daily 1 \
    --keep-weekly 4 \
    --keep-monthly=6  2>&1 | tee -a $log
if test $status -ne 0
    logger -t development.bkp.fish "Unable to forget snapshots"
    echo "development.bkp.fish -- Unable to forget snapshots" | tee -a $log
    exit 1
end
echo "development.bkp.fish -- Snapshots forgotten successfully" | tee -a $log
