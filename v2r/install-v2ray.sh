#!/bin/bash
mkdir /root/conf
wget https://itxinmeng.cn/script/config.json -O /root/conf/config.json

uuid=$(uuidgen)
port=10000

sed -i "11s/PORT/$port/" /root/conf/config.json
sed -i "16s/UUID/$uuid/"  /root/conf/config.json

#检测是否有安装docker
doc=$(rpm -qa docker-ce |grep docker |wc -l) 
if [ $doc -ne 1 ];then
  yum -y install yum-utils
#  yum-config-manager  --add-repo   http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
  yum-config-manager  --add-repo    https://download.docker.com/linux/centos/docker-ce.repo
  yum -y install docker-ce 
  systemctl start docker
#  echo '{ "registry-mirrors": ["https://b9pmyelo.mirror.aliyuncs.com"] }' > /etc/docker/daemon.json
  systemctl enable docker 
  systemctl restart docker
fi

docker run -td -p $port:$port -v /root/conf:/etc/v2ray  --name v2ray v2ray/official

ip=$(curl -s cip.cc |head -1 |awk -F : '{print "address:"$2}')
clear
echo "===========默认配置=============="
echo -e "\033[41;37m$ip \033[0m"
echo -e "\033[41;37mport   : $port \033[0m"
echo -e "\033[41;37mid     : $uuid \033[0m"
echo -e "\033[41;37malterId: 32 \033[0m"
echo -e "\033[41;37mnetwork: tcp \033[0m"
echo "================================="

