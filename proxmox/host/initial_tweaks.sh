#!/bin/bash

# program binary referances
sed=/usr/bin/sed
echo=/usr/bin/echo
systemctl=/usr/bin/systemctl

# apt source repository files
apt_sources=/etc/apt/sources.list
apt_sources_pve=/etc/apt/sources.list.d/pve-enterprise.list

# proxmox web client .js file
proxmoxlib=/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js

# sed regex strings
sed_comment='1s/^/#/'
sed_void="s/(Ext.Msg.show\(\{\s+title: gettext\('No valid sub)/void\(\{ \/\/\1/g"

# proxmox no-subscription repo url
debian_pve_repo='deb http://download.proxmox.com/debian/pve bullseye pve-no-subscription'

# Comments out the pve-enterprise repo source
$sed -i $sed_comment $apt_sources_pve

# Adds the no-subscription Proxmox PVE repo
$echo -en "\n$debian_pve_repo\n" >> $apt_sources

# Disables the Proxmox subscription popup and creates a backup of the file
$sed -Ezi $"$sed_void" $proxmoxlib

# Restart the pveproxy service
$systemctl restart pveproxy.service
