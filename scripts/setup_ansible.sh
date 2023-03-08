#!/bin/sh

##### Binaries #####
ECHO="/bin/echo"
SSH="/bin/ssh"
SSH_COPY_ID="/bin/ssh-copy-id"
READ="/usr/bin/read"
CAT="/usr/bin/cat"

# CHECK_USAGE
if [ -z "$1" ] ; then
        echo "usage: setupansible.sh <hostname or ip address>"
        exit
fi

##### Functions #####
function CHECK_SSH {
$SSH -oStrictHostKeyChecking=no -oBatchMode=yes -q $1 exit
# -oStrictHostKeyChecking=no will automatically accept the key on first connect
# -oBatchMode=yes will immediately fail if it asks for a password
# -q tells is to return a response code
# Response codes are 0 if successful, 255 if fail
# Setup error checking to copy key across if fail then retest
if [ $? != 0 ]; then
   $SSH_COPY_ID -o LogLevel=QUIET $USER@$1 2> /dev/null
fi

if [ $? != 0 ]; then
   $READ -p "Copy of the ssh key failed.  Press ^c to quit or enter to retry: "
   CHECK_SSH $1
fi
}

CHECK_SSH $1

