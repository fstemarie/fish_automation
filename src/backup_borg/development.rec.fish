#! /usr/bin/fish

if test -z $BORG_REPO
    logger -t development.rec.fish "BORG_REPO empty. Cannot proceed"
    echo "development.rec.fish -- BORG_REPO empty. Cannot proceed"
    exit
end

set dst /home/francois/development
set arch (borg list --last 1 --prefix development. $BORG_REPO | cut -d' ' -f1)

if test ! -d $dst
    echo "development.rec.fish -- Creating non existent destination"
    mkdir -p $dst
end

pushd $dst
borg extract --list $BORG_REPO::$arch
set borg_result $status
popd

if test "$borg_result" -ne 0
    logger -t development.rec.fish "Could not recover borg backup"
    echo "development.rec.fish -- Could not recover borg backup"
    exit
end
logger -t development.rec.fish "Borg backup recovery successful"
echo "development.rec.fish -- Borg backup recovery successful"
