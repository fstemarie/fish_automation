#! /usr/bin/fish

set src "/data/containers/nodered"
set dst "/l/backup/raktar/nodered"
set arch "$dst/nodered."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"
set log "/var/log/automation/nodered.tar.log"
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

info "Creating archive $arch"
tar --create --verbose --gzip \
    --file="$arch" \
    --exclude={'node_modules', '.git', '.npm'} \
    --directory="$dir" "$base"  2>&1 | tee -a $log
if test $status -ne 0
    error "Backup unsuccessful"
    exit 1
end
log "The backup was successful"

# Restart the container
if set -q restart
    info "Restarting container $container"
    docker container start "$container" > /dev/null
    if test $status -ne 0
        error "Unable to start container $container"
    end
end

alias backups="command ls -1trd $dst/nodered.*.tgz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    info "Removing older archives"
    backups | head -n$nb_diff | tee -a $log
    backups | head -n$nb_diff | xargs rm -f > /dev/null
end
