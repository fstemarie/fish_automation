#! /usr/bin/fish

function main
    pushd /data/automation
    set scripts \
        "./backup/restic/automation.bkp.fish" \
        "./backup/restic/config.bkp.fish" \
        "./backup/tar/jackett.bkp.fish" \
        "./backup/tar/qbittorrent.bkp.fish" \
        "./docker/iot.update.fish" \
        "./docker/mariadb.update.fish" \
        "./docker/media.update.fish" \
        "./docker/pirateisland.update.fish" \
        "./docker/radicale.update.fish"

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
        -H "title: raktar.home weekly backup report" \
        -H "priority: low" \
        -H "markdown: yes" \
        https://ntfy.sh/automation_ewNXGlvorS6g8NUr

    popd
end

main
