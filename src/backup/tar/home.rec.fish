#! /usr/bin/fish

set src "/l/backup/raktar/home"
# Append date to destination name to avoid data loss
set dst "$HOME/home."(date +%s)
set arch (command ls -1dr "$src/home.*.tgz" | head -n1)
set script (status basename)

source (status dirname)/../../log.fish

# if archive does not exist, exit
if test ! -f "$arch"
    log "Archive not found"
    exit 1
end
log "Using archive: $arch" only_echo

# if target destination does not exist, create it
if test ! -d "$dst"
    log "Creating non existent destination: $dst" only_echo
    mkdir -p "$dst"
    if test $status -ne 0
        log "Cannot create missing destination. Exiting..."
        exit 1
    end
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
