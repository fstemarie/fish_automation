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

set src /home/francois/development

echo "development.bkp.fish -- Creating restic snapshot"
restic backup \
    --tag development
    --exclude '.venv' \
    --exclude 'node_modules' \
    $src

if test $status -ne 0
    logger -t development.bkp.fish "There was an error during the snapshot"
    echo "development.bkp.fish -- There was an error during the snapshot"
    exit
end
logger -t development.bkp.fish "Snapshot created successfully"
echo "development.bkp.fish -- Snapshot created successfully"

echo "development.bkp.fish -- Forgetting snapshots"
restic forget --prune --tag development --keep-daily 14 --keep-monthly 6
if test $status -ne 0
    logger -t development.bkp.fish "Unable to forget snapshots"
    echo "development.bkp.fish -- Unable to forget snapshots"
    exit
end
echo "development.bkp.fish -- Snapshots forgotten successfully"
