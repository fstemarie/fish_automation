#! /usr/bin/fish

set src /home/francois/development
set BORG_REPO /l/backup/raktar/borg

logger -t development.bkp.fish "Creating borg archive"
echo "development.bkp.fish -- Creating borg archive"
borg create --list --filter=AME --progress --compression lzma,9 -s \
    $BORG_REPO::development.{now} $src

if test $status -ne 0
    logger -t development.bkp.fish "There was an error while creating the Borg archive"
    echo "development.bkp.fish -- There was an error while creating the Borg archive"
    exit
end
echo "development.bkp.fish -- Borg archive created successfully"


logger -t development.bkp.fish "Pruning borg archive"
echo "development.bkp.fish -- Pruning borg archive"
borg prune -s --list --save-space --prefix development. \
    --keep-daily 14 --keep-monthly 6 \
    $BORG_REPO
if test $status -ne 0
    logger -t development.bkp.fish "Unable to prune Borg archives"
    echo "development.bkp.fish -- Unable to prune Borg archives"
    exit
end
echo "development.bkp.fish -- Borg archives pruned successfully"
