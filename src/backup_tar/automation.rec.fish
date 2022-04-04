#! /usr/bin/fish

set dst /data/automation
set src /l/backup/raktar/automation
set log /var/log/automation/automation.log

set arch (command ls -1d $src/automation.* | head -n1)
# if archive does not exist, exit
if test ! -f "$arch"
    logger -t automation.rec.fish "Archive not found"
    echo "automation.rec.fish -- Archive not found" >>$log
    exit
end

# if target destination does not exist, create it
if test ! -d "$dst"
    echo "automation.rec.fish -- Creating non existent destination" >>$log
    mkdir -p "$dst"
    if test $status -ne 0
        logger -t automation.rec.fish "Cannot create missing destination. Exiting..."
        echo "automation.rec.fish -- Cannot create missing destination. Exiting..." >>$log
        exit
    end
end

tar -xvzf "$arch" -C "$dst" >>$log
if test $status -ne 0
    logger -t automation.rec.fish "Recovery unsuccessful"
    echo "automation.rec.fish -- Recovery unsuccessful" >>$log
    exit
end
logger -t automation.rec.fish "The recovery was successful"
echo "automation.rec.fish -- The recovery was successful" >>$log
