#! /usr/bin/fish

set nb_max 5
set src /data/containers/qbittorrent
set dst /l/backup/raktar/containers/qbittorrent
set arch $dst"/qbittorrent."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"


# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t qbittorrent.bkp.fish "Source folder does not exist"
    echo "qbittorrent.bkp.fish -- Source folder does not exist"
    exit
end

# if the destination folder does not exist, create it
if test ! -d $dst
    echo "qbittorrent.bkp.fish -- Creating non-existent destination"
    mkdir -p $dst
end

echo "qbittorrent.bkp.fish -- Creating archive"
tar --create --verbose --gzip --file $arch --directory $src/.. \
    --exclude={"logs", ".cache", "BT_backup", "ipc-socket"} \
    qbittorrent

if test $status -ne 0
    logger -t qbittorrent.bkp.fish "Backup unsuccessful"
    echo "qbittorrent.bkp.fish -- Backup unsuccessful"
    exit
end
logger -t qbittorrent.bkp.fish "The backup was successful"
echo "qbittorrent.bkp.fish -- The backup was successful"

alias backups="command ls -1trd $dst/qbittorrent.*.tgz"
set nb_tot (backups | count)
set nb_diff (math $nb_tot - $nb_max)
if test $nb_diff -gt 0
    echo \n-----------------------------------------------
    echo "qbittorrent.bkp.fish -- Removing older archives"
    backups | head -n$nb_diff
    backups | head -n$nb_diff | xargs rm -f
end
