#! /usr/bin/fish

set dst "/l/backup/raktar/mariadb"
set arch "$dst/mariadb."(date +%Y%m%dT%H%M%S | tr -d :-)".sql.gz"
set log "/var/log/automation/mariadb.tar.log"
set nb_max 5
set script (status basename)
set secret "/home/francois/.secrets/mariadb-backup.fish"

echo "


-------------------------------------
 "(date -Ins)" 
-------------------------------------
" | tee -a $log

# if the destination folder does not exist, create it
if test ! -d "$dst"
    echo "$script -- Creating non-existent destination" | tee -a $log
    mkdir -p "$dst"
    if test $status -ne 0
        logger -t $script "Cannot create missing destination. Exiting..."
        echo "$script -- Cannot create missing destination. Exiting..."
        exit 1
    end
end

if test -e "$secret"
    echo "$script -- Sourcing password"
    source "$secret"
    if test $status -ne 0
        logger -t $script "Cannot source password. Exiting..."
        echo "$script -- Cannot source password. Exiting..."
        exit 1
    end
end


echo "$script -- Creating archive" | tee -a $log
docker exec mariadb mariadb-dump \
    --user=$user \
    --password=$password \
    --all-databases | gzip > "$arch"
if test $status -ne 0
    logger -t $script "Backup unsuccessful"
    echo "$script -- Backup unsuccessful" | tee -a $log
    exit 1
end
logger -t $script "The backup was successful"
echo "$script -- The backup was successful" | tee -a $log

alias backups="command ls -1trd $dst/mariadb.*.sql.gz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    echo "$script -- Removing older archives" | tee -a $log
    backups | head -n$nb_diff | tee -a $log
    backups | head -n$nb_diff | xargs rm -f > /dev/null
end
echo \n---------------------------------------------- | tee -a $log
