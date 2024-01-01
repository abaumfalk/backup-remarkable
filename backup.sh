#!/bin/bash
set -e
cd "$(dirname "$0")"

if [ $# -lt 1 ]; then
    echo "usage: $0 <IP> [<PASSWORD>]"
    exit 1
fi

IP="$1"
echo "backup remarkable at $IP"
if [ -e files ]; then
    echo -n "before: "
    du -hs files
fi

CMD_PREFIX=()
if [ $# -gt 1 ]; then
    PASSWD="$2"
    export SSHPASS="$PASSWD"
    CMD_PREFIX=(sshpass -e)
fi

TARGET_FOLDER="files"
rm -rf "$TARGET_FOLDER"
mkdir "$TARGET_FOLDER"

echo
echo "check connection..."
ping -W 1 -c 1 $IP >/dev/null 2>&1 || (echo "failed" && exit 1)
echo ok

echo "backup documents..."
cmd=("${CMD_PREFIX[@]}" scp -r root@$IP:/home/root/.local/share/remarkable/xochitl/ ./files/)
"${cmd[@]}"
echo ok

echo "backup config..."
cmd=("${CMD_PREFIX[@]}" scp -r root@$IP:/home/root/.config/remarkable/xochitl.conf .)
"${cmd[@]}"
echo ok

echo -n "backup complete: "
du -hs files
