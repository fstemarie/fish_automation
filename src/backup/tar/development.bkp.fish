#! /usr/bin/fish

set nb_max 5
set src /home/francois/development
set dir (dirname $src)
set base (basename $src)
set dst /l/backup/raktar/development
set log /var/log/automation/development.tar.log
set arch $dst"/development."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"

date | tee -a $log

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t development.bkp.fish "Source folder does not exist"
    echo "development.bkp.fish -- Source folder does not exist" | tee -a $log
    exit
end

# if the destination folder does not exist, create it
if test ! -d "$dst"
    echo "development.bkp.fish -- Creating non-existent destination" | tee -a $log
    mkdir -p "$dst" | tee -a $log
end

echo "development.bkp.fish -- Creating archive" | tee -a $log
tar --create \
    --exclude={'.venv', 'node_modules'} \
    --file="$arch" \
    --directory="$dir" "$base" \
    --verbose --gzip | tee -a $log
if test $status -ne 0
    logger -t development.bkp.fish "Backup unsuccessful"
    echo "development.bkp.fish -- Backup unsuccessful" | tee -a $log
    exit
end
logger -t development.bkp.fish "The backup was successful"
echo "development.bkp.fish -- The backup was successful" | tee -a $log

alias backups="command ls -1trd $dst/development.*.tgz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    echo "development.bkp.fish -- Removing older archives" | tee -a $log
    backups | head -n$nb_diff | tee -a $log
    backups | head -n$nb_diff | xargs rm -f | tee -a $log
end
echo \n---------------------------------------------- | tee -a $log
