#! /usr/bin/fish

set src "/data/config"
set dst "/l/backup/raktar/config"
set arch "$dst/config."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"
set log "/var/log/automation/config.tar.log"
set nb_max 5
set dir (dirname "$src")
set base (basename "$src")
set script (status basename)

source (status dirname)/../../log.fish

echo "

-------------------------------------
[[ Running $script ]]
"(date -Iseconds)"
-------------------------------------
" | tee -a $log

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d "$src"
    log "Source folder does not exist"
    exit 1
end

# if the destination folder does not exist, create it
if test ! -d "$dst"
    info "Creating non-existing destination"
    mkdir -p "$dst"
    if test $status -ne 0
        log "Cannot create missing destination"
        exit 1
    end
end

info "Creating archive"
tar --create --verbose --gzip \
    --file="$arch" \
    --directory="$dir" "$base"  2>&1 | tee -a $log
if test $status -ne 0
    log "Backup unsuccessful"
    exit 1
end
log "The backup was successful"

alias backups="command ls -1trd $dst/config.*.tgz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    info "Removing older archives"
    backups | head -n$nb_diff | tee -a $log
    backups | head -n$nb_diff | xargs rm -f > /dev/null
end
