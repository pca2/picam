DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $DIR/env.sh
pid=`cat $pid_file_location`

if ps -p $pid &> /dev/null
then
  echo "pid found not doing anything"
else
  echo "pid not found starting script"
  /bin/bash watch.sh &
  echo $! > $pid_file_location
fi

