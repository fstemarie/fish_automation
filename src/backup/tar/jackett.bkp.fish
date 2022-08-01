#! /usr/bin/fish

set nb_max 5
set src /data/containers/jackett
set dst /l/backup/raktar/containers/jackett
set log /var/log/automation/jackett.tar.log

date >>$log

set arc $dst"/jackett."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"
# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t jackett.bkp.fish "Source folder does not exist"
    echo "jackett.bkp.fish -- Source folder does not exist" >>$log
    exit
end

# if the destination folder does not exist, create it
if test ! -d $dst
    echo "jackett.bkp.fish -- Creating non-existent destination" >>$log
    mkdir -p $dst
end

echo "jackett.bkp.fish -- Creating archive" >>$log
tar -cvzf $arc -C $src/.. jackett >>$log
if test $status -ne 0
    logger -t jackett.bkp.fish "Backup unsuccessful"
    echo "jackett.bkp.fish -- Backup unsuccessful" >>$log
    exit
end
logger -t jackett.bkp.fish "The backup was successful"
echo "jackett.bkp.fish -- The backup was successful" >>$log

alias backups="command ls -1trd $dst/jackett.*.tgz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    echo \n------------------------------------------- >>$log
    echo "jackett.bkp.fish -- Removing older archives" >>$log
    backups | head -n$nb_diff >>$log
    backups | head -n$nb_diff | xargs rm -f >>$log
end
