#! /usr/bin/fish

set src "/srv/appdaemon"
set dst "/l/backup/sklad/appdaemon"
set arch "$dst/appdaemon."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"
set log "/var/log/automation/appdaemon.tar.log"
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
    error "Source folder does not exist"
    exit 1
end

# if the destination folder does not exist, create it
if test ! -d "$dst"
    log "Creating non-existing destination"
    mkdir -p "$dst"
    if test $status -ne 0
        error "Cannot create missing destination"
        exit 1
    end
end

info "Creating archive $arch"
tar --create --verbose --gzip \
    --file="$arch" \
    --exclude={'__pycache__', '.git', '.local', '.venv', '.cache'} \
    --directory="$dir" "$base"  2>&1 | tee -a $log
if test $status -ne 0
    error "Backup unsuccessful"
    exit 1
end
log "Backup successful"

alias backups="command ls -1trd $dst/appdaemon.*.tgz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    info "Removing older archives" | tee -a $log
    backups | head -n$nb_diff | tee -a $log
    backups | head -n$nb_diff | xargs rm -f > /dev/null
end
