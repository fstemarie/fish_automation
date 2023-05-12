#! /usr/bin/fish

set src "/l/backup/raktar/jackett"
set dst "/data/containers/jackett"
set arch (command ls -1dr $src/jackett.*.tgz | head -n1)

# if archive does not exist, exit
if test ! -f "$arch"
    logger -t jackett.rec.fish "Archive not found"
    echo "jackett.rec.fish -- Archive not found"
    exit 1
end
echo "jackett.rec.fish -- Using archive: $arch"

# Append date to name to avoid data loss
if test -d "$dst"
    logger -t jackett.rec.fish "Destination already exists"
    echo "jackett.rec.fish -- Destination already exists"

    set old "$dst"
    set dst "$old."(date +%s)
    while test -d "$dst"
        sleep 2
        set dst "$old."(date +%s)
    end
end

# Create non-existing destination
echo "jackett.rec.fish -- Creating non existent destination"
mkdir -p "$dst"
if test $status -ne 0
    logger -t jackett.rec.fish "Cannot create missing destination. Exiting..."
    echo "jackett.rec.fish -- Cannot create missing destination. Exiting..."
    exit 1
end

# Recover data from archive
echo "jackett.rec.fish -- Recovering..."
tar --extract --verbose --gzip \
    --file="$arch" \
    --directory="$dst" \
    --strip=1    
if test $status -ne 0
    logger -t jackett.rec.fish "Recovery unsuccessful"
    echo "jackett.rec.fish -- Recovery unsuccessful"
    exit 1
end
logger -t jackett.rec.fish "The recovery was successful"
echo "jackett.rec.fish -- The recovery was successful"
