#! /usr/bin/fish

set backup "/data/automation/backup"
set scripts "$backup/tar/"{automation,config,jackett,qbittorrent}".bkp.fish"
set -a scripts "$backup/restic/"{automation,config,containers,jackett,qbittorrent}".bkp.fish"

for script in $scripts
    echo "Running: $script"
    fish $script
end
