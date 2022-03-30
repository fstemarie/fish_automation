#! /usr/bin/fish

set nb_max 5
set src /data/automation
set dst /l/backup/raktar/automation
set arch $dst"/automation."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t automation.bkp.fish "Source folder does not exist"
    echo "automation.bkp.fish -- Source folder does not exist"
    exit
end

# if the destination folder does not exist, create it
if test ! -d $dst
    echo "automation.bkp.fish -- Creating non-existent destination"
    mkdir -p $dst
end

echo "automation.bkp.fish -- Creating archive"
tar -cvzf $arch -C $src/.. automation
if test $status -ne 0
    logger -t automation.rec.fish "Backup unsuccessful"
    echo "automation.rec.fish -- Backup unsuccessful"
end
logger -t automation.rec.fish "The backup was successful"
echo "automation.rec.fish -- The backup was successful"

alias backups="command ls -1trd $dst/automation.*.tgz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    echo \n----------------------------------------------
    echo "automation.bkp.fish -- Removing older archives"
    backups | head -n$nb_diff
    backups | head -n$nb_diff | xargs rm -f
end
