#!/usr/bin/env bash
:<<!
author:huangweilai
Sat Apr 13 18:26:29 CST 2019
This Scripts For CentOS6 ！
!
# 检查用户
check_user(){
[[ $UID != "0" ]] && echo -e"exit, this script does not support the current user!" && exit 1
}

# 检查系版本
check_sys(){
sys_release=`cat /etc/redhat-release | awk '{printf $1;print $3}' | cut -c1-7`
[[ $sys_release != "CentOS6" ]] && echo -e "exit, this script does not support the current system" && exit 2
}

# 备份文件
Backup_conf(){
cd /etc/selinux/ && tar -czf selinux_bak.tar.gz ./*
mkdir /etc/yum.repos.d/repo_bak ; mv /etc/yum.repos.d/*.repo repo_bak/ ; cd /etc/yum.repos.d/ && tar -czf yum_repo_bak.tar.gz repo_bak/
cd /etc/sysconfig/network-scripts && tar -czf network.tar.gz ./*
cd /etc/ssh/ && tar -czf ssh_tar.gz ./*
}

# 配置ssh
ssh_conf(){
sed -i -e 's/#UseDNS yes/UseDNS no/g' -e 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
sed -i '$a StrictHostKeyChecking no' /etc/ssh/ssh_config
/etc/rc.d/init.d/sshd restart > /dev/null 2>&1
}

# 安装工具
Setup_tool(){
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo  > /dev/null 2>&1
yum makecache > /dev/null 2>&1
yum install telnet bash-c*  lrzsz net-tools wget openssh-clients vim -y  > /dev/null 2>&1
}

# 关闭防火墙和selinux
Disable_firewall(){
systemctl stop firewalld  > /dev/null 2>&1
systemctl disable firewalld > /dev/null 2>&1
setenforce 0
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
}
#	设置时间
set_datime(){
yum -y install ntp ntpdate > /dev/null 2>&1
ntpdate ntp.aliyun.com > /dev/null 2>&1
hwclock --systohc > /dev/null 2>&1
hwclock -w > /dev/null 2>&1
}

# 执行
check_user
check_sys
Backup_conf
ssh_conf
Setup_tool
Disable_firewall
set_datime


:<<!
# 创建yum仓库
make_yum(){
rm -rf /etc/yum.repos.d/*.repo
echo -e "[local] \nname=local \nbaseurl=file:///mnt/ \ngpgcheck=0 \nenable=1 \ngpgkey=file:///mnt/" > local.repo
mount -t iso9660 /dev/sr0 /mnt >/dev/null 2>&1 && yum clean all >/dev/null 2>&11 && yum makecache > /dev/null 2>&1
Setup_tool
sleep 2
}
CentOS6:cat /etc/redhat-release | awk '{printf $1;print $3}' | cut -c1-7
CentOS7:cat /etc/redhat-release | awk '{printf $1;print $4}' | cut -c1-7
!

