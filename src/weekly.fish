#! /usr/bin/fish

function main
    set backup (status dirname)/backup
    set scripts \
        "restic/automation.bkp.fish" \
        "restic/config.bkp.fish" \
        "restic/containers.bkp.fish"
    
    restic unlock
    for script in $scripts
        if $backup/$script
            set -a notifications "🟢 $script"
        else
            set -a notifications "🔴 $script"
        end
    end
    restic prune

    set notifications (string join '\n' $notifications)
    echo -e $notifications | curl -T- \
        --user :tk_1ev02vh79fsvs5ova2do41okahp7i \
        -H "title: raktar.home weekly backup report" \
        -H "priority: low" \
        "https://ntfy.falarie.duckdns.org/backup_raktar"
end

main
