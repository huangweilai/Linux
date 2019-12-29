#!/usr/bin/env bash
:<<!
author:huangweilai
Sun Dec 29 11:06:33 CST 2019
This Scripts For CentOS6 ！
!


# 检查用户&系统版本
check_user(){
sys_release=`cat /etc/redhat-release | awk '{printf $1;print $3}' | cut -c1-7`
[[ $UID != "0" ]] && echo -e "\033[31mthis script does not support the current user\033[0m" && exit 1
[[ $sys_release != "CentOS6" ]] && echo -e "\033[31mthis script does not support the current system\033[0m" && exit 2
}

# 备份文件
Backup_conf(){
cd /etc/selinux/ && tar -czf selinux_bak.tar.gz ./*
cd /etc/yum.repos.d/ && tar -czf yum_repo_bak.tar.gz ./* ; rm -f *.repo
cd /etc/sysconfig/network-scripts && tar -czf network.tar.gz ./*
cd /etc/ssh/ && tar -czf ssh_tar.gz ./*
[[ $? = "0" ]] && echo -e "\033[32mconfiguration file backup succeeded\033[0m" 
}

# 配置系统
set_conf(){
sed -i -e 's/#UseDNS yes/UseDNS no/g' -e 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
sed -i '$a StrictHostKeyChecking no' /etc/ssh/ssh_config
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
/etc/rc.d/init.d/sshd restart > /dev/null 2>&1
service iptables stop > /dev/null 2>&1
chkconfig iptables off > /dev/null 2>&1
setenforce 0
ntpdate ntp.aliyun.com > /dev/null 2>&1
hwclock --systohc > /dev/null 2>&1
hwclock -w > /dev/null 2>&1
[[ $? = "0" ]] && echo -e "\033[32msystem configuration succeeded\033[0m" 
}

# 安装工具
install_tool(){
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo > /dev/null 2>&1
yum makecache > /dev/null 2>&1
yum install telnet bash-c*  lrzsz net-tools wget openssh-clients vim ntp ntpdate -y  > /dev/null 2>&1
[[ $? = "0" ]] && echo -e "\033[32minstall tools succeeded\033[0m"
}

# 执行
check_user
Backup_conf
set_conf
install_tool



:<<!
# 创建yum仓库
make_yum(){
rm -rf /etc/yum.repos.d/*.repo
echo -e "[local] \nname=local \nbaseurl=file:///mnt/ \ngpgcheck=0 \nenable=1 \ngpgkey=file:///mnt/" > local.repo
mount -t iso9660 /dev/sr0 /mnt >/dev/null 2>&1 && yum clean all >/dev/null 2>&1 && yum makecache > /dev/null 2>&1
Setup_tool
sleep 2
}
CentOS6:cat /etc/redhat-release | awk '{printf $1;print $3}' | cut -c1-7
CentOS7:cat /etc/redhat-release | awk '{printf $1;print $4}' | cut -c1-7
# set_PS1
set_envps1(){
echo 'PS1="\[\e[1;31m\]\u\[\e[1;33m\]@\H \[\e[1;36m\]\w\[\e[0m\] \\$ "' > /etc/profile.d/env.sh
source /etc/profile.d/env.sh
}

# 获取IP
get_ip(){
ip add | grep "scope global" | awk '{print $NF,$2}' 
}
!


