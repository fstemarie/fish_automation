#! /usr/bin/fish

set dst /data/containers/jackett
set src /l/backup/raktar/containers/jackett

set arch (command ls -1d $src/jackett.* | head -n1)
# if archive does not exist, exit
if test ! -f "$arch"
    logger -t jackett.rec.fish "Archive not found"
    echo "jackett.rec.fish -- Archive not found"
    exit
end

# if target destination does not exist, create it
if test ! -d "$dst"
    logger -t jackett.rec.fish "Creating non existent destination"
    echo "jackett.rec.fish -- Creating non existent destination"
    mkdir -p "$dst"
    if test $status -ne 0
        logger -t jackett.rec.fish "Cannot create missing destination. Exiting..."
        echo "jackett.rec.fish -- Cannot create missing destination. Exiting..."
        exit
    end
end

tar -xvzf "$arch" -C "$dst"
if test $status -eq 0
    logger -t jackett.rec.fish "The recovery was successful"
    echo "jackett.rec.fish -- The recovery was successful"
else
    logger -t jackett.rec.fish "Recovery unsuccessful"
    echo "jackett.rec.fish -- Recovery unsuccessful"
end
