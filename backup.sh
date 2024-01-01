#!/bin/bash
set -e
cd "$(dirname "$0")"

if [ $# -lt 1 ]; then
    echo "usage: $0 <IP> [<PASSWORD>]"
    exit 1
fi

IP="$1"
echo "backup remarkable at $IP"

SSHPASS=
if [ $# -gt 1 ]; then
    echo "Note: passing the password via commandline is unsafe - you should rather use a SSH key." 
    PASSWD="$2"
    SSHPASS="sshpass -p $PASSWD"
fi

TARGET_FOLDER="files"
rm -rf "$TARGET_FOLDER"
mkdir "$TARGET_FOLDER"

echo
echo "check connection..."
ping -W 1 -c 1 $IP >/dev/null 2>&1 || (echo "failed" && exit 1)
echo ok

echo "backup documents..."
$($SSHPASS scp -r root@$IP:/home/root/.local/share/remarkable/xochitl/ ./files/)
echo ok

echo "backup config..."
$($SSHPASS scp -r root@$IP:/home/root/.config/remarkable/xochitl.conf .)
echo ok

echo "backup complete"
