#! /usr/bin/fish

set PJDIR "/home/francois/development/containers/pirateisland"
set LOG "/var/log/automation/pirateisland.update.log"

logger -t pirateisland.update.fish "[[ Running pirateisland.update.fish ]]"
echo "

-------------------------------------
[[ Running pirateisland.update.fish ]]
 "(date -Iseconds)"
-------------------------------------
" | tee -a $LOG

if test ! -d "$PJDIR"
    logger -t pirateisland.update.fish "Non existing project directory. Cannot proceed"
    echo "pirateisland.update.fish -- Non existing project directory. Cannot proceed" | tee -a $LOG
    exit 1
end

echo "pirateisland.update.fish -- Updating containers" | tee -a $LOG
pushd "$PJDIR"
docker compose pull
if test $status -ne 0
    logger -t pirateisland.update.fish "There was an error during the update"
    echo "pirateisland.update.fish -- There was an error during the update" | tee -a $LOG
    exit 1
end

echo "pirateisland.update.fish -- Restarting containers" | tee -a $LOG
docker compose up -d
if test $status -ne 0
    logger -t pirateisland.update.fish "There was an error while restarting containers"
    echo "pirateisland.update.fish -- There was an error while restarting containers" | tee -a $LOG
    exit 1
end
popd
echo "[[ End of Script ]]" | tee -a $LOG
