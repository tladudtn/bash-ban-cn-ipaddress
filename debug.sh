#http_code="$(curl -w '%{http_code}\n' -o /tmp/downloaded.zip http://1.2.3."
#exit_status="$?"

# download file and check http request code
#http_code=$(curl -w '%{http_code}\n' -o ipdeny_cn.zone ipdeny.com/ipblocks/data/countries/cn.zone)
#echo $http_code

# using wc 
# wc -l ipdeny_cn.zone | grep -o '^[1-9]*'

function file_download() {
rules_dir="./rules"
http_code=$(curl -w '%{http_code}\n' -o ${rules_dir}/ipdeny_${LOCAL}.zone ipdeny.com/ipblocks/data/countries/${LOCAL}.zone )
echo $catch_pid
    if [ $http_code -eq 200 ]; then
        echo "Download Complete!"
        elif [ $http_code -eq 404 ]; then
        	# 좀더 깔쌈한 방법이 있을거 같은데..
            echo "404 File Not Found"
            rm -rf "${rules_dir}/ipdeny_.zone"
    else
        echo "somthing wrong"
    fi
}

echo "# Downloading Contury "
    echo -e "1. China\n2. Rusia\n3. Hong Kong\n4. Taiwan\n5. Indonesia"
    echo -n "Select Coutury [1~5]: " 
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

file_download "$LOCAL"
wc -l ./${rules_dir}/ipdeny_${LOCAL}.zone | grep -o '^[1-9]*'

# 중국 인도 러시아 대만 홍콩

#http://www.ipdeny.com/ipblocks/data/countries/cn.zone
#http://www.ipdeny.com/ipblocks/data/countries/id.zone
#http://www.ipdeny.com/ipblocks/data/countries/ru.zone
#http://www.ipdeny.com/ipblocks/data/countries/tw.zone
#http://www.ipdeny.com/ipblocks/data/countries/hk.zone

:<<'END'
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
END