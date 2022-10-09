#!/bin/bash

sed=/usr/bin/sed
echo=/usr/bin/echo
cp=/usr/bin/cp
systemctl=/usr/bin/systemctl

apt_sources=/etc/apt/sources.list
apt_sources_pve=/etc/apt/sources.list.d/pve-enterprise.list
proxmoxlib=/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js

sed_comment='1s/^/#/'
sed_void_message1='s/if (res === null || res === undefined || !res || res/if (false) {/'
sed_void_message2='s/.data.status.toLowerCase() !== '"'"'active'"'"') {//'
debian_pve_repo='deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription'

# Comments out the pve-enterprise repo source
$sed -i $sed_comment $apt_sources_pve

# Adds the no-subscription Proxmox PVE repo
$echo -en "\n$debian_pve_repo\n" >> $apt_sources

# Disables the Proxmox subscriptio popup
$cp $proxmoxlib $proxmoxlib.bak
$sed -i $"$sed_void_message1" $proxmoxlib
$sed -i $"$sed_void_message2" $proxmoxlib

# Restart the pveproxy service
$systemctl restart pveproxy.service
