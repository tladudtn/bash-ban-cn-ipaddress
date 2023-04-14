#!/bin/bash

# 처음에 프로그램 실행하면, 필요한 필수 패키지 확인한 후 국가별 IP 파일들 받기 
# 패키지 확인 -> 국가별 IP 범위 받기 -> 국가 선택후 정책 허용/차단 결정

mkdir rules
rules_dir="./rules"
LOCAL=""
FILE_NAME=""
FILE_LINE="0"

# 프로그램에 필요한 패키지들 확인  
function chk_package() {
if [ -z $(sudo which iptables) ] || [ -z $(which iptables) ]; then
        echo "[X] iptables not found"
        exit 1
    elif [ -z $(sudo which curl) ] || [ -z $(which curl) ]; then
        echo "[X] curl not found"
        exit 1
    elif [ -z $(sudo which wc) ] || [ -z $(which wc) ]; then
        echo "[X] wc not found"
        exit 1
else {
    echo "all package already installed"   
}
fi
   
}

select_menu() {
    echo " [    MENU    ]"
    echo "1. Select Coutury & BAN IP"
    #echo "2. Select Coutury & UNBAN IP"  
    echo -e "3. exit"
    echo -n "[1~3]: " 
    read MENU

    if [ $MENU -eq 1 ] || [ $MENU -eq 2 ]; then   
        clear
        select_contury
        elif [ $MENU -eq 3 ]; then 
            echo 3
    else   
        select_menu
    fi
}

function ban_or_unban() {
    echo " [ BAN or UNBAN ]"
    echo "1. start ban ip"
    #echo -e "2. start unban ip"
    echo -n "[1~2]: "
    read MENU

    if [ $MENU -eq 1 ]; then
        ban_ip
#        elif [ $MENU -eq 2 ]; then
#            unban_ip
    else {
        clear
        ban_or_unban
    } 
    fi
}

function file_download() {
http_code=$(curl -w '%{http_code}\n' -o ${rules_dir}/ipdeny_${LOCAL}.zone ipdeny.com/ipblocks/data/countries/${LOCAL}.zone )
    if [ $http_code -eq 200 ]; then
        echo "Download Complete!"
        FILE_NAME="./${rules_dir}/ipdeny_${LOCAL}.zone"
        clear
        ban_or_unban
        elif [ $http_code -eq 404 ]; then
            echo "404 File Not Found"
            rm -rf "${rules_dir}/ipdeny_.zone"
    else
        echo "somthing wrong"
    fi
}

function unban_ip {
    FILE_LINE=$(wc -l ./${rules_dir}/ipdeny_${LOCAL}.zone | grep -o '^[1-9]*')
    for((var=1; var<=$FILE_LINE; var++));
    do
        #echo $var
        IP_SUBNET=$(sed -n -e  "$var"p ./"$FILE_NAME")
        
        sudo iptables -A INPUT -t filter -s $IP_SUBNET -j DROP 
        echo UNBAN $IP_SUBNET COMPLETE
    done
}
# :X
function ban_ip { 
FILE_LINE=$(wc -l ./${rules_dir}/ipdeny_${LOCAL}.zone | grep -o '^[1-9]*')
    
    for((var=1; var<=$FILE_LINE; var++));
    do
        #echo $var
        IP_SUBNET=$(sed -n -e  "$var"p ./"$FILE_NAME")
        
        sudo iptables -A INPUT -t filter -s $IP_SUBNET -j DROP 
        echo BAN $IP_SUBNET COMPLETE
    done
}


function select_contury {
    echo "# Select Contury "
        echo -e "1. China\n2. Rusia\n3. Hong Kong\n4. Taiwan\n5. Indonesia"
        echo -n "[1~5]: " 
        read SELECT_LOCAL

    if [ $SELECT_LOCAL -eq 1 ]; then
            echo "SELECT CN"
            LOCAL="cn"
            file_download "$LOCAL"
            elif [ $SELECT_LOCAL -eq 2 ]; then
                echo "SELECT RU"
                LOCAL=ru
                file_download "$LOCAL"
            elif [ $SELECT_LOCAL -eq 3 ]; then
                echo "SELECT HK"
                LOCAL=hk
                file_download "$LOCAL"
            elif [ $SELECT_LOCAL -eq 4 ]; then
                echo "SELECT TW"
                LOCAL=tw
                file_download "$LOCAL"
            elif [ $SELECT_LOCAL -eq 5 ]; then
                echo "SELECT ID"
                LOCAL=id
                file_download "$LOCAL"
        else
            select_contury
    fi
}
# 해당 파일 줄수 출력

# echo $FILE_LINE

#select_contury

chk_package
select_menu
echo check rules and save your self
