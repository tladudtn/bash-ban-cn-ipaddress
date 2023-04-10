#http_code="$(curl -w '%{http_code}\n' -o /tmp/downloaded.zip http://1.2.3."
#exit_status="$?"

# download file and check http request code
#http_code=$(curl -w '%{http_code}\n' -o ipdeny_cn.zone ipdeny.com/ipblocks/data/countries/cn.zone)
#echo $http_code

# using wc 
wc -l ipdeny_cn.zone | grep -o '^[1-9]*'


