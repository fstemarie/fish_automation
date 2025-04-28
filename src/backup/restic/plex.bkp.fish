#! /usr/bin/fish

set src "/data/containers/plex"
set log "/var/log/automation/plex.restic.log"
set file "Library/Application Support/Plex Media Server/Preferences.xml"
set script (status basename)

source (status dirname)/../../log.fish

echo "


-------------------------------------
[[ Running $script ]]
"(date -Iseconds)"
-------------------------------------
" | tee -a $log

if test -z $RESTIC_REPOSITORY
    log "RESTIC_REPOSITORY empty. Cannot proceed"
    exit 1
end

if test -z $RESTIC_PASSWORD_FILE or test ! -e $RESTIC_PASSWORD_FILE 
    log "RESTIC_PASSWORD_FILE empty or does not exist. Cannot proceed"
    exit 1
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d "$src"
    log "Source folder does not exist"
    exit 1
end
log "Source folder: $src" only_echo

log "Creating restic snapshot" only_echo
sudo chmod g+rw "$src/$file"
pushd "$src"
restic backup \
    --host=raktar \
    --tag=plex \
    "$file"  2>&1 | tee -a $log
if test $status -ne 0
    log "There was an error during the snapshot"
    exit 1
end
popd
log "Snapshot created successfully"

log "Forgetting snapshots" only_echo
restic forget \
    --host=raktar \
    --tag=plex \
    --keep-last=1 2>&1 | tee -a $log
if test $status -ne 0
    log "Unable to forget snapshots"
    exit 1
end
log "Snapshots forgotten successfully" only_echo
