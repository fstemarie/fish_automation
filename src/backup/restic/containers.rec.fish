#! /usr/bin/fish

if test -z $RESTIC_REPOSITORY
    logger -t containers.rec.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "containers.rec.fish -- RESTIC_REPOSITORY empty. Cannot proceed"
    exit
end

if test -z $RESTIC_PASSWORD
    logger -t containers.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "containers.rec.fish -- RESTIC_PASSWORD empty. Cannot proceed"
    exit
end

set dst /data/containers
if test -d $dst
    logger -t containers.bkp.fish "Moving existing destination"
    echo "containers.rec.fish -- Moving existing destination"
    mv $dst $dst.(date +%s)
end
mkdir -p $dst

restic restore \
    --host=raktar \
    --tag=containers \
    --latest \
    --target /
if test $status -ne 0
    logger -t containers.rec.fish "Could not restore snapshot"
    echo "containers.rec.fish -- Could not restore snapshot"
    exit
end
logger -t containers.rec.fish "Snapshot restoration successful"
echo "containers.rec.fish -- Snapshot restoration successful"
