#! /usr/bin/fish

set PJDIR "/home/francois/development/containers/mariadb"
set LOG "/var/log/automation/mariadb.update.log"

logger -t mariadb.update.fish "[[ Running mariadb.update.fish ]]"
echo "

-------------------------------------
[[ Running mariadb.update.fish ]]
 "(date -Iseconds)"
-------------------------------------
" | tee -a $LOG

if test ! -d "$PJDIR"
    logger -t mariadb.update.fish "Non existing project directory. Cannot proceed"
    echo "mariadb.update.fish -- Non existing project directory. Cannot proceed" | tee -a $LOG
    exit 1
end

echo "mariadb.update.fish -- Updating containers" | tee -a $LOG
pushd "$PJDIR"
docker compose pull
if test $status -ne 0
    logger -t mariadb.update.fish "There was an error during the update"
    echo "mariadb.update.fish -- There was an error during the update" | tee -a $LOG
    exit 1
end

echo "mariadb.update.fish -- Restarting containers" | tee -a $LOG
docker compose up -d
if test $status -ne 0
    logger -t mariadb.update.fish "There was an error while restarting containers"
    echo "mariadb.update.fish -- There was an error while restarting containers" | tee -a $LOG
    exit 1
end
popd
echo "[[ End of Script ]]" | tee -a $LOG
