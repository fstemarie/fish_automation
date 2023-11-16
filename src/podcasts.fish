#! /usr/bin/fish

function main
    set backup (status dirname)/backup
    set script "rsync/hdtgm-tx.bkp.fish"
    set -U podcasts_comm

    $backup/$script
    set ret $status
    if test $ret -eq 0
        if test "$podcasts_comm" = "DIFFS"
            set notification "🟢 $script"
        end
    else
        set notification "🔴 $script"
    end

    if set -q notification
        set notification (string join '\n' $notification)
        echo -e $notification | curl -T- \
            --user :tk_1ev02vh79fsvs5ova2do41okahp7i \
            -H "title: raktar.home -> bedroom.home - Podcasts transfer report" \
            -H "priority: low" \
            "https://ntfy.falarie.duckdns.org/backup_raktar"
    end
    set -e podcasts_comm
end

main