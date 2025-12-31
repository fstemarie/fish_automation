#! /usr/bin/fish

set src "/l/backup/sklad/jellyfin"
set dst "/data/containers/jellyfin"
set arch (command ls -1dr $src/jellyfin.*.tgz | head -n1)
set script (status basename)

# if archive does not exist, exit
if test ! -f "$arch"
    echo (set_color brred)"[ERROR] Archive not found" >&2
    exit 1
end

# Append date to name to avoid data loss
if test -d "$dst"
    echo "Destination already exists"

    set old "$dst"
    set dst "$old."(date +%s)
    while test -d "$dst"
        sleep 2
        set dst "$old."(date +%s)
    end
end

# Create non-existing destination
echo "Creating non-existing destination"
mkdir -p "$dst"
if test $status -ne 0
    echo (set_color brred)"[ERROR] Cannot create missing destination. Exiting..." >&2
    exit 1
end

# Recover data from archive
echo "Recovering..."
tar --extract --verbose --gzip \
    --same-owner \
    --same-permissions \
    --file="$arch" \
    --directory="$dst" \
    --strip=1 
if test $status -ne 0
    echo (set_color brred)"[ERROR] Recovery unsuccessful" >&2
    exit 1
end
echo "The recovery was successful"
