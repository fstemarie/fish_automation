#! /usr/bin/fish

echo "


---------------------------------------
| "(date -Ins)" |
---------------------------------------
" | tee -a $log

set log /var/log/automation/development.restic.log
set src /home/francois/development

if test -z $RESTIC_REPOSITORY
    logger -t development.bkp.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "development.bkp.fish -- RESTIC_REPOSITORY empty. Cannot proceed" | tee -a $log
    exit
end

if test -z $RESTIC_PASSWORD
    logger -t development.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "development.bkp.fish -- RESTIC_PASSWORD empty. Cannot proceed" | tee -a $log
    exit
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t development.bkp.fish "Source folder does not exist"
    echo "development.bkp.fish -- Source folder does not exist" | tee -a $log
    exit
end
echo "development.bkp.fish -- Source folder: $src" | tee -a $log

echo "development.bkp.fish -- Creating restic snapshot" | tee -a $log
restic backup \
    --host=raktar \
    --tag=development \
    --exclude='.venv' \
    --exclude='node_modules' \
    $src  | tee -a $log

if test $status -ne 0
    logger -t development.bkp.fish "There was an error during the snapshot"
    echo "development.bkp.fish -- There was an error during the snapshot" | tee -a $log
    exit
end
logger -t development.bkp.fish "Snapshot created successfully"
echo "development.bkp.fish -- Snapshot created successfully" | tee -a $log

echo "development.bkp.fish -- Forgetting snapshots" | tee -a $log
restic forget \
    --host=raktar \
    --tag=development \
    --keep-daily 7 \
    --keep-weekly 6 | tee -a $log
if test $status -ne 0
    logger -t development.bkp.fish "Unable to forget snapshots"
    echo "development.bkp.fish -- Unable to forget snapshots" | tee -a $log
    exit
end
echo "development.bkp.fish -- Snapshots forgotten successfully" | tee -a $log
