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
    v_app="ping" ; [[ ! -f $(which $v_app) ]] && echo -en "\nYou have no - $v_app - app installed ... fix it and Try again !" && read next_ && clear && exit 1
    #v_app="nc" ; [[ ! -f $(which $v_app) ]] && echo -en "\nYou have no - $v_app - app installed ... fix it and Try again !" && read next_ && clear && exit 1
    v_app="curl" ; [[ ! -f $(which $v_app) ]] && echo -en "\nYou have no - $v_app - app installed ... fix it and Try again !" && read next_ && clear && exit 1
    v_app="whois" ; [[ ! -f $(which $v_app) ]] && echo -en "\nYou have no - $v_app - app installed ... fix it and Try again !" && read next_ && clear && exit 1
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

f_get_ipinfo() {
    # Geo info
    v_info=$(curl -s ipinfo.io/$1 )
    # v_hostname=$(curl -s ipinfo.io/$1 | grep "hostname" | cut -d ":" -f 2 | tr -d ",")
    # v_city=$(curl -s ipinfo.io/$1 |  grep "city" | cut -d ":" -f 2 | tr -d ",")
    # v_region=$(curl -s ipinfo.io/$1 | grep "region" | cut -d ":" -f 2 | tr -d ",")
    # v_country=$(curl -s ipinfo.io/$1 | grep "country" | cut -d ":" -f 2 | tr -d ",")
    # v_loc=$(curl -s ipinfo.io/$1 | grep "loc" | cut -d ":" -f 2 )
    # v_org_all=$(curl -s ipinfo.io/$1 | grep "org" | cut -d ":" -f 2 | tr -d ",")

    # v_lat=$(echo $v_loc | sed 's/\"//g' | cut -d "," -f 1 )
    # v_long=$(echo $v_loc | sed 's/\"//g' | cut -d "," -f 2 )

    # v_org=$(echo $v_org_all | sed 's/\"//g' | cut -d " " -f 2-)
    # v_org_asn=$(echo $v_org_all | sed 's/\"//g' | cut -d " " -f 1)


    v_hostname=$(echo "$v_info" | grep "hostname" | cut -d ":" -f 2 | tr -d ",")
    v_city=$(echo "$v_info" |  grep "city" | cut -d ":" -f 2 | tr -d ",")
    v_region=$(echo "$v_info" | grep "region" | cut -d ":" -f 2 | tr -d ",")
    v_country=$(echo "$v_info" | grep "country" | cut -d ":" -f 2 | tr -d ",")
    v_loc=$(echo "$v_info" | grep "loc" | cut -d ":" -f 2 )
    v_org_all=$(echo "$v_info" | grep "org" | cut -d ":" -f 2 | tr -d "," | sed 's/^[ \t]*//')

    v_lat=$(echo "$v_loc" | sed 's/\"//g' | cut -d "," -f 1 )
    v_long=$(echo "$v_loc" | sed 's/\"//g' | cut -d "," -f 2 )

    v_org=$(echo "$v_org_all" | sed 's/\"//g' | cut -d " " -f 2-)
    v_org_asn=$(echo "$v_org_all" | sed 's/\"//g' | cut -d " " -f 1)

    echo $v_hostname 
    echo $v_city
    echo $v_region
    echo $v_country
    echo $v_lat
    echo $v_long
    echo $v_org
    echo $v_org_asn

}
    
f_get_whois() {
    # whois -h rr.ntt.net $1  | buscar o BLOCOIP, MAINTAINER, ASN, SOURCE através do ip
    v_whois_full="$(whois -h rr.ntt.net $1 | tr -s " ")"  

    # whois -h rr.ntt.net -i mnt-by $MANTAINER | buscar o route-set e os members
    # echo "$v_whois_full"
    v_route=$(echo "$v_whois_full" | grep -m 1 "route:" | cut -d ":" -f 2 | sed 's/\s//g')
    v_origin=$(echo "$v_whois_full" | grep -m 1 "origin:" | cut -d ":" -f 2 | sed 's/\s//g')
    # v_org_resp=$(echo "$v_whois_full" | grep "descr:" | cut -d ":" -f 2 | sed 's/\s//g')
    v_maintainer=$(echo "$v_whois_full" | grep -m 1  "mnt-by:" | cut -d ":" -f 2 | sed 's/\s//g')
    v_source=$(echo "$v_whois_full" | grep -m 1  "source:" | cut -d ":" -f 2 | sed 's/\s//g')

    # whois -h rr.ntt.net $1 $MANTAINER | buscar DESCR
    v_out_maintainer=$(whois -h rr.ntt.net -i mnt-by $v_maintainer | tr -s " ")

    echo $v_route
    # echo $v_origin
    # echo $v_org_resp
    echo $v_maintainer
    echo $v_source

}

f_get_nc() {
    :
}

# main

# check 
f_check_arg $1
f_check_apps

# get
f_get_ipinfo $v_arg 
f_get_whois $v_arg

# show


# test and return
# v_ping_res=$(f_check_target_alive $v_arg) 

# get info or not reachable
# if [[ $v_ping_res -eq 0 ]];then 
    # f_get_ipinfo $v_arg 
    # f_get_whois $v_arg
# else
#     echo -e "\n$v_arg Unreachable\n"
# fi

exit 0

