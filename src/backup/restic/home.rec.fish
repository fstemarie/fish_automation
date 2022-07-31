#! /usr/bin/fish

if test -z $RESTIC_REPOSITORY
    logger -t home.rec.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "dhomevelopment.rec.fish -- RESTIC_REPOSITORY empty. Cannot proceed"
    exit
end

if test -z $RESTIC_PASSWORD
    logger -t home.rec.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "home.rec.fish -- RESTIC_PASSWORD empty. Cannot proceed"
    exit
end

set dst /home/francois/test
if test -d $dst
    logger -t development.bkp.fish "Moving existing destination"
    echo "home.rec.fish -- Moving existing destination"
    mv $dst $dst.(date +%s)
end
mkdir -p $dst

restic restore latest --tag home --target /
if test $status -ne 0
    logger -t home.rec.fish "Could not restore snapshot"
    echo "home.rec.fish -- Could not restore snapshot"
    exit
end
logger -t home.rec.fish "Snapshot restoration successful"
echo "home.rec.fish -- Snapshot restoration successful"
