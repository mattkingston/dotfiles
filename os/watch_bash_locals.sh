#!/usr/bin/env bash

### Set initial time of file
LTIME=`stat -c %Z $HOME/.bash.local.proxy`

while true
do
   ATIME=`stat -c %Z $HOME/.bash.local.proxy`

   if [[ "$ATIME" != "$LTIME" ]]
   then
       echo "Bash local proxy settings changed"
       LTIME=$ATIME
   fi

   sleep 2
done