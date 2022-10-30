#! /usr/bin/fish

if test -z $RESTIC_REPOSITORY
    logger -t automation.rec.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "automation.rec.fish -- RESTIC_REPOSITORY empty. Cannot proceed"
    exit
end

if test -z $RESTIC_PASSWORD
    logger -t automation.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "automation.rec.fish -- RESTIC_PASSWORD empty. Cannot proceed"
    exit
end

set dst /data/automation
if test -d $dst
    logger -t automation.bkp.fish "Moving existing destination"
    echo "automation.rec.fish -- Moving existing destination"
    mv $dst $dst.(date +%s)
end
mkdir -p $dst

restic restore \
    --host=raktar \
    --tag=automation \
    --latest \
    --target /
if test $status -ne 0
    logger -t automation.rec.fish "Could not restore snapshot"
    echo "automation.rec.fish -- Could not restore snapshot"
    exit
end
logger -t automation.rec.fish "Snapshot restoration successful"
echo "automation.rec.fish -- Snapshot restoration successful"
