#!/bin/bash

# program binary referances
tar=/usr/bin/tar
date=/usr/bin/date
find=/usr/bin/find

# backup directory
backup_dir=/smb/minecraft/Minecraft1
archive_dir=$backup_dir/archive

# compresses the current serverfiles directory
XZ_OPT=-9 /bin/tar vcJf $archive_dir/serverfiles-$($date +%F-%H-%M).tar.xz $backup_dir/serverfiles

# deletes archived serverfiles older than 14 days
$find $archive_dir/ -type f -mtime +14 -name '*.xz' -delete
