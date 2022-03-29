#! /usr/bin/fish

if test -z $BORG_REPO
    logger -t home.rec.fish "BORG_REPO empty. Cannot proceed"
    echo "home.rec.fish -- BORG_REPO empty. Cannot proceed"
    exit
end

set src /home/francois

logger -t home.bkp.fish "Creating borg archive"
echo "home.bkp.fish -- Creating borg archive"
borg create --list --filter=AME --progress --compression lzma,9 -s \
    --exclude '/home/francois/.cache' \
    --exclude '/home/francois/.vscode*' \
    --exclude '/home/francois/development' \
    $BORG_REPO::home.{now} $src

if test $status -ne 0
    logger -t home.bkp.fish "There was an error while creating the Borg archive"
    echo "home.bkp.fish -- There was an error while creating the Borg archive"
    exit
end
echo "home.bkp.fish -- Borg archive created successfully"

echo "home.bkp.fish -- Pruning borg archive"
borg prune -s --list --save-space --prefix home. \
    --keep-last 5 --keep-daily 14 --keep-monthly 6 \
    $BORG_REPO
if test $status -ne 0
    logger -t home.bkp.fish "Unable to prune Borg archives"
    echo "home.bkp.fish -- Unable to prune Borg archives"
    exit
end
echo "home.bkp.fish -- Borg archives pruned successfully"
