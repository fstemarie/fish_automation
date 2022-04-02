#! /usr/bin/fish

set src /home/francois/development
set dst /l/backup/raktar/development
set dir (dirname $src)
set base (basename $src)

set arch $dst"/development."(date +%s)".tgz"
if test ! -f $dst/development.full.tgz
    set arch $dst"/development.full.tgz"
end

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
tar --create --verbose --gzip --listed-incremental=$dst/development.snar \
    --exclude '.venv' \
    --exclude 'node_modules' \
    --directory=$dir \
    --file=$arch \
    $base
if test $status -ne 0
    logger -t development.bkp.fish "Backup unsuccessful"
    echo "development.bkp.fish -- Backup unsuccessful"
    exit
end
logger -t development.bkp.fish "The backup was successful"
echo "development.bkp.fish -- The backup was successful"

set nb_files (tar -tzf $arch | egrep -e '^.*[^/]$' | count)
if test $nb_files -eq 0
    echo "development.bkp.fish -- Empty archive. Deleting it..."
    rm $arch
end
