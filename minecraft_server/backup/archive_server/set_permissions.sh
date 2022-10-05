#!/bin/bash

# program binary referances
chown=/usr/bin/chown
chmod=/usr/bin/chmod

# user and group ownership
user=storeuser
group=storeuser

# directory permissions
perms=775

# directory 
dir=/smb/minecraft/Minecraft1

$chown -R $user:$group $dir
$chmod -R $perms $dir
