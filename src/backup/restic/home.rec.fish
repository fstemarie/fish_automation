#! /usr/bin/fish

# Append date to destination name to avoid data loss
set dst "$HOME/home."(date +%s)
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

# if target destination does not exist, create it
if test ! -d "$dst"
    echo "$script -- Creating non existent destination"
    mkdir -p "$dst"
    if test $status -ne 0
        logger -t $script "Cannot create missing destination. Exiting..."
        echo "$script -- Cannot create missing destination. Exiting..."
        exit 1
    end
end

# Recover data from archive
restic restore latest \
    --host=raktar \
    --tag=home \
    --target "$dst"
if test $status -ne 0
    logger -t $script "Could not restore snapshot"
    echo "$script -- Could not restore snapshot"
    exit 1
end
logger -t $script "Snapshot restoration successful"
echo "$script -- Snapshot restoration successful"
