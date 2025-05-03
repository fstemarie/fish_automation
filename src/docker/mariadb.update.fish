#! /usr/bin/fish

set pjdir "/home/francois/development/containers/mariadb"
set log "/var/log/automation/mariadb.update.log"
set script (status basename)

source (status dirname)/../log.fish

echo "

-------------------------------------
[[ Running mariadb.update.fish ]]
 "(date -Iseconds)"
-------------------------------------
" | tee -a $log

if test ! -d "$pjdir"
    error "non-existing project directory. Cannot proceed"
    exit 1
end

info "Updating containers"
pushd "$pjdir"
docker compose pull
if test $status -ne 0
    error "There was an error during the update"
    exit 1
end

info "Restarting containers"
docker compose up -d
if test $status -ne 0
    error "There was an error while restarting containers"
    exit 1
end
popd
