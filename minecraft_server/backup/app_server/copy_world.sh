#!/bin/bash

# program binary referances
rsync=/usr/bin/rsync

# local directories
local_server_dir=/opt/mcserver/serverfiles
local_temp_dir=/home/mcuser/backup/temp/serverfiles

# remote directories
remote_dir=/smb/minecraft/Minecraft1/
remote_user=storeuser
remote_ip=192.168.1.5

# copies the current world directory
$rsync -r $local_server_dir $local_temp_dir

# copies the world in the temp directory to the remote host
$rsync -r $local_temp_dir $remote_user@$remote_ip:$remote_dir
