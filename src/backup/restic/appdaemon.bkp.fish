#! /usr/bin/fish

set src "/data/containers/appdaemon"
set log "/var/log/automation/appdaemon.restic.log"
set script (status basename)

source (status dirname)/../../log.fish

echo "

-------------------------------------
[[ Running $script ]]
"(date -Iseconds)"
-------------------------------------
" | tee -a $log

if test -z "$RESTIC_REPOSITORY"
    error "RESTIC_REPOSITORY empty. Cannot proceed"
    exit 1
end

if test -z "$RESTIC_PASSWORD_FILE" || ! test -e "$RESTIC_PASSWORD_FILE"
    error "RESTIC_PASSWORD_FILE empty or does not exist. Cannot proceed"
    exit 1
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d "$src"
    error "Source folder does not exist. Cannot proceed"
    exit 1
end

info "Source folder: $src"
info "Creating restic snapshot"
pushd "$src"
restic backup \
    --host=raktar \
    --tag=appdaemon \
    --exclude='__pycache__' \
    .  2>&1 | tee -a $log
if test $status -ne 0
    error "There was an error during the snapshot"
    exit 1
end
popd
log "Snapshot created successfully"

info "Forgetting snapshots"
restic forget \
    --host=raktar \
    --tag=appdaemon \
    --keep-last=3 2>&1 | tee -a $log
if test $status -ne 0
    error "Unable to forget snapshots"
    exit 1
end
log "Snapshots forgotten successfully"
