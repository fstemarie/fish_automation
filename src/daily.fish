#! /usr/bin/fish

set backup /data/automation/backup
set scripts /data/automation/duckdns/duckdns.fish
set -a scripts $backup/{restic,tar}/{development,home}.bkp.fish

for script in $scripts
    echo "Running: $script"
    fish $script
end
