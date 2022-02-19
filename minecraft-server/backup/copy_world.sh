#!/bin/bash

/bin/rsync -r /opt/mcserver/serverfiles/world /home/mcuser/backup/temp/

/bin/scp -r /home/mcuser/backup/temp/world storeuser@192.168.1.5:/smb/minecraft/Minecraft1/
