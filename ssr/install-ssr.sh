#!/bin/bash
#公网ip
ip=$(curl -s cip.cc |head -1|awk '{print $3}')
#ssr端口
port=10240
#ssr密码
passwd=www.itxinmeng.cn
#协议
protocol=auth_chain_c
#混淆方式
obfs=http_post

#容器名称
container_name=$port
#密码加密
passwd_base64=$( echo -n $passwd | base64 |sed 's/=//g')
#ssr明文链接
ssr="$ip:$port:auth_aes128_sha1:aes-256-cfb:plain:$passwd_base64/?obfsparam=&remarks=eGlubWVuZw&group=eGlubWVuZy3lv4Pmoq"
#加密
base64_ssr=$(echo -n $ssr|base64)
#去除空格  /替换为_  , + 替换为 -  去除占位符 =
link=$(echo -n $base64_ssr| sed s/[[:space:]]//g|sed s#/#_#g|sed s/+/-/g|sed 's/=//g')

#检测是否有安装docker
doc=$(rpm -qa docker-ce |grep docker |wc -l) 
if [ $doc -ne 1 ];then
  yum -y install yum-utils
  yum-config-manager  --add-repo    https://download.docker.com/linux/centos/docker-ce.repo
  yum -y install docker-ce 
  systemctl start docker
  systemctl enable docker 
fi

docker run -td  --restart=always -p $port:$port -e PORT=$port -e PASSWORD=$passwd -e PROTOCOL=$protocol -e OBFS=$obfs --name $container_name  itxinmeng/ssr-server:0.2

clear


echo "===========默认配置=============="
echo -e "\033[41;37m$ip \033[0m"
echo -e "\033[41;37m端口 : $port \033[0m"
echo -e "\033[41;37m密码 : $passwd \033[0m"
echo -e "\033[41;37m加密 : ase-256-cfb \033[0m"
echo -e "\033[41;37m协议 : $protocol \033[0m"
echo -e "\033[41;37m混淆 : $obfs \033[0m"
echo "================================="
echo
echo "复制以下链接:"
echo "ssr://$link"
echo
echo
