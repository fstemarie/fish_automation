#! /usr/bin/fish

set dst /data/containers
set src /l/backup/raktar/containers
set arch (command ls -1d $src/containers.*.tgz | head -n1)

# if archive does not exist, exit
if test ! -f "$arch"
    logger -t containers.rec.fish "Archive not found"
    echo "containers.rec.fish -- Archive not found"
    exit
end

# if target destination does not exist, create it
if test ! -d "$dst"
    echo "containers.rec.fish -- Creating non existent destination"
    mkdir -p "$dst"
    if test $status -ne 0
        logger -t containers.rec.fish "Cannot create missing destination. Exiting..."
        echo "containers.rec.fish -- Cannot create missing destination. Exiting..."
        exit
    end
end

tar --extract \
    --file="$arch" \
    --directory="$dst/.." \
    --verbose --gzip
if test $status -ne 0
    logger -t containers.rec.fish "Recovery unsuccessful"
    echo "containers.rec.fish -- Recovery unsuccessful"
    exit
end
logger -t containers.rec.fish "The recovery was successful"
echo "containers.rec.fish -- The recovery was successful"
