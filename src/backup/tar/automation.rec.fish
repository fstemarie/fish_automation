#! /usr/bin/fish

set src "/l/backup/raktar/automation"
set dst "/data/automation"
set arch (command ls -1dr $src/automation.*.tgz | head -n1)

# if archive does not exist, exit
if test ! -f "$arch"
    logger -t automation.rec.fish "Archive not found"
    echo "automation.rec.fish -- Archive not found"
    exit 1
end
echo "automation.rec.fish -- Using archive: $arch"

# Append date to name to avoid data loss
if test -d "$dst"
    logger -t automation.rec.fish "Destination already exists"
    echo "automation.rec.fish -- Destination already exists"

    set old "$dst"
    set dst "$old."(date +%s)
    while test -d "$dst"
        sleep 2
        set dst "$old."(date +%s)
    end
end

# Create non-existing destination
echo "automation.rec.fish -- Creating non existent destination"
mkdir -p "$dst"
if test $status -ne 0
    logger -t automation.rec.fish "Cannot create missing destination. Exiting..."
    echo "automation.rec.fish -- Cannot create missing destination. Exiting..."
    exit 1
end

# Recover data from archive
echo "automation.rec.fish -- Recovering..."
tar --extract --verbose --gzip \
    --file="$arch" \
    --directory="$dst" \
    --strip=1
if test $status -ne 0
    logger -t automation.rec.fish "Recovery unsuccessful"
    echo "automation.rec.fish -- Recovery unsuccessful"
    exit 1
end
logger -t automation.rec.fish "The recovery was successful"
echo "automation.rec.fish -- The recovery was successful"
