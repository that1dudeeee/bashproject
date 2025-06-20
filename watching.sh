
#!/bin/bash

[ "$EUID" -ne 0 ] && echo "root not found" && exit 1

file="login.py"
sudo="sudotracker.log"
alert="alert.log"
watch="./watchme"
date=$(date +"[ %Y-%m-%d %H:%M:%S ]")
old=$(sha256sum "$file" | awk '{print $1}')

[ -d "$watch" ] || { echo "$watch not found"; exit 1; }

if [ -f "$file" ]; then
    inotifywait -m "$watch" -e modify,create,delete | while read line; do
        new=$(sha256sum "$file" | awk '{print $1}')
        if [ "$old" != "$new" ]; then
            echo "ALERT $line"
            echo "$date | $line" >> "$alert"
            echo -e "\a"
            notify-send "[ALERT]"

            grep 'sudo:' /var/log/auth.log | grep "authentication failure" | while read lines; do
                user=$(echo "$lines" | awk -F'user=' '{print $2}' | cut -d' ' -f1)
                ip=$(echo "$lines" | grep -oE 'rhost=[^ ]+' | cut -d= -f2)
                echo "$date | SUDO FAILURE | user=$user ip=$ip" | tee -a "$sudo"
                notify-send "sudo alert"
            done
        fi

        if echo "$line" | grep -q "\.sh$"; then
            echo "$date | SH FILE MODIFIED: $line" | tee -a "$alert"
            notify-send "SCRIPT MOD: $line"
        fi
    done
fi




