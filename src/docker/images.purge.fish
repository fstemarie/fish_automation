#! /usr/bin/env fish

source (status dirname)/../log.fish

echo "

-------------------------------------
[[ Running images.purge.fish ]]
 "(date -Iseconds)"
-------------------------------------
" | tee -a $log

docker image prune -a -f 2>&1 | tee -a $log