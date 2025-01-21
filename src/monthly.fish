#! /usr/bin/fish

function main
    pushd /data/automation
    set scripts

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

# main