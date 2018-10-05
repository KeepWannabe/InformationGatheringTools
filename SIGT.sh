#!/bin/bash
 
# Simple Tools for Website Information Gathering
# Coded by L0c4lh34rtz - IndoXploit
# contact me: agussetyar@indoxploit
 
merah="\e[0;31m"
ijo="\e[0;32m"
off="\e[0m"
 
function check {
    if [[ $(host google.com) ]];
        then
        echo -e "[!] $ijo HOST OK $off"
    else
        echo -e "[!] $merah HOST BELUM DI ADA $off (install dulu gan)"
        exit
    fi
 
    if [[ $(ping -q -w 1 -c 1 google.com) ]];
        then
        echo -e "[!] $ijo KONEKSI OK $off"
    else
        echo -e "[!] $merah KONEKSI MATI $off (koneksimu harus nyala mas)"
        exit
    fi
 
    echo ""
    echo ""
}
 
function _host_dom2ip {
    echo $(host -W 1 $1 | grep "has address" | cut -d " " -f 4 | sort -u | uniq)
}
 
function _host_ip2hostname {
    ip=$(_host_dom2ip $1)
    echo $(host -W 1 $ip | grep -v "not found" | cut -d " " -f 5 | sort -u | uniq)
}
 
function _host_ip {
    echo $(host -W 1 $1 | grep -v "not found" | cut -d " " -f 5 | sort -u | uniq)
}
 
function _host_t {
    if [ $1 = "ns" ];
        then
        cmd=$(host -W 1 -t $1 $2 | cut -d " " -f 4 | sort -u | uniq)
    elif [ $1 = "mx" ];
        then
        cmd=$(host -W 1 -t $1 $2 | cut -d " " -f 7 | sort -u | uniq)
    fi
    echo $cmd
}
 
check
 
echo -n "[#] Target: "
read target
 
echo ""
echo "[:::::::::IP Address::::::::]"
for ip in $(_host_dom2ip $target);
do
    echo -e "[*] $ijo $ip $off"
done
echo "[:::::::::::::::::::::::::::]"
 
echo ""
echo "[::::::::::HOSTNAME:::::::::]"
for hostname in $(_host_ip2hostname $target);
do
    if [ "$hostname" = "" ];
        then
        pesan="$merah Unknown Hostname/Not Found $off"
    elif [ "$hostname" = "no" ];
        then
        pesan="$merah no servers could be reached $off"
    else
        pesan="$ijo $hostname $off"
    fi
 
    echo -e "[*] $pesan"
done
echo "[:::::::::::::::::::::::::::]"
 
echo ""
echo "[::::::NameServer (NS)::::::]"
for ns in $(_host_t ns $target);
do
    echo -e "[*] $ijo $ns $off"
done
echo "[:::::::::::::::::::::::::::]"
 
echo ""
echo "[::::::MailServer (MX)::::::]"
for mx in $(_host_t mx $target);
do
    echo -e "[*] $ijo $mx $off"
done
echo "[:::::::::::::::::::::::::::]"
 
echo ""
echo "[::::Scan IP RANGE 1-255::::]"
_ip_=$(_host_dom2ip $target | cut -d "." -f 1-3)
for range in {1..255};
do
    _ip1_="$_ip_.$range"
    _ip2_=$(_host_ip $_ip1_)
 
    if [ "$_ip2_" = "" ];
        then
        pesan="$merah Unknown Hostname/Not Found $off"
    elif [ "$_ip2_" = "no" ];
        then
        pesan="$merah no servers could be reached $off"
    else
        pesan="$ijo $_ip2_ $off"
    fi
 
    echo -e "[*] $ijo $_ip1_ $off -> $pesan"
done
echo "[:::::::::::::::::::::::::::]"
