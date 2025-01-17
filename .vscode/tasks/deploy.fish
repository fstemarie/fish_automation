#! /usr/bin/fish
# This script will deploy the backup scripts.

set dst "/data/automation"
set s (basename (status current-filename))

if test -d "$dst"
    rm -fr "$dst"
    if test $status -ne 0
        echo "$s -- Error while deleting destination. Unable to proceed..."
        exit 1
    end
end

echo "$s -- Creating non existing destination $dst"
mkdir -p "$dst"
if test $status -ne 0
    echo "$s -- Error while creating destination. Unable to proceed..."
    exit 1
end

echo "$s -- Copying backup scripts to destination"
cp -R ./src/* "$dst"
if test $status -ne 0
    echo "$s -- Error while copying backup scripts"
    exit 1
end

echo "$s -- Scripts copied successfully"
