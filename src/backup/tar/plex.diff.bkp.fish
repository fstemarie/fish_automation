#! /usr/bin/fish

set src "/srv/plex"
set dst "/l/backup/sklad/plex"
set arch "$dst/plex.diff.tar.zst"
set snar "$dst/plex.diff.snar"
set log "/var/log/automation/plex.tar.log"
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
        error "Cannot create missing destination. Exiting..."
        exit 1
    end
end

# stop the container
set container (docker container ps --filter="name=$base" --format='{{.Names}}')
if contains "$container" "$base"
    set -g restart
    info "Stopping container $container"
    docker container stop "$container" > /dev/null
    if test $status -ne 0
        error "Unable to stop container $container"
        exit 1
    end
    docker wait "$container" > /dev/null
end

info "Copying snapshot file"
cp -f "$dst/plex.full.snar" "$snar" 2>&1 | tee -a $log

info "Changing permission on Preferences.xml"
sudo chmod a+r "$src/Library/Application Support/Plex Media Server/Preferences.xml" 2>&1 > /dev/null

info "Creating archive"
tar --create --zstd \
    --listed-incremental="$snar" \
    --exclude={'Cache', 'Logs', '.LocalAdminToken', 'Setup Plex.html'} \
    --file="$arch" \
    --directory="$dir" "$base" 2>&1 | tee -a $log
if test $status -ne 0
    error "Backup unsuccessful"
    exit 1
end
log "The backup was successful"

if set -q restart
    info "Restarting container $container"
    docker container start "$container" > /dev/null
    if test $status -ne 0
        error "Unable to start container $container"
    end
end
