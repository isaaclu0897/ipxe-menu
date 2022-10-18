How to setup iPXE Boot Server on Ubuntu
===

[TOC]

### Summary
iPXE is the leading open source network boot firmware.
In the scenario of multiple installations, PXE netboot can save your life.
This article will show you how to set up Ubuntu as a PXE boot Server step by step

### Prerequisites
1. Storage Server for OS image 
2. DHCP Server -> use Windows DHCP
3. disable all of firewall

### Environment

Internal network: 192.168.87.0/24

IP: 192.168.87.8
OS: Ubuntu 22.04.1 LTS
Role: iPXE Boot Server (Apache2 + Dnsmasq + iPXE)
:arrow_up: We Will setup it, follow below step by step

IP: 192.168.87.9
OS: Windows Server 2016
Role: OS image

IP: 192.168.87.10
OS: Windows Server 2016
Role: DHCP

IP: 192.168.87.100-150
OS: N/A
Role: Client with DHCP IP

### How to setup PXE Boot Server on Ubuntu
1. Install and Configure HTTP -> Apache2
2. Install and Configure TFTP -> Dnsmasq
3. Clone iPXE from git and Configure
4. DHCP assign IP and bootfile for TFTP (using Windows DHCP) 
5. Perform PXE Boot

### Step by step

#### Install and Configure HTTP -> Apache2
1. Install Apache2 from apt
    ```bash
    > apt install apache2 -y
    ```
2. Set DocumentRoot what you want, here is your http root folder
    ```bash
    > vim /etc/apache2/sites-available/000-default.conf
    <VirtualHost *:80>

            ServerAdmin webmaster@localhost
            DocumentRoot /var/www

            ErrorLog ${APACHE_LOG_DIR}/error.log
            CustomLog ${APACHE_LOG_DIR}/access.log combined

    </VirtualHost>
    ```
3. Set Directory path and permission as your file server
    ```bash
    > vim /etc/apache2/apache2.conf

    ...

    <Directory /var/www/>
            Options Indexes FollowSymLinks
            AllowOverride None
            Require all granted
    </Directory>

    ...

    ```
5. Restart and enable the apache servive, if you want you can check service status
```bash
> systemctl restart apache2
> systemctl enable apache2
> systemctl status apache2
```
6.  Now you are able to use http service
![](https://i.imgur.com/gPcbIS0.png =500x)

#### Install and Configure TFTP -> Dnsmasq
1. Install Apache2 from apt
    ```bash
    > apt install dnsmasq -y
    ```
2. (Option) After your installation is complete, the system will automatically enable the service.
but you may get an error message that the service cannot be enabled.
    ```bash
    10:38:12 ubuntu-Virtual-Machine systemd[1]: Starting dnsmasq - A lightweight DHCP and caching DNS server...
    10:38:12 ubuntu-Virtual-Machine dnsmasq[6303]: dnsmasq: failed to create listening socket for port 53: Address already in use
    10:38:12 ubuntu-Virtual-Machine dnsmasq[6303]: failed to create listening socket for port 53: Address already in use
    10:38:12 ubuntu-Virtual-Machine dnsmasq[6303]: FAILED to start up
    10:38:12 ubuntu-Virtual-Machine systemd[1]: dnsmasq.service: Control process exited, code=exited, status=2/INVALIDARGUMENT
    10:38:12 ubuntu-Virtual-Machine systemd[1]: dnsmasq.service: Failed with result 'exit-code'.
    10:38:12 ubuntu-Virtual-Machine systemd[1]: Failed to start dnsmasq - A lightweight DHCP and caching DNS server.
    ```
3. (Option) Check which service is occupying the port, then you can stop and disable it, if you not use. Finally, restart and enable dnsmasq to make it work.
    ```bash
    > netstat -antp | grep :53
    tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      577/systemd-resolve

    > systemctl stop systemd-resolved
    > systemctl disable systemd-resolved
    Removed /etc/systemd/system/dbus-org.freedesktop.resolve1.service.
    Removed /etc/systemd/system/multi-user.target.wants/systemd-resolved.service.

    > systemctl restart dnsmasq
    > systemctl enable dnsmasq
    Synchronizing state of dnsmasq.service with SysV service script with /lib/systemd/systemd-sysv-install.
    Executing: /lib/systemd/systemd-sysv-install enable dnsmasq
    ```
4. Create directory and configure Dnsmasq as a TFTP server only.
Note, in fact you make Dnsmasq as a DHCP/TDTP server, but I already had Windows DHCP, so just enable the feature for TFTP.
    ```bash
    > mkdir /var/www/ds
    > vim /etc/dnsmasq.conf
    # Listen on this specific port instead of the standard DNS port
    # (53). Setting this to zero completely disables DNS function,
    # leaving only DHCP and/or TFTP.
    #port=5353
    port=0

    # Enable dnsmasq's built-in TFTP server
    #enable-tftp
    enable-tftp

    # Set the root directory for files available via FTP.
    #tftp-root=/var/ftpd
    tftp-root=/var/www/ds
    ```
5. Verify that TFTP service is working, similar command like below, and you may need to install tftp client by yourself
``` 
> tftp 127.0.0.1 -c get a # get file a from tftp root, need to create file first
```

### Reference article


> [Read-only TFTP with Dnsmasq](https://netbeez.net/blog/read-only-tftp-dnsmasq/)
> Here have How to set Dnsmasq as a TFTP server only
> 
> [Setup PXE Boot Server using cloud-init for Ubuntu 20.04 \[Step-by-Step\]](https://www.golinuxcloud.com/pxe-boot-server-cloud-init-ubuntu-20-04/)
> Here Why not using kickstart? and How to use cloud-init or auto-install?
> 
> [How to generate cloud-init user-data file for Ubuntu](https://www.golinuxcloud.com/generate-user-data-file-ubuntu-20-04/)
> nice
