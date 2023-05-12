#! /usr/bin/fish

set dst "/data/config"
set src "/l/backup/raktar/config"
set arch (command ls -1dr $src/config.*.tgz | head -n1)

# if archive does not exist, exit
if test ! -f "$arch"
    logger -t config.rec.fish "Archive not found"
    echo "config.rec.fish -- Archive not found"
    exit 1
end
echo "config.rec.fish -- Using archive: $arch"

# Append date to name to avoid data loss
if test -d "$dst"
    logger -t config.rec.fish "Destination already exists"
    echo "config.rec.fish -- Destination already exists"

    set old "$dst"
    set dst "$old."(date +%s)
    while test -d "$dst"
        sleep 2
        set dst "$old."(date +%s)
    end
end

# Create non-existing destination
echo "config.rec.fish -- Creating non existent destination"
mkdir -p "$dst"
if test $status -ne 0
    logger -t config.rec.fish "Cannot create missing destination. Exiting..."
    echo "config.rec.fish -- Cannot create missing destination. Exiting..."
    exit 1
end

# Recover data from archive
echo "config.rec.fish -- Recovering..."
tar --extract --verbose --gzip \
    --file="$arch" \
    --directory="$dst" \
    --strip=1
if test $status -ne 0
    logger -t config.rec.fish "Recovery unsuccessful"
    echo "config.rec.fish -- Recovery unsuccessful"
    exit 1
end
logger -t config.rec.fish "The recovery was successful"
echo "config.rec.fish -- The recovery was successful"
