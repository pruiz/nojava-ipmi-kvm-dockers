#!/bin/bash -ex

read -r -s PASSWORD

HOST=$KVM_HOSTNAME
while :; do
        case "$1" in
        -u)
                shift
                USER="$1"
                ;;
        --)
                shift
                break
                ;;
        '')
                break
                ;;
        esac
        shift
done

# Replace variables in `/etc/supervisord.conf`
for v in XRES VNC_PASSWD HOST USER PASSWORD; do
    eval sed -i "s/{$v}/\$$v/" /etc/supervisor/conf.d/supervisord.conf
done

exec /usr/bin/supervisord
