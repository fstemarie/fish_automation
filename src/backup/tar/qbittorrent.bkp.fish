#! /usr/bin/fish

set src "/data/containers/qbittorrent"
set dst "/l/backup/raktar/qbittorrent"
set arch "$dst/qbittorrent."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"
set log "/var/log/automation/qbittorrent.tar.log"
set nb_max 5
set dir (dirname "$src")
set base (basename "$src")
set script (status basename)

date | tee -a $log

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d "$src"
    logger -t $script "Source folder does not exist"
    echo "$script -- Source folder does not exist" | tee -a $log
    exit 1
end

# if the destination folder does not exist, create it
if test ! -d "$dst"
    echo "$script -- Creating non-existent destination" | tee -a $log
    mkdir -p "$dst"
    if test $status -ne 0
        logger -t $script "Cannot create missing destination. Exiting..."
        echo "$script -- Cannot create missing destination. Exiting..."
        exit 1
    end
end

echo "$script -- Creating archive" | tee -a $log
tar --create --verbose --gzip \
    --file="$arch" \
    --exclude={".*", "BT_backup", "GeoDB", "ipc-socket", "lockfile", "logs", "qBittorrent-conf.json", "__pycache__"} \
    --directory="$dir" "$base"  2>&1 | tee -a $log
if test $status -ne 0
    logger -t $script "Backup unsuccessful"
    echo "$script -- Backup unsuccessful" | tee -a $log
    exit 1
end
logger -t $script "The backup was successful"
echo "$script -- The backup was successful" | tee -a $log

alias backups="command ls -1trd $dst/qbittorrent.*.tgz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    echo \n----------------------------------------------- | tee -a $log
    echo "$script -- Removing older archives" | tee -a $log
    backups | head -n$nb_diff | tee -a $log
    backups | head -n$nb_diff | xargs rm -f > /dev/null
end
