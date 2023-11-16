#! /usr/bin/fish

set src "$HOME"
set log "/var/log/automation/home.restic.log"

echo "


-------------------------------------
 "(date -Iseconds)"
-------------------------------------
" | tee -a $log

if test -z $RESTIC_REPOSITORY
    logger -t home.bkp.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "home.bkp.fish -- RESTIC_REPOSITORY empty. Cannot proceed" | tee -a $log
    exit 1
end

if test -z $RESTIC_PASSWORD
    logger -t home.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "home.bkp.fish -- RESTIC_PASSWORD empty. Cannot proceed" | tee -a $log
    exit 1
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d "$src"
    logger -t home.bkp.fish "Source folder does not exist"
    echo "home.bkp.fish -- Source folder does not exist" | tee -a $log
    exit 1
end
echo "home.bkp.fish -- Source folder: $src" | tee -a $log

echo "home.bkp.fish -- Creating restic snapshot" | tee -a $log
pushd "$src"
restic backup \
    --host=raktar \
    --tag=home \
    --exclude='.cache' \
    --exclude='.vscode*' \
    --exclude='devel' \
    --exclude='development'\
    .  2>&1 | tee -a $log
if test $status -ne 0
    logger -t home.bkp.fish "There was an error during the snapshot"
    echo "home.bkp.fish -- There was an error during the snapshot" | tee -a $log
    exit 1
end
popd
logger -t home.bkp.fish "Snapshot created successfully"
echo "home.bkp.fish -- Snapshot created successfully" | tee -a $log

echo "home.bkp.fish -- Forgetting snapshots" | tee -a $log
restic forget \
    --host=raktar \
    --tag=home \
    --keep-daily=1 \
    --keep-weekly=4 \
    --keep-monthly=6  2>&1 | tee -a $log
if test $status -ne 0
    logger -t home.bkp.fish "Unable to forget snapshots"
    echo "home.bkp.fish -- Unable to forget snapshots" | tee -a $log
    exit 1
end
echo "home.bkp.fish -- Snapshots forgotten successfully" | tee -a $log
