#! /usr/bin/fish

if test -z $BORG_REPO
    logger -t development.rec.fish "BORG_REPO empty. Cannot proceed"
    echo "development.rec.fish -- BORG_REPO empty. Cannot proceed"
    exit
end

set src /home/francois/development

echo "development.bkp.fish -- Creating borg archive"
borg create --list --filter=AME --progress --compression lzma,9 -s \
    --exclude 'sh:**/.venv' \
    --exclude 'sh:**/node_modules' \
    $BORG_REPO::development.{now} $src

if test $status -ne 0
    logger -t development.bkp.fish "There was an error while creating the Borg archive"
    echo "development.bkp.fish -- There was an error while creating the Borg archive"
    exit
end
logger -t development.bkp.fish "Borg archive created successfully"
echo "development.bkp.fish -- Borg archive created successfully"

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
