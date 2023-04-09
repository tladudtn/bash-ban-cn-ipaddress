# 리눅스 서버에서 중국 IP 대역 차단하기

## 주의 :
**!!! 아 직 미 완 성 !!!, 작동은 합니다.**

계속 중국에서 ssh 접속로그 찍히는게 눈에 거슬려서
bash 공부할겸 만들어 봤습니다.

## 필요한 패키지 
```bash
wc
iptables
# curl(곧 추가됩니다!)
```


## 중국 CIDR 파일 받은곳
`www.ipdeny.com/ipblocks/data/countries/cn.zone`
`https://www.ip2location.com/free/visitor-blocker`

## memo

```bash
sudo iptables -A INPUT -t filter -s xx.xx.xx.xx/24 -j DROP
```
### OMV6는 데비안 기반이라 뭔가 바뀐듯
https://arstech.net/install-iptables-in-debian-11-bullseye/

```
iptables-save > /etc/iptables/rules.v4
```
