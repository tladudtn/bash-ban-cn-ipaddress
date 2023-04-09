#!/bin/bash

echo '## BAN CN IP ADDRESS ##'
echo 'SELECT FILE [1/2/3]'

read SELECT;

if [ $SELECT -eq 1 ]; then
    echo selec1 file
    FILE_LINE=$(wc -l ./ip.cn.zone | grep -o '^[1-9]*')
    FILE_NAME="ip.cn.zone"
    elif [ $SELECT -eq 2 ]; then 
        echo select2 file
        FILE_LINE=$(wc -l ./ip.cn1.zone | grep -o '^[1-9]*')
        FILE_NAME="ip.cn1.zone"
    elif [ $SELECT -eq 3 ]; then
        echo s
        FILE_LINE=$(wc -l ./ip.cn2.zone | grep -o '^[1-9]*')
        FILE_NAME="ip.cn2.zone"
else   
    echo out of range;
fi

# 해당 파일 줄수 출력

# echo $FILE_LINE

# 프로그램을 실행하기 위한 패키지 확인 
CHK_IPTABLES=$(ls -al /usr/bin | grep iptables)
CHK_WC=$(ls -al /usr/bin | grep wc)

#echo $CHK_IPTABLES
#echo $CHK_WC

if [ -z $CHK_IPTABLES ]; then
    echo iptables not Found
    exit 1
else
    echo iptables already installed 
fi

if [ -z $CHK_WC ]; then
    echo wc not found
    exit 1
else
    echo wc already installed
fi

# for문 이게 더 편한듯
for((var=1; var<=$FILE_LINE; var++));
do
    #echo $var
    IP_SUBNET=$(sed -n -e  "$var"p ./"$FILE_NAME")
    
    sudo iptables -A INPUT -t filter -s $IP_SUBNET -j DROP 
    echo BAN $IP_SUBNET COMPLETE
done

echo EOF
