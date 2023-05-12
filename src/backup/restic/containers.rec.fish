#! /usr/bin/fish

set dst "/data/containers"

if test -z $RESTIC_REPOSITORY
    logger -t containers.rec.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "containers.rec.fish -- RESTIC_REPOSITORY empty. Cannot proceed"
    exit 1
end

if test -z $RESTIC_PASSWORD
    logger -t containers.bkp.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "containers.rec.fish -- RESTIC_PASSWORD empty. Cannot proceed"
    exit 1
end

if test -d "$dst"
    logger -t containers.rec.fish "Moving existing destination"
    echo "containers.rec.fish -- Moving existing destination"
    mv "$dst" "$dst."(date +%s)
    if test $status -ne 0
        logger -t containers.rec.fish "Cannot move existing destination. Exiting..."
        echo "containers.rec.fish -- Cannot move existing destination. Exiting..."
        exit 1
    end
end

# Append date to name to avoid data loss
if test -d "$dst"
    logger -t containers.rec.fish "Destination already exists"
    echo "containers.rec.fish -- Destination already exists"

    set old "$dst"
    set dst "$old."(date +%s)
    while test -d "$dst"
        sleep 2
        set dst "$old."(date +%s)
    end
end

# Create non-existing destination
echo "containers.rec.fish -- Creating non existent destination"
mkdir -p "$dst"
if test $status -ne 0
    logger -t containers.rec.fish "Cannot create missing destination. Exiting..."
    echo "containers.rec.fish -- Cannot create missing destination. Exiting..."
    exit 1
end

# Recover data from archive
echo "containers.rec.fish -- Recovering..."
restic restore latest \
    --host=raktar \
    --tag=containers \
    --target "$dst"
if test $status -ne 0
    logger -t containers.rec.fish "Could not restore snapshot"
    echo "containers.rec.fish -- Could not restore snapshot"
    exit 1
end
logger -t containers.rec.fish "Snapshot restoration successful"
echo "containers.rec.fish -- Snapshot restoration successful"
