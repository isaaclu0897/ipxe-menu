#!/bin/bash

mount.cifs //192.168.87.9/Users/Administrator/Downloads/os_images /var/www/ds/images -o username=administrator,uid=$(id -u),gid=$(id -g)

# ---
# ubuntu

# 22.04.1
mount -o loop,x-mount.mkdir /var/www/ds/images/ubuntu-22.04.1-desktop-amd64.iso /var/www/ds/images_file/ubuntu/22_04_1

	
mount -o loop,x-mount.mkdir /var/www/ds/images/ubuntu-22.04.1-live-server-amd64.iso /var/www/ds/images_file/ubuntu/live_server_22_04_1

# ---
# redhat

# 8.5.0
mount -o loop,x-mount.mkdir /var/www/ds/images/RHEL-8.5.0-20211013.2-x86_64-dvd1.iso /var/www/ds/images_file/redhat/8_5_0

# 8.6.0
mount -o loop,x-mount.mkdir /var/www/ds/images/RHEL-8.6.0-20220420.3-x86_64-dvd1.iso /var/www/ds/images_file/redhat/8_6_0

# 9.1.0
mount -o loop,x-mount.mkdir /var/www/ds/images/RHEL-9.1.0-20220829.0-x86_64-dvd1.iso /var/www/ds/images_file/redhat/9_1_0

# ---
# oracle

# 8.6.0
mount -o loop,x-mount.mkdir /var/www/ds/images/OracleLinux-R8-U6-x86_64-dvd.iso /var/www/ds/images_file/oracle/8_6_0


# ---
# gparted
mount -o loop,x-mount.mkdir /var/www/ds/images/gparted-live-1.4.0-5-amd64.iso /var/www/ds/images_file/gparted/1_4_0_5

