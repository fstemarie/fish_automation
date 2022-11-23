#! /usr/bin/fish

set backup /data/automation/backup
set scripts /data/automation/duckdns/duckdns.fish
set -a scripts $backup/tar/{development,home}.bkp.fish

$backup/restic/development.bkp.fish
$backup/restic/home.bkp.fish
restic prune

for script in $scripts
    echo "Running: $script"
    fish $script
end
