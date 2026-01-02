#! /usr/bin/env fish

set src "/l/backup/"
set dst backup:/
set log "/var/log/automation/backups.rclone.log"
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

# Verify rclone remote exists
set remote (string split ':' $dst)[1]
if not rclone listremotes | grep -Fxq "$remote:"
    logger -t $script "Rclone remote '$remote' not found. Exiting..."
    echo "$script -- Rclone remote '$remote' not found. Exiting..."
    exit 1
end

# Verify destination path exists on the rclone remote
rclone lsd "$dst" >/dev/null 2>&1
if test $status -ne 0
    logger -t $script "Rclone path '$dst' not found on remote '$remote'. Exiting..."
    echo "$script -- Rclone path '$dst' not found on remote '$remote'. Exiting..."
    exit 1
end

# if the destination folder does not exist, create it
if test ! -d "$dst"
    log "Creating non-existing destination"
    mkdir -p "$dst"
    if test $status -ne 0
        logger -t $script "Cannot create missing destination. Exiting..."
        echo "$script -- Cannot create missing destination. Exiting..."
        exit 1
    end
end

# Verify destination is writable
if test ! -w "$dst"
    logger -t $script "Destination not writable"
    echo "$script -- Destination not writable"
    exit 1
end

info "Syncing backups to rclone remote"
rclone sync "$src" "$dst" \
    --log-level=INFO \
    --exclude "HX90/eBooks/" \
    --delete-excluded 2>&1 | tee -a $log
if test $status -ne 0
    error "Rclone sync unsuccessful"
    exit 1
end
info "Rclone sync successful"
