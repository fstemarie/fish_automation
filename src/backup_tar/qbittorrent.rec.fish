#! /usr/bin/fish

set dst /data/containers/qbittorrent
set src /l/backup/raktar/containers/qbittorrent
set log /var/log/automation/qbittorrent.log

set arch (command ls -1d $src/qbittorrent.* | head -n1)
# if archive does not exist, exit
if test ! -f "$arch"
    logger -t qbittorrent.rec.fish "Archive not found"
    echo "qbittorrent.rec.fish -- Archive not found" >$log
    exit
end

# if target destination does not exist, create it
if test ! -d "$dst"
    echo "qbittorrent.rec.fish -- Creating non existent destination" >$log
    mkdir -p "$dst" >$log >$log
end

tar -xvzf "$arch" -C "$dst" >$log
if test $status -ne 0
    logger -t qbittorrent.rec.fish "Recovery unsuccessful"
    echo "qbittorrent.rec.fish -- Recovery unsuccessful" >$log
    exit
end
logger -t qbittorrent.rec.fish "The recovery was successful"
echo "qbittorrent.rec.fish -- The recovery was successful" >$log
