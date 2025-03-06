#! /usr/bin/fish

set src "/l/backup/raktar/ombi"
set dst "/data/containers/ombi"
set arch (command ls -1dr $src/ombi.*.tgz | head -n1)
set script (status basename)

# if archive does not exist, exit
if test ! -f "$arch"
    logger -t $script "Archive not found"
    echo "$script -- Archive not found"
    exit 1
end
echo "$script -- Using archive: $arch"

# Append date to name to avoid data loss
if test -d "$dst"
    logger -t $script "Destination already exists"
    echo "$script -- Destination already exists"

    set old "$dst"
    set dst "$old."(date +%s)
    while test -d "$dst"
        sleep 2
        set dst "$old."(date +%s)
    end
end

# Create non-existing destination
echo "$script -- Creating non existent destination"
mkdir -p "$dst"
if test $status -ne 0
    logger -t $script "Cannot create missing destination. Exiting..."
    echo "$script -- Cannot create missing destination. Exiting..."
    exit 1
end

# Recover data from archive
echo "$script -- Recovering..."
tar --extract --verbose --gzip \
    --file="$arch" \
    --directory="$dst" \
    --strip=1
if test $status -ne 0
    logger -t $script "Recovery unsuccessful"
    echo "$script -- Recovery unsuccessful"
    exit 1
end
logger -t $script "The recovery was successful"
echo "$script -- The recovery was successful"
