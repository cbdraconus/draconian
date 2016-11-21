#!/bin/bash
echo "What is the IP address you are connecting to? "
read IP
echo "What is the username you are connecting to? "
read NAME
echo "What is the port number you are connecting to? "
read PORT
echo "What files are you wanting to transfer? "
read FILES
echo "What is the destintion location for the files? "
read DEST
rsync -azvh -e "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -p $PORT" --progress $FILES $NAME@$IP:/$DEST
