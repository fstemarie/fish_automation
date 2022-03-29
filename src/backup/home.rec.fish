#! /usr/bin/fish

if test -z $BORG_REPO
    logger -t home.rec.fish "BORG_REPO empty. Cannot proceed"
    echo "home.rec.fish -- BORG_REPO empty. Cannot proceed"
    exit
end

set dst /home/francois
set arch (borg list --last 1 --prefix home. $BORG_REPO | cut -d' ' -f1)

if test ! -d $dst
    echo "home.rec.fish -- Creating non existent destination"
    mkdir -p $dst
end

pushd $dst
borg extract --list $BORG_REPO::$arch
set borg_result $status
popd

if test "$borg_result" -ne 0
    logger -t home.rec.fish "Could not recover borg backup"
    echo "home.rec.fish -- Could not recover borg backup"
    exit
end
logger -t home.rec.fish "Borg backup recovery successful"
echo "home.rec.fish -- Borg backup recovery successful"
