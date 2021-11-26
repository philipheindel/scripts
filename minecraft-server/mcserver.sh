#!/bin/bash

echo steam steam/question select "I AGREE" | sudo debconf-set-selections

echo steam steam/license note '' | sudo debconf-set-selections

yes | dpkg --add-architecture i386; 

yes | apt update;

yes | apt install curl wget file tar bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc jq tmux netcat default-jre lib32gcc1 lib32stdc++6 libsdl2-2.0-0:i386 steamcmd openjdk-16-jre

useradd -r -m -p P@ssw0rd -U -d /opt/mcserver -s /bin/bash mcserver

cd /opt/mcserver

su mcserver -c "wget -O linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh && bash linuxgsm.sh mcserver"

chown -R mcserver:mcserver /opt/mcserver

su mcserver -c "yes | /opt/mcserver/mcserver install"

chown -R mcserver:mcserver /opt/mcserver

usermod -a -G mcserver $1

