#! /usr/bin/fish

set src "/l/audio/podcasts/"
# add bedroom to ~/.ssh/config
set dst "bedroom:/media/256gb/podcasts/"
set log "/var/log/automation/hdtgm-tx.rsync.log"

umask 0122
echo "


-------------------------------------
 "(date -Iseconds)"
-------------------------------------
" | tee -a $log

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d "$src"
    logger -t hdtgm-tx.bkp.fish "Source folder does not exist"
    echo "hdtgm-tx.bkp.fish -- Source folder does not exist" | tee -a $log
    exit 1
end
echo "hdtgm-tx.bkp.fish -- Source folder: $src" | tee -a $log

echo "hdtgm-tx.bkp.fish -- Gathering remote file list" | tee -a $log
set lsremote (ssh -o ConnectTimeout=5 bedroom find \"/media/256gb/podcasts/How Did This Get Made_\" -type f -printf \"%f\n\")
echo "hdtgm-tx.bkp.fish -- Gathering local file list" | tee -a $log
set lslocal (find "/l/audio/podcasts/How Did This Get Made_/" -type f -printf "%f\n")
echo "hdtgm-tx.bkp.fish -- Comparing lists" | tee -a $log
printf "%s\n" $lsremote $lslocal | sort | uniq -u
set diff (printf "%s\n" $lsremote $lslocal | sort | uniq -u | wc -l)
if test $diff -eq 0
    echo "hdtgm-tx.bkp.fish -- No files to transfer. Exiting early" | tee -a $log
    if set -q podcasts_comm
        set podcasts_comm "NODIFFS"
    end
    exit 0
end

echo "hdtgm-tx.bkp.fish -- Transfering files" | tee -a $log
begin
    rsync \
        --verbose \
        --contimeout=5 \
        --recursive \
        --size-only \
        --chmod 644 \
        --mkpath \
        --exclude='How Did This Get Made - Matinee Monday' \
        "$src" "$dst"
    set -g ret $status
end 2>&1 | tee -a $log
if test $ret -ne 0
    logger -t hdtgm-tx.bkp.fish "There was an error during the transfer"
    echo "hdtgm-tx.bkp.fish -- There was an error during the transfer" | tee -a $log
    exit 1
end
logger -t hdtgm-tx.bkp.fish "Transfer was successfull"
echo "hdtgm-tx.bkp.fish -- Transfer was successfull" | tee -a $log

if set -q podcasts_comm
    set podcasts_comm "DIFFS"
end