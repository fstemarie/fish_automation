#! /usr/bin/fish

set dst /data/containers/qbittorrent
set src /l/backup/raktar/containers/qbittorrent

set arch (command ls -1d $src/qbittorrent.* | head -n1)
# if archive does not exist, exit
if test ! -f "$arch"
    logger -t qbittorrent.rec.fish "Archive not found"
    echo "qbittorrent.rec.fish -- Archive not found"
    exit
end

# if target destination does not exist, create it
if test ! -d "$dst"
    echo "qbittorrent.rec.fish -- Creating non existent destination"
    mkdir -p "$dst"
    if test $status -ne 0
        logger -t qbittorrent.rec.fish "Cannot create missing destination. Exiting..."
        echo "qbittorrent.rec.fish -- Cannot create missing destination. Exiting..."
        exit
    end
end

tar -xvzf "$arch" -C "$dst"
if test $status -ne 0
    logger -t qbittorrent.rec.fish "Recovery unsuccessful"
    echo "qbittorrent.rec.fish -- Recovery unsuccessful"
    exit
end
logger -t qbittorrent.rec.fish "The recovery was successful"
echo "qbittorrent.rec.fish -- The recovery was successful"
