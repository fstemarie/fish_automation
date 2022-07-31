#! /usr/bin/fish

set backup "/data/automation/backup/"
set scripts "$backup/tar/"{automation,config,jackett,qbittorrent}".bkp.fish"

for script in $scripts
    echo "Running: $script"
    script &
end
