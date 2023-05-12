#! /usr/bin/fish

set src "/l/backup/raktar/home"
# Append date to destination name to avoid data loss
set dst "$HOME/home."(date +%s)
set arch (command ls -1dr $src/home.*.tgz | head -n1)

# if archive does not exist, exit
if test ! -f "$arch"
    logger -t home.rec.fish "Archive not found"
    echo "home.rec.fish -- Archive not found"
    exit 1
end
echo "home.rec.fish -- Using archive: $arch"

# if target destination does not exist, create it
if test ! -d "$dst"
    echo "home.rec.fish -- Creating non existent destination"
    mkdir -p "$dst"
    if test $status -ne 0
        logger -t home.rec.fish "Cannot create missing destination. Exiting..."
        echo "home.rec.fish -- Cannot create missing destination. Exiting..."
        exit 1
    end
end

# Recover data from archive
echo "home.rec.fish -- Recovering..."
tar --extract --verbose --gzip \
    --file="$arch" \
    --directory="$dst" \
    --strip=1
if test $status -ne 0
    logger -t home.rec.fish "Recovery unsuccessful"
    echo "home.rec.fish -- Recovery unsuccessful"
    exit 1
end
logger -t home.rec.fish "The recovery was successful"
echo "home.rec.fish -- The recovery was successful"
