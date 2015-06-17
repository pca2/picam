#! /bin/bash
#Add containing folder to path
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
#load creds & vars file
source $DIR/env.sh

#The function below is a infinite loop. It checks the checksums of a folder. If anything has changed it logs the change, sends an email and uploads the files to dropbox. It then removes any files older than 3 minutes.  
daemon() {
  chsum1=""
  while [[ true ]]
  do
    chsum2=`find $capture_dir -type f -exec md5sum {} \;`
    if [[ $chsum1 != $chsum2 ]] ; then           
      image_dir=$(ls -t $capture_dir | head -n 1)
      echo "change detected" | logger -t watch
      /usr/bin/python $pymail $image_dir            
      #Note the line below expects that the user running this script as sudo access w/o pw
      sudo -u motion find $capture_dir/* -mmin +1 -exec rm -rf {} \;
      chsum1=`find $capture_dir -type f -exec md5sum {} \;`
    fi
    sleep 20
  done
}
daemon
