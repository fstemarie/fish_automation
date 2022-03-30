#! /usr/bin/fish
# This script will deploy the backup scripts.

set dst /data/automation/duckdns
set s (basename (status current-filename))

if test ! -d "$dst"
    echo "$s -- Creating non existing destination"
    mkdir -p $dst
    if test $status -ne 0
        echo "$s -- Error while creating destination. Unable to proceed..."
        exit
    end
end

echo "$s -- Copying duckdns script to destination"
cp --remove-destination ./src/duckdns/duckdns.fish $dst
if test $status -ne 0
    echo "$s -- Error whlie copying script"
    exit
end
echo "$s -- Script copied successfully"
