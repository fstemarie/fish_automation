#! /usr/bin/fish

set backup "/data/automation/backup"

restic unlock
$backup/restic/automation.bkp.fish
$backup/restic/config.bkp.fish
$backup/restic/containers.bkp.fish
restic prune

$backup/tar/automation.bkp.fish
$backup/tar/config.bkp.fish
$backup/tar/jackett.bkp.fish
$backup/tar/qbittorrent.bkp.fish