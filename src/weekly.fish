#! /usr/bin/fish

set backup "/data/automation/backup"
set scripts "$backup/tar/"{automation,config,jackett,qbittorrent}".bkp.fish"

$backup/restic/automation.bkp.fish
$backup/restic/config.bkp.fish
$backup/restic/containers.bkp.fish
$backup/restic/jackett.bkp.fish
$backup/restic/qbittorrent.bkp.fish
restic prune

for script in $scripts
    echo "Running: $script"
    fish $script
end
