#! /usr/bin/fish

# Append date to destination name to avoid data loss
set dst "$HOME/home."(date +%s)
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

# if target destination does not exist, create it
if test ! -d "$dst"
    log "Creating non existent destination"
    mkdir -p "$dst"
    if test $status -ne 0
        log "Cannot create missing destination. Exiting..."
        exit 1
    end
end

# Recover data from archive
restic restore latest \
    --host=raktar \
    --tag=home \
    --target "$dst"
if test $status -ne 0
    log "Could not restore snapshot"
    exit 1
end
log "Snapshot restoration successful"
