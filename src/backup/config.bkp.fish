#! /usr/bin/fish

set nb_max_backups 5
set src /data/config
set dst /l/backup/raktar/config
set arch $dst"/config."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t config.bkp.fish "Source folder does not exist"
    echo "config.bkp.fish -- Source folder does not exist"
    exit
end

# if the destination folder does not exist, create it
if test ! -d $dst
    echo "config.bkp.fish -- Creating non-existent destination"
    mkdir -p $dst
end

echo "config.bkp.fish -- Creating archive"
tar -cvzf $arch -C $src/.. config
if test $status -eq 0
    logger -t config.rec.fish "The recovery was successful"
    echo "config.rec.fish -- The recovery was successful"
    set nb_backups (command ls -1trd $dst/config.*.tgz | wc -l)
    set nb_backups_todelete (math $nb_backups - $nb_max_backups)
    if test $nb_backups_todelete -gt 0
        echo "config.bkp.fish -- Removing older archives"
        command ls -1trd $dst/config.*.tgz \
            | head -n$nb_backups_todelete \
            | xargs rm -f
    end
else
    logger -t config.rec.fish "Recovery unsuccessful"
    echo "config.rec.fish -- Recovery unsuccessful"
end
