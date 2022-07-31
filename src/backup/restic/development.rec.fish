#! /usr/bin/fish

if test -z $RESTIC_REPOSITORY
    logger -t development.rec.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "development.rec.fish -- RESTIC_REPOSITORY empty. Cannot proceed"
    exit
end

if test -z $RESTIC_PASSWORD
    logger -t development.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "development.rec.fish -- RESTIC_PASSWORD empty. Cannot proceed"
    exit
end

set dst /home/francois/development
if test -d $dst
    logger -t development.bkp.fish "Moving existing destination"
    echo "development.rec.fish -- Moving existing destination"
    mv $dst $dst.(date +%s)
end
mkdir -p $dst

restic restore --latest --tag development --target /
if test $status -ne 0
    logger -t development.rec.fish "Could not restore snapshot"
    echo "development.rec.fish -- Could not restore snapshot"
    exit
end
logger -t development.rec.fish "Snapshot restoration successful"
echo "development.rec.fish -- Snapshot restoration successful"
