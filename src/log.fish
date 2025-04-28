#! /usr/bin/fish

function log --description 'Log the output of a command to a file' -a message onlyecho
    # Create the log file if it doesn't exist
    if test ! -e $log
        touch $log_file
    end

    echo "$script -- $message" | tee -a $log
    if test -z "$onlyecho"
        logger -t $script "$message"
    end
end