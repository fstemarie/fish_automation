#! /usr/bin/fish

set dst /home/francois/development
set src /l/backup/raktar/development

set arch (command ls -1d $src/development.* | head -n1)
# if archive does not exist, exit
if test ! -f "$arch"
    logger -t development.rec.fish "Archive not found"
    echo "development.rec.fish -- Archive not found"
    exit
end

# if target destination does not exist, create it
if test ! -d "$dst"
    logger -t development.rec.fish "Creating non existent destination"
    echo "development.rec.fish -- Creating non existent destination"
    mkdir -p "$dst"
    if test $status -ne 0
        logger -t development.rec.fish "Cannot create missing destinatoin. Exiting..."
        echo "development.rec.fish -- Cannot create missing destinatoin. Exiting..."
        exit
    end
end

tar -xvzf "$arch" -C "$dst"
if test $status -eq 0
    logger -t development.rec.fish "The recovery was successful"
    echo "development.rec.fish -- The recovery was successful"
else
    logger -t development.rec.fish "Recovery unsuccessful"
    echo "development.rec.fish -- Recovery unsuccessful"
end
