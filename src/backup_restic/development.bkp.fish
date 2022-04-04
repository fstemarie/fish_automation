#! /usr/bin/fish

if test -z $RESTIC_REPOSITORY
    logger -t development.bkp.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "development.bkp.fish -- RESTIC_REPOSITORY empty. Cannot proceed"
    exit
end

if test -z $RESTIC_PASSWORD
    logger -t development.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "development.bkp.fish -- RESTIC_PASSWORD empty. Cannot proceed"
    exit
end

set log /var/log/automation/development.restic.log
set src /home/francois/development
# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t home.bkp.fish "Source folder does not exist"
    echo "home.bkp.fish -- Source folder does not exist"
    exit
end
echo "development.bkp.fish -- Source folder: $src" >>$log

echo "development.bkp.fish -- Creating restic snapshot" >>$log
restic backup \
    --tag development
    --exclude '.venv' \
    --exclude 'node_modules' \
    $src  >>$log

if test $status -ne 0
    logger -t development.bkp.fish "There was an error during the snapshot"
    echo "development.bkp.fish -- There was an error during the snapshot" >>$log
    exit
end
logger -t development.bkp.fish "Snapshot created successfully"
echo "development.bkp.fish -- Snapshot created successfully" >>$log

echo "development.bkp.fish -- Forgetting snapshots" >>$log
restic forget --prune --tag development --keep-daily 14 --keep-monthly 6 >>$log
if test $status -ne 0
    logger -t development.bkp.fish "Unable to forget snapshots"
    echo "development.bkp.fish -- Unable to forget snapshots" >>$log
    exit
end
echo "development.bkp.fish -- Snapshots forgotten successfully" >>$log
