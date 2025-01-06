#! /usr/bin/fish

set PJDIR "/home/francois/development/containers/iot"
set LOG "/var/log/automation/iot.update.log"

logger -t iot.update.fish "[[ Running iot.update.fish ]]"
echo "

-------------------------------------
[[ Running iot.update.fish ]]
 "(date -Iseconds)"
-------------------------------------
" | tee -a $LOG

if test ! -d "$PJDIR"
    logger -t iot.update.fish "Non existing project directory. Cannot proceed"
    echo "iot.update.fish -- Non existing project directory. Cannot proceed" | tee -a $LOG
    exit 1
end

echo "iot.update.fish -- Updating containers" | tee -a $LOG
pushd "$PJDIR"
docker compose pull
if test $status -ne 0
    logger -t iot.update.fish "There was an error during the update"
    echo "iot.update.fish -- There was an error during the update" | tee -a $LOG
    exit 1
end

echo "iot.update.fish -- Restarting containers" | tee -a $LOG
docker compose up -d
if test $status -ne 0
    logger -t iot.update.fish "There was an error while restarting containers"
    echo "iot.update.fish -- There was an error while restarting containers" | tee -a $LOG
    exit 1
end
popd
echo "[[ End of Script ]]" | tee -a $LOG
