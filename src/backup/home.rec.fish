#! /usr/bin/fish

set dst /home/francois
set src /l/backup/raktar/home

set arch (command ls -1d $src/home.* | head -n1)
# if archive does not exist, exit
if test ! -f "$arch"
    logger -t home.rec.fish "Archive not found"
    echo "home.rec.fish -- Archive not found"
    exit
end

# if target destination does not exist, create it
if test ! -d "$dst"
    logger -t home.rec.fish "Creating non existent destination"
    echo "home.rec.fish -- Creating non existent destination"
    mkdir -p "$dst"
    if test $status -ne 0
        echo "home.rec.fish -- Cannot create missing destination. Exiting..."
        exit
    end
end

tar -xvzf "$arch" -C "$dst"
if test $status -ne 0
    logger -t home.rec.fish "Recovery unsuccessful"
    echo "home.rec.fish -- Recovery unsuccessful"
    exit
end
logger -t home.rec.fish "The recovery was successful"
echo "home.rec.fish -- The recovery was successful"
