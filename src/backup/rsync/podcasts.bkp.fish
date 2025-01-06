#! /usr/bin/fish

set src "/l/audio/podcasts/"
# add bedroom to ~/.ssh/config
set dst "bedroom:/media/256gb/podcasts/"
set log "/var/log/automation/podcasts.rsync.log"

umask 0122
echo "


-------------------------------------
[[ Running podcasts.bkp.log ]]
"(date -Iseconds)"
-------------------------------------
" | tee -a $log

# if the source folder doesn't exist, then there is nothing to backup
if test ! -d "$src"
    logger -t podcasts.bkp.fish "Source folder does not exist"
    echo "podcasts.bkp.fish -- Source folder does not exist" | tee -a $log
    exit 1
end
echo "podcasts.bkp.fish -- Source folder: $src" | tee -a $log

echo "podcasts.bkp.fish -- Gathering remote file list" | tee -a $log
set lsremote (ssh -o ConnectTimeout=5 bedroom find \"/media/256gb/podcasts/How Did This Get Made_\" -type f -printf \"%f\n\")
echo "podcasts.bkp.fish -- Gathering local file list" | tee -a $log
set lslocal (find "/l/audio/podcasts/How Did This Get Made_/" -type f -printf "%f\n")
echo "podcasts.bkp.fish -- Comparing lists" | tee -a $log
printf "%s\n" $lsremote $lslocal | sort | uniq -u
set diff (printf "%s\n" $lsremote $lslocal | sort | uniq -u | wc -l)
if test $diff -eq 0
    echo "podcasts.bkp.fish -- No files to transfer. Exiting early" | tee -a $log
    if set -q podcasts_comm
        set podcasts_comm "NODIFFS"
    end
    exit 0
end

echo "podcasts.bkp.fish -- Transfering files" | tee -a $log
begin
    rsync \
        --verbose \
        --ignore-existing \
        --size-only \
        --recursive \
        --chmod u=rwX,go=rX \
        --mkpath \
        --exclude='How Did This Get Made - Matinee Monday' \
        "$src" "$dst"
    set -g ret $status
end 2>&1 | tee -a $log
if test $ret -ne 0
    logger -t podcasts.bkp.fish "There was an error during the transfer"
    echo "podcasts.bkp.fish -- There was an error during the transfer" | tee -a $log
    exit 1
end
logger -t podcasts.bkp.fish "Transfer was successfull"
echo "podcasts.bkp.fish -- Transfer was successfull" | tee -a $log

if set -q podcasts_comm
    set podcasts_comm "DIFFS"
end