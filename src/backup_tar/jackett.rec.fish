#! /usr/bin/fish

set dst /data/containers/jackett
set src /l/backup/raktar/containers/jackett
set log /var/log/automation/jackett.log

set arch (command ls -1d $src/jackett.* | head -n1)
# if archive does not exist, exit
if test ! -f "$arch"
    logger -t jackett.rec.fish "Archive not found"
    echo "jackett.rec.fish -- Archive not found" >>$log
    exit
end

# if target destination does not exist, create it
if test ! -d "$dst"
    echo "jackett.rec.fish -- Creating non existent destination" >>$log
    mkdir -p "$dst" >>$log
end

tar -xvzf "$arch" -C "$dst" >>$log
if test $status -ne 0
    logger -t jackett.rec.fish "Recovery unsuccessful"
    echo "jackett.rec.fish -- Recovery unsuccessful" >>$log
    exit
end
logger -t jackett.rec.fish "The recovery was successful"
echo "jackett.rec.fish -- The recovery was successful" >>$log
