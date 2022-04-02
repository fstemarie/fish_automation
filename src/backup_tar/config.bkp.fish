#! /usr/bin/fish

set nb_max 5
set src /data/config
set dst /l/backup/raktar/config
set arch $dst"/config."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t config.bkp.fish "Source folder does not exist"
    echo "config.bkp.fish -- Source folder does not exist"
    exit
end

# if the destination folder does not exist, create it
if test ! -d $dst
    echo "config.bkp.fish -- Creating non-existent destination"
    mkdir -p $dst
end

echo "config.bkp.fish -- Creating archive"
tar -cvzf $arch -C $src/.. config
if test $status -ne 0
    logger -t config.bkp.fish "Backup unsuccessful"
    echo "config.bkp.fish -- Backup unsuccessful"
    exit
end
logger -t config.bkp.fish "The backup was successful"
echo "config.bkp.fish -- The backup was successful"

alias backups="command ls -1trd $dst/config.*.tgz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    echo \n------------------------------------------
    echo "config.bkp.fish -- Removing older archives"
    backups | head -n$nb_diff
    backups | head -n$nb_diff | xargs rm -f
end
