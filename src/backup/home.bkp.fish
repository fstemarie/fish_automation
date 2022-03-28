#! /usr/bin/fish

set nb_max_backups 5
set src /home/francois
set dst /l/backup/raktar/home
set arch $dst"/home."(date +%Y%m%dT%H%M%S | tr -d :-)".tgz"

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t home.bkp.fish "Source folder does not exist"
    echo "home.bkp.fish -- Source folder does not exist"
    exit
end

# if the destination folder does not exist, create it
if test ! -d $dst
    echo "home.bkp.fish -- Creating non-existent destination"
    mkdir -p $dst
end

echo "home.bkp.fish -- Creating archive"
cd $src/..
tar \
    --exclude "francois/.cache" \
    --exclude "francois/development" \
    --exclude "francois/.vscode-*" \
    -cvzf $arch francois

set nb_backups (command ls -1trd $dst/home.*.tgz | wc -l)
set nb_backups_todelete (math $nb_backups - $nb_max_backups)
if test $nb_backups_todelete -gt 0
    echo "home.bkp.fish -- Removing older archives"
    command ls -1trd $dst/home.*.tgz \
        | head -n$nb_backups_todelete \
        | xargs rm -f
end
