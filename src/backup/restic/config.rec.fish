#! /usr/bin/fish

set dst "/data/config"

echo "

-------------------------------------
[[ Running $script ]]
"(date -Iseconds)"
-------------------------------------
"

if test -z "$RESTIC_REPOSITORY"
    echo (set_color brred)"[ERROR] RESTIC_REPOSITORY empty. Cannot proceed" >&2
    exit 1
end

if test -z "$RESTIC_PASSWORD_FILE" || ! test -e "$RESTIC_PASSWORD_FILE" 
    echo (set_color brred)"[ERROR] RESTIC_PASSWORD_FILE empty or does not exist. Cannot proceed"
    exit 1
end

# Append date to name to avoid data loss
if test -d "$dst"
    echo "Destination already exists"

    set old "$dst"
    set dst "$old."(date +%s)
    while test -d "$dst"
        sleep 2
        set dst "$old."(date +%s)
    end
end

# Create non-existing destination
echo "Creating non-existing destination"
mkdir -p "$dst"
if test $status -ne 0
    echo (set_color brred)"[ERROR] Cannot create missing destination. Exiting..." >&2
    exit 1
end

# Recover data from archive
echo "Recovering..."
restic restore latest \
    --host=raktar \
    --tag=config \
    --target "$dst"
if test $status -ne 0
    echo (set_color brred)"[ERROR] Could not restore snapshot" >&2
    exit 1
end
echo "Snaphot restoration successful"
