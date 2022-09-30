#### Grant new user account with privileges & assign new privileges
    sudo usermod -aG sudo,root shay && sudo visudo
#### Add the following underneath User privilege specification 
        shay	ALL=(ALL:ALL) ALL 
#### Add the following to the bottom of file under includedir /etc/sudoers.d 
        shay ALL=(ALL) NOPASSWD: ALL
#### Copy ssh key to server
    sudo su
    mkdir -p /home/shay/.ssh/ && touch /home/shay/.ssh/authorized_keys
    curl https://github.com/cityplug.keys >> /home/shay/.ssh/authorized_keys
#### Secure SSH Server by changing default port
    nano -w /etc/ssh/sshd_config
#### Find the line that says “#Port 22” and change it to desired port 
#### Scroll down until you find the line that says “PermitRootLogin” and change to “no” 
#### PermitRootLogin “no”
#### Scroll down further and find “PasswordAuthentication” and again change to “no” 
#### PasswordAuthentication “no”
    reboot
--------------------------------------------------------------------------------
### Run the following scripts
    sudo su
    cd /opt && apt install git -y && git clone https://github.com/cityplug/studio && chmod +x studio/.scripts/*
------------------------------------------------------------------------------
    cd studio/.scripts/ && ./start.sh
    sudo su
    cd /opt/studio/.scripts/ && ./finish.sh
--------------------------------------------------------------------------------

