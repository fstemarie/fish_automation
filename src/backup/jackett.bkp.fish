#! /usr/bin/fish

set nb_max_backups 5
set src /data/containers/jackett
set dst /l/backup/raktar/containers/jackett
set arch $dst"/jackett."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t jackett.bkp.fish "Source folder does not exist"
    echo "jackett.bkp.fish -- Source folder does not exist"
    exit
end

# if the destination folder does not exist, create it
if test ! -d $dst
    echo "jackett.bkp.fish -- Creating non-existent destination"
    mkdir -p $dst
end

echo "jackett.bkp.fish -- Creating archive"
tar -cvzf $arch -C $src/.. jackett
if test $status -eq 0
    logger -t jackett.rec.fish "The backup was successful"
    echo "jackett.rec.fish -- The backup was successful"

    set nb_backups (command ls -1trd $dst/jackett.*.tgz | wc -l)
    set nb_backups_todelete (math $nb_backups - $nb_max_backups)
    if test $nb_backups_todelete -gt 0
        echo "jackett.bkp.fish -- Removing older archives"
        command ls -1trd $dst/jackett.*.tgz \
            | head -n$nb_backups_todelete \
            | xargs rm -f
    end
else
    logger -t jackett.rec.fish "Backup unsuccessful"
    echo "jackett.rec.fish -- Backup unsuccessful"
end
