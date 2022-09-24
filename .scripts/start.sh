#!/bin/bash

# Raspbian (studio.machine v2.2) setup script.

# --- Remove Bloatware
echo "#  ---  Removing Bloatware  ---  #"
apt update && apt full-upgrade -y
apt-get autoremove && apt-get autoclean -y
rm -rf python_games && rm -rf /usr/games/
apt-get purge --auto-remove libraspberrypi-dev libraspberrypi-doc -y

# --- Disable Services
echo "#  ---  Disabling Bloatware Services  ---  #"
systemctl stop alsa-state.service hciuart.service sys-kernel-debug.mount \
systemd-udev-trigger.service systemd-journald.service \
systemd-fsck-root.service systemd-logind.service \
bluetooth.service apt-daily.service apt-daily.timer apt-daily-upgrade.timer apt-daily-upgrade.service

systemctl disable alsa-state.service hciuart.service sys-kernel-debug.mount \
systemd-udev-trigger.service systemd-journald.service \
systemd-fsck-root.service systemd-logind.service \
bluetooth.service apt-daily.service apt-daily.timer apt-daily-upgrade.timer apt-daily-upgrade.service

# --- Disable Bluetooth & Splash Screen
echo "
disable_splash=1
dtoverlay=disable-bt" >> /boot/config.txt

# --- Change root password
echo "#  ---  Change root password  ---  #"
passwd root
echo "#  ---  Root password changed  ---  #"

# --- Initialzing studio
hostnamectl set-hostname studio.dev.lan
rm -rf /etc/hosts
mv /opt/studio/.scripts/hosts /etc/hosts

# --- Install Packages
echo "#  ---  Installing New Packages  ---  #"
apt install shellinabox -y
# --- Install Docker & Docker-Compose
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update && apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y

curl -L "https://github.com/docker/compose/releases/download/$(curl https://github.com/docker/compose/releases | grep -m1 '<a href="/docker/compose/releases/download/' | grep -o 'v[0-9:].[0-9].[0-9]')/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

chmod +x /usr/local/bin/docker-compose && apt install docker-compose -y

systemctl enable docker
docker-compose --version && docker --version
usermod -aG docker shay

# --- Addons
echo "#  ---  Running Addons  ---  #"
mkdir -p /studio
chown -R shay:sambashare /studio/*

rm -rf /etc/update-motd.d/* && rm -rf /etc/motd
mv /opt/studio/10-uname /etc/update-motd.d/ && chmod +x /etc/update-motd.d/10-uname

wget https://raw.githubusercontent.com/shellinabox/shellinabox/master/shellinabox/white-on-black.css -O /etc/shellinabox/white-on-black.css
mv /opt/studio/.scripts/shellinabox /etc/default/shellinabox

# --- Security Addons
groupadd ssh-users
usermod -aG ssh-users shay
sed -i '15i\AllowGroups ssh-users\n' /etc/ssh/sshd_config

# --- Create and allocate swap
echo "#  ---  Creating 2GB swap file  ---  #"
fallocate -l 2G /swapfile
# --- Sets permissions on swap
chmod 600 /swapfile
mkswap /swapfile && swapon /swapfile
# --- Add swap to the /fstab file & Verify command
sh -c 'echo "/swapfile none swap sw 0 0" >> /etc/fstab' && cat /etc/fstab
# --- Clear older versions
sh -c 'echo "apt autoremove -y" >> /etc/cron.monthly/autoremove'
# --- Make file executable
chmod +x /etc/cron.monthly/autoremove
echo "#  ---  2GB swap file created | SYSTEM REBOOTING  ---  #"
 
reboot
# ----> Next Script | security-samba.sh