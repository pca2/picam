email_list=''
daemon() {
    chsum1=""

    while [[ true ]]
    do
        chsum2=`find capture/ -type f -exec md5sum {} \;`
        if [[ $chsum1 != $chsum2 ]] ; then           
            echo "change detected" | logger -t watch
            echo "Motion decteced" | mail -s "Motion detected" $email_list
            /bin/bash dropbox_uploader.sh -s -q upload $HOME/capture/. .
            chsum1=$chsum2
        fi
        sleep 2
    done
}
daemon
