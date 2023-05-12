#! /usr/bin/fish

set src "/l/backup/raktar/containers"
set dst "/data/containers"
set arch (command ls -1dr $src/containers.*.tgz | head -n1)

# if archive does not exist, exit
if test ! -f "$arch"
    logger -t containers.rec.fish "Archive not found"
    echo "containers.rec.fish -- Archive not found"
    exit 1
end
echo "containers.rec.fish -- Using archive: $arch"

# Append date to name to avoid data loss
if test -d "$dst"
    logger -t containers.rec.fish "Destination already exists"
    echo "containers.rec.fish -- Destination already exists"

    set old "$dst"
    set dst "$old."(date +%s)
    while test -d "$dst"
        sleep 2
        set dst "$old."(date +%s)
    end
end

# Create non-existing destination
echo "containers.rec.fish -- Creating non existent destination"
mkdir -p "$dst"
if test $status -ne 0
    logger -t containers.rec.fish "Cannot create missing destination. Exiting..."
    echo "containers.rec.fish -- Cannot create missing destination. Exiting..."
    exit 1
end

# Recover data from archive
echo "containers.rec.fish -- Recovering..."
tar --extract --verbose --gzip \
    --file="$arch" \
    --directory="$dst" \
    --strip=1
if test $status -ne 0
    logger -t containers.rec.fish "Recovery unsuccessful"
    echo "containers.rec.fish -- Recovery unsuccessful"
    exit 1
end
logger -t containers.rec.fish "The recovery was successful"
echo "containers.rec.fish -- The recovery was successful"
