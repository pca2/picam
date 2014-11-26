#! /bin/bash
#Add containing folder to path
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
#load creds & vars file
source $DIR/env.sh

daemon() {
    chsum1=""

    while [[ true ]]
    do
        chsum2=`find $capture_dir -type f -exec md5sum {} \;`
        if [[ $chsum1 != $chsum2 ]] ; then           
            echo "change detected" | logger -t watch
            echo "Motion decteced" | mail -s "Motion detected at $ddate" $email_list
            /bin/bash $dropbox_uploader -s -q upload $capture_dir/. .
            chsum1=$chsum2
            #Note the line below expects that the user running this script as sudo access w/o pw
            sudo -u motion find $capture_dir -type f -mmin 10 -exec rm {} \;
        fi
        sleep 2
    done
}
daemon
