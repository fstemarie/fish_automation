#! /usr/bin/fish

# Append date to destination name to avoid data loss
set dst "$HOME/home."(date +%s)

if test -z $RESTIC_REPOSITORY
    logger -t home.rec.fish "RESTIC_REPOSITORY empty. Cannot proceed"
    echo "dhomevelopment.rec.fish -- RESTIC_REPOSITORY empty. Cannot proceed"
    exit 1
end

if test -z $RESTIC_PASSWORD
    logger -t home.rec.fish "RESTIC_PASSWORD empty. Cannot proceed"
    echo "home.rec.fish -- RESTIC_PASSWORD empty. Cannot proceed"
    exit 1
end

# if target destination does not exist, create it
if test ! -d "$dst"
    echo "home.rec.fish -- Creating non existent destination"
    mkdir -p "$dst"
    if test $status -ne 0
        logger -t home.rec.fish "Cannot create missing destination. Exiting..."
        echo "home.rec.fish -- Cannot create missing destination. Exiting..."
        exit 1
    end
end

# Recover data from archive
restic restore latest \
    --host=raktar \
    --tag=home \
    --target "$dst"
if test $status -ne 0
    logger -t home.rec.fish "Could not restore snapshot"
    echo "home.rec.fish -- Could not restore snapshot"
    exit 1
end
logger -t home.rec.fish "Snapshot restoration successful"
echo "home.rec.fish -- Snapshot restoration successful"
