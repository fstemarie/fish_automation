#! /usr/bin/fish

set src /home/francois
set BORG_REPO /l/backup/raktar/borg

logger -t home.bkp.fish "Creating borg archive"
echo "home.bkp.fish -- Creating borg archive"
borg create --list --filter=AME --progress --compression lzma,9 -s \
    --exclude '/home/francois/.cache' \
    --exclude '/home/francois/.vscode*' \
    --exclude /home/francois/development \
    $BORG_REPO::home.{now} $src

if test $status -ne 0
    logger -t home.bkp.fish "There was an error while creating the Borg archive"
    echo "home.bkp.fish -- There was an error while creating the Borg archive"
    exit
end
echo "home.bkp.fish -- Borg archive created successfully"


logger -t home.bkp.fish "Pruning borg archive"
echo "home.bkp.fish -- Pruning borg archive"
borg prune -s --list --save-space --prefix home. \
    --keep-daily 14 --keep-monthly 6 \
    $BORG_REPO
if test $status -ne 0
    logger -t home.bkp.fish "Unable to prune Borg archives"
    echo "home.bkp.fish -- Unable to prune Borg archives"
    exit
end
echo "home.bkp.fish -- Borg archives pruned successfully"
