#! /usr/bin/fish

set src /home/francois
set dir (dirname $src)
set base (basename $src)
set dst /l/backup/raktar/home
set log /var/log/automation/home.log

set arch $dst"/home."(date +%s)".tgz"
if test ! -f $dst/home.full.tgz
    set arch $dst"/home.full.tgz"
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t home.bkp.fish "Source folder does not exist"
    echo "home.bkp.fish -- Source folder does not exist" >>$log
    exit
end

# if the destination folder does not exist, create it
if test ! -d $dst
    echo "home.bkp.fish -- Creating non-existent destination" >>$log
    mkdir -p $dst >>$log
end

echo "home.bkp.fish -- Creating archive" >>$log
tar --create --verbose --gzip --listed-incremental=$dst/home.snar \
    --exclude 'development' \
    --exclude '.cache' \
    --exclude '.vscode*' \
    --exclude 'fish_history' \
    --directory=$dir \
    --file=$arch \
    $base >>$log
if test $status -ne 0
    logger -t home.bkp.fish "Backup unsuccessful"
    echo "home.bkp.fish -- Backup unsuccessful" >>$log
    exit
end
logger -t home.bkp.fish "The backup was successful"
echo "home.bkp.fish -- The backup was successful" >>$log

set nb_files (tar -tzf $arch | egrep -e '^.*[^/]$' | count)
if test $nb_files -eq 0
    echo "home.bkp.fish -- Empty archive. Deleting it..." >>$log
    rm $arch >>$log
end
