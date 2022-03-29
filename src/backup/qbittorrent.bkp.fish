#! /usr/bin/fish

set nb_max_backups 5
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
tar -cvzf $arch -C $src/.. qbittorrent
if test $status -eq 0
    logger -t qbittorrent.rec.fish "The backup was successful"
    echo "qbittorrent.rec.fish -- The backup was successful"

    set nb_backups (command ls -1trd $dst/qbittorrent.*.tgz | wc -l)
    set nb_backups_todelete (math $nb_backups - $nb_max_backups)
    if test $nb_backups_todelete -gt 0
        echo "qbittorrent.bkp.fish -- Removing older archives"
        command ls -1trd $dst/qbittorrent.*.tgz \
            | head -n$nb_backups_todelete \
            | xargs rm -f
    end
else
    logger -t qbittorrent.rec.fish "Backup unsuccessful"
    echo "qbittorrent.rec.fish -- Backup unsuccessful"
end
