#! /usr/bin/fish

set dst "/data/containers/radicale"
set script (status basename)

if test -z $RESTIC_REPOSITORY
    logger -t $script "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "$script -- RESTIC_REPOSITORY empty. Cannot proceed"
    exit 1
end

if test -z $RESTIC_PASSWORD
    logger -t $script "RESTIC_PASSWORD empty. Cannot proceed"
    echo "$script -- RESTIC_PASSWORD empty. Cannot proceed"
    exit 1
end

# Append date to name to avoid data loss
if test -d "$dst"
    logger -t $script "Destination already exists"
    echo "$script -- Destination already exists"

    set old "$dst"
    set dst "$old."(date +%s)
    while test -d "$dst"
        sleep 2
        set dst "$old."(date +%s)
    end
end

# Create non-existing destination
echo "$script -- Creating non existent destination"
mkdir -p "$dst"
if test $status -ne 0
    logger -t $script "Cannot create missing destination. Exiting..."
    echo "$script -- Cannot create missing destination. Exiting..."
    exit 1
end

# Recover data from archive
restic restore latest \
    --host=raktar \
    --tag=radicale \
    --target "$dst"
if test $status -ne 0
    logger -t $script "Could not restore snapshot"
    echo "$script -- Could not restore snapshot"
    exit 1
end
logger -t $script "Snapshot restoration successful"
echo "$script -- Snapshot restoration successful"
