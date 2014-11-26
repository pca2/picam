#! /bin/bash
#Master script. Checks if watcher script is running and starts it if needed. Create a cronjob for this to run every minute.
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/env.sh
pid=`cat $pid_file_location`

if ps -p $pid &> /dev/null
then
  echo "PID running. All is well."
else
  echo "PID not found. Starting watch script now."
  /bin/bash watch.sh &
  echo $! > $pid_file_location
fi
