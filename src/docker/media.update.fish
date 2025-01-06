#! /usr/bin/fish

set PJDIR "/home/francois/development/containers/media"
set LOG "/var/log/automation/media.update.log"

logger -t media.update.fish "[[ Running media.update.fish ]]"
echo "

-------------------------------------
[[ Running media.update.fish ]]
 "(date -Iseconds)"
-------------------------------------
" | tee -a $LOG

if test ! -d "$PJDIR"
    logger -t media.update.fish "Non existing project directory. Cannot proceed"
    echo "media.update.fish -- Non existing project directory. Cannot proceed" | tee -a $LOG
    exit 1
end

echo "media.update.fish -- Updating containers" | tee -a $LOG
pushd "$PJDIR"
docker compose pull
if test $status -ne 0
    logger -t media.update.fish "There was an error during the update"
    echo "media.update.fish -- There was an error during the update" | tee -a $LOG
    exit 1
end

echo "media.update.fish -- Restarting containers" | tee -a $LOG
docker compose up -d
if test $status -ne 0
    logger -t media.update.fish "There was an error while restarting containers"
    echo "media.update.fish -- There was an error while restarting containers" | tee -a $LOG
    exit 1
end
popd
echo "[[ End of Script ]]" | tee -a $LOG
