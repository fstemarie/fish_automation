#! /usr/bin/fish

set nb_max 5
set src /data/containers/jackett
set dir (dirname $src)
set base (basename $src)
set dst /l/backup/raktar/jackett
set log /var/log/automation/jackett.tar.log
set arch $dst"/jackett."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"

date | tee -a $log

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d "$src"
    logger -t jackett.bkp.fish "Source folder does not exist"
    echo "jackett.bkp.fish -- Source folder does not exist" | tee -a $log
    exit
end

# if the destination folder does not exist, create it
if test ! -d "$dst"
    echo "jackett.bkp.fish -- Creating non-existent destination" | tee -a $log
    mkdir -p "$dst"
end

echo "jackett.bkp.fish -- Creating archive" | tee -a $log
tar --create \
    --file="$arch" \
    --exclude={'log.txt*', 'updater.txt*'} \
    --exclude='DataProtection' \
    --directory="$dir" "$base" \
    --verbose --gzip | tee -a $log
if test $status -ne 0
    logger -t jackett.bkp.fish "Backup unsuccessful"
    echo "jackett.bkp.fish -- Backup unsuccessful" | tee -a $log
    exit
end
logger -t jackett.bkp.fish "The backup was successful"
echo "jackett.bkp.fish -- The backup was successful" | tee -a $log

alias backups="command ls -1trd $dst/jackett.*.tgz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    echo \n------------------------------------------- | tee -a $log
    echo "jackett.bkp.fish -- Removing older archives" | tee -a $log
    backups | head -n$nb_diff | tee -a $log
    backups | head -n$nb_diff | xargs rm -f | tee -a $log
end
