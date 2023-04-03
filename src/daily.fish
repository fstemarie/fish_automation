#! /usr/bin/fish

set backup /data/automation/backup

restic unlock
$backup/restic/development.bkp.fish
$backup/restic/home.bkp.fish
restic prune

$backup/tar/development.bkp.fish
$backup/tar/home.bkp.fish
