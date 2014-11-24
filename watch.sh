email_list=''
capture_dir='/home/pi/capture'
daemon() {
    chsum1=""

    while [[ true ]]
    do
        chsum2=`find $capture_dir -type f -exec md5sum {} \;`
        if [[ $chsum1 != $chsum2 ]] ; then           
            echo "change detected" | logger -t watch
            echo "Motion decteced" | mail -s "Motion detected" $email_list
            /bin/bash dropbox_uploader.sh -s -q upload $capture_dir/. .
            chsum1=$chsum2
            find $capture_dir -type f -mmin 10 -exec rm {} \;
        fi
        sleep 2
    done
}
daemon
