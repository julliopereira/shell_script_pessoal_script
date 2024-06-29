#!/usr/bin/env bash 

# AUTHOR        : Julio C. Pereira
# OBJECTIVE     : Many info about IP/TARGET 
# SYSTEM DEV    : Linux 6.5.0-41-generic #41~22.04.2-Ubuntu SMP PREEMPT_DYNAMIC Mon Jun  3 11:32:55 UTC 2
# VERSION       : v0.1 20240629  

# functions

f_check_arg() {
    # the user must send one argument
    v_arg=$1 ; [ -z $v_arg ] && echo -en "\nForgot TARGET argument ... Try again !  " && read next_ && clear && exit 1 
}

f_check_apps() {
    # check apps installed - mandatory
    v_app="ping" ; [[ ! -f $(which $v_app) ]] && echo -en "\nYou have no $v_app app installed ... fix it and Try again !" && read next_ && clear && exit 1
    v_app="nc" ; [[ ! -f $(which $v_app) ]] && echo -en "\nYou have no $v_app app installed ... fix it and Try again !" && read next_ && clear && exit 1
    v_app="curl" ; [[ ! -f $(which $v_app) ]] && echo -en "\nYou have no $v_app app installed ... fix it and Try again !" && read next_ && clear && exit 1
    v_app="whois" ; [[ ! -f $(which $v_app) ]] && echo -en "\nYou have no $v_app app installed ... fix it and Try again !" && read next_ && clear && exit 1
}

f_check_target_alive() {
    # check if target is alive
    ping -c 1 $1 -W 1 > /dev/null

    if [ $? -eq 0 ]; then
        echo 0
    else
        echo 1
    fi
}

f_check_ipinfo() {
    :
}
    
f_check_whois() {
    :
}

# main

# check 
f_check_arg $1
f_check_apps

# test and return
v_ping_res=$(f_check_target_alive $v_arg) 

# get info or not reachable
if [[ $v_ping_res -eq 0 ]];then 
    f_get_ipinfo $v_arg 
    f_get_whois $v_arg
else
    echo -e "\n$v_arg Unreachable\n"
fi

exit 0

