#! /usr/bin/fish

set nb_max_backups 5
set src /data/automation
set dst /l/backup/raktar/automation
set arch $dst"/automation."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t automation.bkp.fish "Source folder does not exist"
    echo "automation.bkp.fish -- Source folder does not exist"
    exit
end

# if the destination folder does not exist, create it
if test ! -d $dst
    echo "automation.bkp.fish -- Creating non-existent destination"
    mkdir -p $dst
end

echo "automation.bkp.fish -- Creating archive"
tar -cvzf $arch -C $src/.. automation
if test $status -eq 0
    logger -t automation.rec.fish "The backup was successful"
    echo "automation.rec.fish -- The backup was successful"

    set nb_backups (command ls -1trd $dst/automation.*.tgz | wc -l)
    set nb_backups_todelete (math $nb_backups - $nb_max_backups)
    if test $nb_backups_todelete -gt 0
        echo "automation.bkp.fish -- Removing older archives"
        command ls -1trd $dst/automation.*.tgz \
            | head -n$nb_backups_todelete \
            | xargs rm -f
    end
else
    logger -t automation.rec.fish "Backup unsuccessful"
    echo "automation.rec.fish -- Backup unsuccessful"
end
