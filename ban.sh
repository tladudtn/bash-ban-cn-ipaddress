#!/bin/bash

## 패키지 확인
function chk_pkg {
    echo package checking...
    CHK_IPTABLES=$(sudo ls -al /sbin/iptables | grep iptables)
    CHK_WC=$(sudo ls -al /bin/wc | grep wc)
    CHK_WGET=$(sudo ls -al /bin/wget | grep wget)

    if [ -z $CHK_IPTABLES ]; then
        echo "[X] iptables"
        exit 1
    else
        echo "[O] iptables"  
    fi

    if [ -z $CHK_WC ]; then
        echo "[X] wc command not found"
        exit 1
    else
        echo "[O] wc"  
    fi

    if [ -z $CHK_WGET ]; then
        echo "[X] wget command not found"
        exit 1
    else
        echo "[O] wget"  
    fi
}

# curl로 중국 아이피 대역 파일 받기
function downlaod_file {
	# http code 반환된 값으로 다운로드 유뮤 확인 가능
    http_code=$(curl -w '%{http_code}\n' -o ipdeny_cn.zone ipdeny.com/ipblocks/data/countries/cn.zone)
    if [ $http_code -eq 200 ]; then
        echo "Download Complete!"

        elif [ $http_code -eq 404 ]; then
            echo "404 file not found"
    else
        echo "somthing worng"
    fi

}

function ban_ip {
chk_pkg
FILE_NAME="ipdeny_cn.zone"
FILE_LINE=$(wc -l ipdeny_cn.zone | grep -o '^[1-9]*')


# 예외처리 안함 일단 작동만 가능하게끔

for((var=1; var<=$FILE_LINE; var++));
do
    #echo $var
    IP_SUBNET=$(sed -n -e  "$var"p ./"$FILE_NAME")
    
    sudo iptables -A INPUT -t filter -s $IP_SUBNET -j DROP 
    echo BAN $IP_SUBNET COMPLETE
done

}
#chk_pkg


echo '## BAN IP ADDRESS ##'
echo "1. DOWNLOAD ipdeny.com CN CIDR file"
echo "2. ban cn ip"
echo "3. exit"

echo -n "SELECT [1~3]: " # -n 으로 newline 적용 안됨
read SELECT


if [ $SELECT -eq 1 ]; then
    echo Download ipdeny.com CN IP CIDR files
    downlaod_file
	elif [ $SELECT -eq 2 ]; then   
        ban_ip
	elif [ $SELECT -eq 3 ]; then
        exit 0;
else    
    echo out of range;
fi

# 해당 파일 줄수 출력

# echo $FILE_LINE


echo EOF
