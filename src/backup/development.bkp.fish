#! /usr/bin/fish

set nb_max_backups 5
set src /home/francois/development
set dst /l/backup/raktar/development
set arch $dst"/development."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t development.bkp.fish "Source folder does not exist"
    echo "development.bkp.fish -- Source folder does not exist"
    exit
end

# if the destination folder does not exist, create it
if test ! -d $dst
    echo "development.bkp.fish -- Creating non-existent destination"
    mkdir -p $dst
end

echo "development.bkp.fish -- Creating archive"
tar -cvzf $arch -C $src/.. development
if test $status -eq 0
    logger -t development.rec.fish "The backup was successful"
    echo "development.rec.fish -- The backup was successful"

    set nb_backups (command ls -1trd $dst/development.*.tgz | wc -l)
    set nb_backups_todelete (math $nb_backups - $nb_max_backups)
    if test $nb_backups_todelete -gt 0
        echo "development.bkp.fish -- Removing older archives"
        command ls -1trd $dst/development.*.tgz \
            | head -n$nb_backups_todelete \
            | xargs rm -f
    end
else
    logger -t development.rec.fish "Backup unsuccessful"
    echo "development.rec.fish -- Backup unsuccessful"
end
