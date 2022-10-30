#! /usr/bin/fish

set nb_max 5
set src /home/francois/development
set dir (dirname $src)
set base (basename $src)
set dst /l/backup/raktar/development
set log /var/log/automation/development.tar.log
set arch $dst"/development."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"

date >>$log

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t development.bkp.fish "Source folder does not exist"
    echo "development.bkp.fish -- Source folder does not exist" >>$log
    exit
end

# if the destination folder does not exist, create it
if test ! -d "$dst"
    echo "development.bkp.fish -- Creating non-existent destination" >>$log
    mkdir -p "$dst" >>$log
end

echo "development.bkp.fish -- Creating archive" >>$log
tar --create \
    --exclude={'.venv', 'node_modules'} \
    --file="$arch" \
    --directory="$dir" "$base" \
    --verbose --gzip >>$log
if test $status -ne 0
    logger -t development.bkp.fish "Backup unsuccessful"
    echo "development.bkp.fish -- Backup unsuccessful" >>$log
    exit
end
logger -t development.bkp.fish "The backup was successful"
echo "development.bkp.fish -- The backup was successful" >>$log

alias backups="command ls -1trd $dst/development.*.tgz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    echo "development.bkp.fish -- Removing older archives" >>$log
    backups | head -n$nb_diff >>$log
    backups | head -n$nb_diff | xargs rm -f >>$log
end
echo \n---------------------------------------------- >>$log
