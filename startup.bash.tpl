#!/bin/bash
mkuser() {
  useradd -p {{password}} admin
}
mksudoer() {
usermod -G wheel admin
sed -i -r 's/^#\s*(%wheel\s+ALL=\(ALL\)\s+ALL\s*$)/\1/' /etc/sudoers
}
config_ssh() {
echo '{{public_key}}' > /home/admin/sakuravps.pub
su - admin -c "mkdir /home/admin/.ssh"
su - admin -c "chmod 700 /home/admin/.ssh"
su - admin -c "cat /home/admin/sakuravps.pub > /home/admin/.ssh/authorized_keys"
su - admin -c "chmod 600 /home/admin/.ssh/authorized_keys"
cat /etc/ssh/sshd_config |
    sed -r 's/^#\s*(Port\s+22)/\1/'|
    sed -r 's/^#\s*(PermitRootLogin)\s+yes/\1 no/'|
    sed -r 's/^\s*(PasswordAuthentication)\s+yes/\1 no/' > ./sshd_config.mod
mv ./sshd_config.mod /etc/ssh/sshd_config
/etc/init.d/sshd reload
}
config_iptables() {
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --dport 10022 -j ACCEPT
iptables -t filter -I INPUT  -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
service iptables save
service iptables restart 
}
mkuser $1
mksudoer
config_ssh
config_iptables
