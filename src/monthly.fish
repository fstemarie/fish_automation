#! /usr/bin/fish

function main
    pushd $dir
    set scripts \
        "backup/restic/appdaemon.bkp.fish" \
        "backup/restic/mosquitto.bkp.fish" \
        "backup/restic/nodered.bkp.fish" \
        "backup/restic/ombi.bkp.fish" \
        "backup/restic/plex.bkp.fish" \
        "backup/restic/radicale.bkp.fish" \
        "backup/tar/appdaemon.bkp.fish" \
        "backup/tar/mosquitto.bkp.fish" \
        "backup/tar/nodered.bkp.fish" \
        "backup/tar/ombi.bkp.fish" \
        "backup/tar/plex.bkp.fish" \
        "backup/tar/qbittorrent.bkp.fish" \
        "backup/tar/jackett.bkp.fish" \
        "backup/tar/radicale.bkp.fish" \
        "backup/rsync/podcasts.bkp.fish"

    restic unlock
    for script in $scripts
        if $script
            set -a notifications "🟢 $script"
        else
            set -a notifications "🔴 $script"
        end
    end
    restic prune

    set notifications (string join '\n' $notifications)
    echo -e $notifications | curl -T- \
        -H "title: raktar.home monthly backup report" \
        -H "priority: low" \
        -H "markdown: yes" \
        https://ntfy.sh/automation_ewNXGlvorS6g8NUr

    popd
end

main