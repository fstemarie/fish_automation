#! /usr/bin/fish

set dst "/data/config"
set script (status basename)

source (status dirname)/../../log.fish

if test -z $RESTIC_REPOSITORY
    log "RESTIC_REPOSITORY empty. Cannot proceed"
    exit 1
end

if test -z $RESTIC_PASSWORD_FILE or test ! -e $RESTIC_PASSWORD_FILE 
    log "RESTIC_PASSWORD_FILE empty or does not exist. Cannot proceed"
    exit 1
end

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
restic restore latest \
    --host=raktar \
    --tag=config \
    --target "$dst"
if test $status -ne 0
    log "Could not restore snapshot"
    exit 1
end
log "Snaphot restoration successful"
