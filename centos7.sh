#!/usr/bin/env bash
:<<!
author:huangweilai
Sat Apr 13 18:26:29 CST 2019
This Scripts For CentOS6 ！
!

# 检查系版本
check_sys(){
sys_release=`cat /etc/redhat-release | awk '{printf $1;print $4}' | cut -c1-7`
[[ $sys_release != "CentOS7" ]] && echo -e "Exited, this script does not support the current system!" && exit 1
}

# 备份文件
Backup_conf(){
cp -p /etc/selinux/config /etc/selinux/config.bak
tar cf /etc/yum.repos.d/bak_repo.tar.gz /etc/yum.repos.d/*  >/dev/null 2>&1
tar cf /etc/sysconfig/network-scripts/bak_ifcfg.tar.gz /etc/sysconfig/network-scripts/* >/dev/null 2>&1
}

# 配置ssh
ssh_conf(){
cp /etc/ssh/sshd_config /etc/ssh/sshd_config-bak
cp /etc/ssh/ssh_config /etc/ssh/ssh_config-bak
sed -i -e 's/#UseDNS yes/UseDNS no/g' -e 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
sed -i '$a StrictHostKeyChecking no' /etc/ssh/ssh_config
/etc/rc.d/init.d/sshd restart >/dev/null 2>&1
}

# 安装工具
Setup_tool(){
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo >/dev/null 2>&1
yum makecache >/dev/null 2>&1
yum install telnet bash-c*  lrzsz net-tools wget openssh-clients vim -y  >/dev/null 2>&1
}

# 关闭防火墙和selinux
Disable_firewall(){
systemctl stop firewalld  >/dev/null 2>&1
systemctl disable firewalld >/dev/null 2>&1
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
}

# 获取IP
get_ip(){
ip add | grep "scope global" | awk '{print $NF,$2}' 
}

# set_PS1
set_envps1(){
echo 'PS1="\[\e[1;37;40m\]\[\e[1;32;40m\]\u\[\e[1;33;40m\]@\h \[\e[1;36;40m\]\w\[\e[0m\] \\$"' > /etc/profile.d/env.sh
source /etc/profile.d/env.sh
}

# 执行
check_sys
Backup_conf
ssh_conf
Setup_tool
Disable_firewall
get_ip
set_envps1

:<<!
# 创建yum仓库
make_yum(){
rm -rf /etc/yum.repos.d/*.repo
echo -e "[local] \nname=local \nbaseurl=file:///mnt/ \ngpgcheck=0 \nenable=1 \ngpgkey=file:///mnt/" > local.repo
mount -t iso9660 /dev/sr0 /mnt >/dev/null 2>&1 && yum clean all >/dev/null 2>&1 && yum makecache >/dev/null 2>&1
Setup_tool
sleep 2
}
CentOS6:cat /etc/redhat-release | awk '{printf $1;print $3}' | cut -c1-7
CentOS7:cat /etc/redhat-release | awk '{printf $1;print $4}' | cut -c1-7
!



