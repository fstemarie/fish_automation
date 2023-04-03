#! /usr/bin/fish
# This script will deploy the backup scripts.

#--------------------------------- restic ---------------------------------------
set dst /data/automation/backup/restic

if test ! -d "$dst"
    echo "-- Creating non existing destination $dst"
    mkdir -p $dst
    if test $status -ne 0
        echo "-- Error while creating destination. Unable to proceed..."
        exit
    end
end

echo "-- Copying backup scripts to destination"
cp --remove-destination ./src/backup/restic/* $dst
if test $status -ne 0
    echo "-- Error while copying backup scripts"
    exit
end

echo "-- Restic Scripts copied successfully"

#--------------------------------- tar ------------------------------------------

set dst /data/automation/backup/tar

if test ! -d "$dst"
    echo "-- Creating non existing destination"
    mkdir -p $dst
    if test $status -ne 0
        echo "-- Error while creating destination. Unable to proceed..."
        exit
    end
end

echo "-- Copying backup scripts to destination"
cp --remove-destination ./src/backup/tar/* $dst
if test $status -ne 0
    echo "-- Error while copying backup scripts"
    exit
end

echo "-- Tar Scripts copied successfully"

set dst /data/automation/
echo "-- Copying scheduled scripts to destination"
cp --remove-destination ./src/*.fish $dst
if test $status -ne 0
    echo "-- Error while copying scheduled scripts"
    exit
end

echo "-- Schedule Scripts copied successfully"
