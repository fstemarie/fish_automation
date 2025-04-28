#! /usr/bin/fish

set src "/l/backup/raktar/plex"
set dst "/data/containers/plex"
set arch (command ls -1dr $src/plex.*.tgz | head -n1)
set script (status basename)

source (status dirname)/../../log.fish

# if archive does not exist, exit
if test ! -f "$arch"
    log "Archive not found"
    exit 1
end
log "Using archive: $arch" only_echo

# Append date to name to avoid data loss
if test -d "$dst"
    log "Destination already exists"

    set old "$dst"
    set dst "$old."(date +%s)
    while test -d "$dst"
        sleep 2
        set dst "$old."(date +%s)
    end
end

# Create non-existing destination
log "Creating non existent destination" only_echo
mkdir -p "$dst"
if test $status -ne 0
    log "Cannot create missing destination. Exiting..."
    exit 1
end

# Recover data from archive
log "Recovering..." only_echo
tar --extract --verbose --gzip \
    --file="$arch" \
    --directory="$dst" \
    --strip=1
if test $status -ne 0
    log "Recovery unsuccessful"
    exit 1
end
log "The recovery was successful"
