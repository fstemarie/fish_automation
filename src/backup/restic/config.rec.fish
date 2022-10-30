#! /usr/bin/fish

if test -z $RESTIC_REPOSITORY
    logger -t config.rec.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "config.rec.fish -- RESTIC_REPOSITORY empty. Cannot proceed"
    exit
end

if test -z $RESTIC_PASSWORD
    logger -t config.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "config.rec.fish -- RESTIC_PASSWORD empty. Cannot proceed"
    exit
end

set dst /data/config
if test -d $dst
    logger -t config.bkp.fish "Moving existing destination"
    echo "config.rec.fish -- Moving existing destination"
    mv $dst $dst.(date +%s)
end
mkdir -p $dst

restic restore \
    --host=raktar \
    --tag=config \
    --latest \
    --target /
if test $status -ne 0
    logger -t config.rec.fish "Could not restore snapshot"
    echo "config.rec.fish -- Could not restore snapshot"
    exit
end
logger -t config.rec.fish "Snapshot restoration successful"
echo "config.rec.fish -- Snapshot restoration successful"
