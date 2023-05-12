#! /usr/bin/fish

set dst "/data/config"

if test -z $RESTIC_REPOSITORY
    logger -t config.rec.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "config.rec.fish -- RESTIC_REPOSITORY empty. Cannot proceed"
    exit 1
end

if test -z $RESTIC_PASSWORD
    logger -t config.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "config.rec.fish -- RESTIC_PASSWORD empty. Cannot proceed"
    exit 1
end

# Append date to name to avoid data loss
if test -d "$dst"
    logger -t config.rec.fish "Destination already exists"
    echo "config.rec.fish -- Destination already exists"

    set old "$dst"
    set dst "$old."(date +%s)
    while test -d "$dst"
        sleep 2
        set dst "$old."(date +%s)
    end
end

# Create non-existing destination
echo "config.rec.fish -- Creating non existent destination"
mkdir -p "$dst"
if test $status -ne 0
    logger -t config.rec.fish "Cannot create missing destination. Exiting..."
    echo "config.rec.fish -- Cannot create missing destination. Exiting..."
    exit 1
end

# Recover data from archive
echo "automation.rec.fish -- Recovering..."
restic restore latest \
    --host=raktar \
    --tag=config \
    --target "$dst"
if test $status -ne 0
    logger -t config.rec.fish "Could not restore snapshot"
    echo "config.rec.fish -- Could not restore snapshot"
    exit 1
end
logger -t config.rec.fish "Snapshot restoration successful"
echo "config.rec.fish -- Snapshot restoration successful"
