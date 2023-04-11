#!/bin/bash

rules_dir="./rules"
LOCAL=""
FILE_NAME=""
FILE_LINE="0"


function file_download() {
http_code=$(curl -w '%{http_code}\n' -o ${rules_dir}/ipdeny_${LOCAL}.zone ipdeny.com/ipblocks/data/countries/${LOCAL}.zone )
    if [ $http_code -eq 200 ]; then
        echo "Download Complete!"
        FILE_NAME="./${rules_dir}/ipdeny_${LOCAL}.zone"
        elif [ $http_code -eq 404 ]; then
        	# 좀더 깔쌈한 방법이 있을거 같은데..
            echo "404 File Not Found"
            rm -rf "${rules_dir}/ipdeny_.zone"
    else
        echo "somthing wrong"
    fi
}


# 예외처리 안함 일단 작동만 가능하게끔
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
#chk_pkg

function select_contury {
    echo "# Select Contury "
        echo -e "1. China\n2. Rusia\n3. Hong Kong\n4. Taiwan\n5. Indonesia"
        echo -n "[1~5]: " 
        read SELECT_LOCAL

    if [ $SELECT_LOCAL -eq 1 ]; then
            echo "SELECT CN"
            LOCAL="cn"
            elif [ $SELECT_LOCAL -eq 2 ]; then
                echo "SELECT RU"
                LOCAL=ru
            elif [ $SELECT_LOCAL -eq 3 ]; then
                echo "SELECT HK"
                LOCAL=hk
            elif [ $SELECT_LOCAL -eq 4 ]; then
                echo "SELECT TW"
                LOCAL=tw
            elif [ $SELECT_LOCAL -eq 5 ]; then
                echo "SELECT ID"
                LOCAL=id
        else
            echo "out of range"
    fi
}
# 해당 파일 줄수 출력

# echo $FILE_LINE

select_contury
file_download "$LOCAL"
ban_ip
echo EOF
