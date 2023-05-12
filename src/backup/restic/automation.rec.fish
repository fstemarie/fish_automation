#! /usr/bin/fish

set dst "/data/automation"

if test -z $RESTIC_REPOSITORY
    logger -t automation.rec.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "automation.rec.fish -- RESTIC_REPOSITORY empty. Cannot proceed"
    exit 1
end

if test -z $RESTIC_PASSWORD
    logger -t automation.rec.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "automation.rec.fish -- RESTIC_PASSWORD empty. Cannot proceed"
    exit 1
end

# Append date to name to avoid data loss
if test -d "$dst"
    logger -t automation.rec.fish "Destination already exists"
    echo "automation.rec.fish -- Destination already exists"

    set old "$dst"
    set dst "$old."(date +%s)
    while test -d "$dst"
        sleep 2
        set dst "$old."(date +%s)
    end
end

# Create non-existing destination
echo "automation.rec.fish -- Creating non existent destination"
mkdir -p "$dst"
if test $status -ne 0
    logger -t automation.rec.fish "Cannot create missing destination. Exiting..."
    echo "automation.rec.fish -- Cannot create missing destination. Exiting..."
    exit 1
end

# Recover data from archive
restic restore latest \
    --host=raktar \
    --tag=automation \
    --target "$dst"
if test $status -ne 0
    logger -t automation.rec.fish "Could not restore snapshot"
    echo "automation.rec.fish -- Could not restore snapshot"
    exit 1
end
logger -t automation.rec.fish "Snapshot restoration successful"
echo "automation.rec.fish -- Snapshot restoration successful"
