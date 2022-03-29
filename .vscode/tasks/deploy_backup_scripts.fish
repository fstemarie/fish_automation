#! /usr/bin/fish
# This script will deploy the backup scripts.

set dst /data/automation/backup
set s (basename (status current-filename))

if test ! -d "$dst"
    echo "$s -- Creating non existing destination"
    mkdir -p $dst
    if test $status -ne 0
        echo "$s -- Error while creating destination. Unable to proceed..."
        exit
    end
end

echo "$s -- Copying backup scripts to destination"
cp --remove-destination "./src/backup/*.fish" "$dst"
if test $status -ne 0
    echo "$s -- Error whlie copying backup scripts"
    exit
end
echo "$s -- Scripts copied successfully"
