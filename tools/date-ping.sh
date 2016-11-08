ping $1 | while read pong; do echo $(date +%T) — $pong;done
