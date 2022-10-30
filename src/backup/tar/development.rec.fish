#! /usr/bin/fish

set src /l/backup/raktar/development
set dst /home/francois/development
set arch (command ls -1d $src/development.*.tgz | head -n1)

# if archive does not exist, exit
if test ! -f "$arch"
    logger -t development.rec.fish "Archive not found"
    echo "development.rec.fish -- Archive not found"
    exit
end

# if target destination does not exist, create it
if test ! -d "$dst"
    echo "development.rec.fish -- Creating non existent destination"
    mkdir -p "$dst"
    if test $status -ne 0
        logger -t development.rec.fish "Cannot create missing destination. Exiting..."
        echo "development.rec.fish -- Cannot create missing destination. Exiting..."
        exit
    end
end

tar --extract \
    --file="$arch" \
    --directory="$dst/.." \
    --verbose --gzip  
if test $status -ne 0
    logger -t development.rec.fish "Recovery unsuccessful"
    echo "development.rec.fish -- Recovery unsuccessful"
    exit
end
logger -t development.rec.fish "The recovery was successful"
echo "development.rec.fish -- The recovery was successful"
