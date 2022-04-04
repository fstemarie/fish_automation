#! /usr/bin/fish

set dst /l/backup/raktar/development
set src /home/francois/development
set dir (dirname $src)
set base (basename $src)
set log /var/log/automation/development.log

set arch $dst"/development."(date +%s)".tgz"
if test ! -f $dst/development.full.tgz
    set arch $dst"/development.full.tgz"
end

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d $src
    logger -t development.bkp.fish "Source folder does not exist"
    echo "development.bkp.fish -- Source folder does not exist" >>$log
    exit
end

# if the destination folder does not exist, create it
if test ! -d $dst
    echo "development.bkp.fish -- Creating non-existent destination" >>$log
    mkdir -p $dst >>$log
end

echo "development.bkp.fish -- Creating archive" >>$log
tar --create --verbose --gzip --listed-incremental=$dst/development.snar \
    --exclude '.venv' \
    --exclude 'node_modules' \
    --directory=$dir \
    --file=$arch \
    $base >>$log
if test $status -ne 0
    logger -t development.bkp.fish "Backup unsuccessful"
    echo "development.bkp.fish -- Backup unsuccessful" >>$log
    exit
end
logger -t development.bkp.fish "The backup was successful"
echo "development.bkp.fish -- The backup was successful" >>$log

set nb_files (tar -tzf $arch | egrep -e '^.*[^/]$' | count)
if test $nb_files -eq 0
    echo "development.bkp.fish -- Empty archive. Deleting it..." >>$log
    rm $arch >>$log
end
