#! /usr/bin/fish

set dst "/l/backup/sklad/mariadb"
set arch "$dst/mariadb."(date +%Y%m%dT%H%M%S | tr -d :-)".sql.gz"
set log "/var/log/automation/mariadb.tar.log"
set nb_max 5
set secret_file "/home/francois/.secrets/mariadb-backup.fish"
set script (status basename)

source (status dirname)/../log.fish

echo "


-------------------------------------
[[ Running $script ]]
"(date -Iseconds)"
-------------------------------------
" | tee -a $log

if test -e "$secret_file"
    info "Sourcing password" 
    set user "backup"
    read password < $secret_file
    if test $status -ne 0
        error "Cannot source password. Exiting..."
        exit 1
    end
end

# if the destination folder does not exist, create it
if test ! -d "$dst"
    log "Creating non-existing destination"
    mkdir -p "$dst"
    if test $status -ne 0
        error "Cannot create missing destination. Exiting..."
        exit 1
    end
end

info "Creating archive"
docker exec mariadb mariadb-dump \
    --user=$user \
    --password=$password \
    --all-databases | gzip > "$arch"
if test $status -ne 0
    error "Backup unsuccessful"
    exit 1
end
log "The backup was successful"

alias backups="command ls -1trd $dst/mariadb.*.sql.gz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    info "Removing older archives"
    backups | head -n$nb_diff | tee -a $log
    backups | head -n$nb_diff | xargs rm -f > /dev/null
end
