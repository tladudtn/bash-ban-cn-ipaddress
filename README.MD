# bash-ban-cn-ipaddress

NAS 운영하면서 중국이 공격하는게 거슬려서 만든 단순한 스크립트입니다.

bash 공부해볼겸 만들어봤어요

내가 봐도 코드를 개판으로 짠거 같아요


## 필요한 패키지 
```bash
wc
iptables
curl
```

## 폴더 구조 

```txt
./BASH_BAN_CN_IP
    ㄴ ban.sh 
    ㄴ debug.sh
    ㄴ ./BASH_BAN_CN_IP/rules
        ㄴ ipdeny_cn.zone  
        ㄴ ipdeny_ru.zone
        ㄴ ipdeny_tw.zone
        ㄴ ipdeny_hk.zone
        ㄴ custom.zone
```


