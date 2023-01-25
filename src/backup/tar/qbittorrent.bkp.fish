#! /usr/bin/fish

set nb_max 5
set src /data/containers/qbittorrent
set dir (dirname $src)
set base (basename $src)
set dst /l/backup/raktar/qbittorrent
set log /var/log/automation/qbittorrent.tar.log
set arch $dst"/qbittorrent."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"

date >>$log

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d "$src"
    logger -t qbittorrent.bkp.fish "Source folder does not exist"
    echo "qbittorrent.bkp.fish -- Source folder does not exist" >>$log
    exit
end

# if the destination folder does not exist, create it
if test ! -d "$dst"
    echo "qbittorrent.bkp.fish -- Creating non-existent destination" >>$log
    mkdir -p "$dst" >>$log
end

echo "qbittorrent.bkp.fish -- Creating archive" >>$log
tar --create \
    --exclude={"logs", ".cache", "BT_backup", "ipc-socket", ".bash_history"} \
    --file="$arch" \
    --directory="$dir" "$base" \
    --verbose --gzip >>$log
if test $status -ne 0
    logger -t qbittorrent.bkp.fish "Backup unsuccessful"
    echo "qbittorrent.bkp.fish -- Backup unsuccessful" >>$log
    exit
end
logger -t qbittorrent.bkp.fish "The backup was successful"
echo "qbittorrent.bkp.fish -- The backup was successful" >>$log

alias backups="command ls -1trd $dst/qbittorrent.*.tgz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    echo \n----------------------------------------------- >>$log
    echo "qbittorrent.bkp.fish -- Removing older archives" >>$log
    backups | head -n$nb_diff >>$log
    backups | head -n$nb_diff | xargs rm -f >>$log
end
