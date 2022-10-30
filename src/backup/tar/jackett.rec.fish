#! /usr/bin/fish

set dst /data/containers/jackett
set src /l/backup/raktar/containers/jackett
set arch (command ls -1d $src/jackett.*.tgz | head -n1)

# if archive does not exist, exit
if test ! -f "$arch"
    logger -t jackett.rec.fish "Archive not found"
    echo "jackett.rec.fish -- Archive not found"
    exit
end

# if target destination does not exist, create it
if test ! -d "$dst"
    echo "jackett.rec.fish -- Creating non existent destination"
    mkdir -p "$dst"
end

tar --extract \
    --file="$arch" \
    --directory="$dst/.." \
    --verbose --gzip
if test $status -ne 0
    logger -t jackett.rec.fish "Recovery unsuccessful"
    echo "jackett.rec.fish -- Recovery unsuccessful"
    exit
end
logger -t jackett.rec.fish "The recovery was successful"
echo "jackett.rec.fish -- The recovery was successful"
