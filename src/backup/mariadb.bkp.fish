#! /usr/bin/fish

set dst "/l/backup/raktar/mariadb"
set arch "$dst/mariadb."(date +%Y%m%dT%H%M%S | tr -d :-)".sql.gz"
set log "/var/log/automation/mariadb.tar.log"
set nb_max 5
set secret_file "/home/francois/.secrets/mariadb-backup.fish"
set script (status basename)

source (status dirname)/../log.fish

echo "


-------------------------------------
 "(date -Iseconds)" 
-------------------------------------
" | tee -a $log

# if the destination folder does not exist, create it
if test ! -d "$dst"
    log "Creating non-existent destination" only_echo
    mkdir -p "$dst"
    if test $status -ne 0
        log "Cannot create missing destination. Exiting..."
        exit 1
    end
end

if test -e "$secret_file"
    log "Sourcing password" only_echo
    set user "backup"
    read password < $secret_file
    if test $status -ne 0
        log "Cannot source password. Exiting..."
        exit 1
    end
end

log "Creating archive" only_echo
docker exec mariadb mariadb-dump \
    --user=$user \
    --password=$password \
    --all-databases | gzip > "$arch"
if test $status -ne 0
    log "Backup unsuccessful"
    exit 1
end
log "The backup was successful"

alias backups="command ls -1trd $dst/mariadb.*.sql.gz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    log "Removing older archives" only_echo
    backups | head -n$nb_diff | tee -a $log
    backups | head -n$nb_diff | xargs rm -f > /dev/null
end
echo "-------------------------------------
" | tee -a $log
