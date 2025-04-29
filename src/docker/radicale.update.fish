#! /usr/bin/fish

set PJDIR "/home/francois/development/containers/radicale"
set LOG "/var/log/automation/radicale.update.log"

logger -t radicale.update.fish "[[ Running radicale.update.fish ]]"
echo "

-------------------------------------
[[ Running radicale.update.fish ]]
 "(date -Iseconds)"
-------------------------------------
" | tee -a $LOG

if test ! -d "$PJDIR"
    logger -t radicale.update.fish "non-existing project directory. Cannot proceed"
    echo "radicale.update.fish -- non-existing project directory. Cannot proceed" | tee -a $LOG
    exit 1
end

echo "radicale.update.fish -- Updating containers" | tee -a $LOG
pushd "$PJDIR"
docker compose pull
if test $status -ne 0
    logger -t radicale.update.fish "There was an error during the update"
    echo "radicale.update.fish -- There was an error during the update" | tee -a $LOG
    exit 1
end

echo "radicale.update.fish -- Restarting containers" | tee -a $LOG
docker compose up -d
if test $status -ne 0
    logger -t radicale.update.fish "There was an error while restarting containers"
    echo "radicale.update.fish -- There was an error while restarting containers" | tee -a $LOG
    exit 1
end
popd
echo "[[ End of Script ]]" | tee -a $LOG
