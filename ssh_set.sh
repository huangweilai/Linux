#!/usr/bin/env bash
:<<!
author:huangweilai
Sat Apr 13 18:26:29 CST 2019
This Scripts For CentOS6 ！
!
:<<!
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
!
# 配置ssh
ssh_conf(){
cp /etc/ssh/sshd_config /etc/ssh/sshd_config-bak
cp /etc/ssh/ssh_config /etc/ssh/ssh_config-bak
sed -i -e 's/#UseDNS yes/UseDNS no/g' -e 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/g' /etc/ssh/sshd_config
sed -i '$a StrictHostKeyChecking no' /etc/ssh/ssh_config
systemctl restart sshd >/dev/null 2>&1
/etc/rc.d/init.d/sshd restart >/dev/null 2>&1
}

ssh_conf
