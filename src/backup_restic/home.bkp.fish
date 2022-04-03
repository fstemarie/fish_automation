#! /usr/bin/fish

if test -z $RESTIC_REPOSITORY
    logger -t home.bkp.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "home.bkp.fish -- RESTIC_REPOSITORY empty. Cannot proceed"
    exit
end

if test -z $RESTIC_PASSWORD
    logger -t home.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "home.bkp.fish -- RESTIC_PASSWORD empty. Cannot proceed"
    exit
end

set src /home/francois
# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t home.bkp.fish "Source folder does not exist"
    echo "home.bkp.fish -- Source folder does not exist"
    exit
end
echo "home.bkp.fish -- Source folder: $src"


echo "home.bkp.fish -- Creating restic snapshot"
restic backup \
    --tag home \
    --exclude '.cache' \
    --exclude '.vscode*' \
    --exclude 'development' \
    $src
if test $status -ne 0
    logger -t home.bkp.fish "There was an error during the snapshot"
    echo "home.bkp.fish -- There was an error during the snapshot"
    exit
end
logger -t home.bkp.fish "Snapshot created successfully"
echo "home.bkp.fish -- Snapshot created successfully"

echo "home.bkp.fish -- Forgetting snapshots"
restic forget --prune --tag home --keep-daily 14 --keep-monthly 6
if test $status -ne 0
    logger -t home.bkp.fish "Unable to forget snapshots"
    echo "home.bkp.fish -- Unable to forget snapshots"
    exit
end
echo "home.bkp.fish -- Snapshots forgotten successfully"
