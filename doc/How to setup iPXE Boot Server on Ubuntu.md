How to setup PXE Boot Server on Ubuntu (using iPXE)
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
5. Perform PXE Boot and check it works
6. Finish up

pxe boot process
![](https://i.imgur.com/mfyBXG0.png =500x)

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

#### Clone iPXE from git and Configure

1. Get iPXE source code
    ```bash
    > git clone git://git.ipxe.org/ipxe.git
    ```
2. (Option) Before you make src, you may need to install some package, such as `make` `gcc`, [see more](https://ipxe.org/download)
    ```bash
    > apt install make gcc liblzma-dev mtools -y
    ```
3. Befor you make src, need to create a iPXE script that will become chain another iPXE srcipt
    ```
    > vim script.ipxe
    #!ipxe

    dhcp

    chain settings.ipxe ||
    ```
4. Make your iPXE source code, below is how to compile x64 legacy and efi binaries, [see more](https://ipxe.org/download).
    ```bash
    > cd src
    > make -j 16 bin-x86_64-pcbios/undionly.kpxe EMBED=../script.ipxe
    > make -j 16 bin-x86_64-efi/{ipxe.efi,snponly.efi} EMBED=../script.ipxe
    ```
5. link iPXE binary to tftp root
    ```bash
    > ln -snf src/bin-x86_64-pcbios/undionly.kpxe undionly.kpxe
    > ln -snf src/bin-x86_64-efi/ipxe.efi ipxe.efi
    > ln -snf src/bin-x86_64-efi/snponly.efi snponly.efi
    ```
6. Make your file and folder, such as `autoinstall` `menu` `os_images` `settings.ipxe`, then your foler struction will such as below.
    Directory Structure:
    * `/var/www`: HTTP root
    * `/var/www/ds` : TFTP and iPXE root
    * `/var/www/ds/menu` : iPXE menu, each menu has a `menu.ipxe` as the startup menu
    * `/var/www/ds/os_images` : the location where the os image is stored
    * `/var/www/ds/settings.ipxe` : as the script for the initial startup of ipxe
    ```
    # tree -I 'src|html' --dirsfirst /var/www/
    /var/www/
    └── ds
        ├── autoinstall
        ├── menu
        │   ├── linux
        │   │   ├── centos
        │   │   │   └── menu.ipxe
        │   │   ├── redhat
        │   │   │   └── menu.ipxe
        │   │   ├── ubuntu
        │   │   │   └── menu.ipxe
        │   │   └── menu.ipxa
        │   ├── windows
        │   │   └── menu.ipxe
        │   └── menu.ipxe
        ├── os_images
        ├── automake.sh
        ├── ipxe.efi -> src/bin-x86_64-efi/ipxe.efi
        ├── README
        ├── script.ipxe
        ├── settings.ipxe
        ├── snponly.efi -> src/bin-x86_64-efi/snponly.efi
        └── undionly.kpxe -> src/bin-x86_64-pcbios/undionly.kpxe
    ```
7. Let's make a simple menu to get started
    ```
    > vim settings.ipxe
    #!ipxe

    # Variables are specified in boot.ipxe.cfg
    set tftp-url tftp://192.168.87.10               # tftp root
    set tftp-boot-url ${tftp-url}/boot              # tftp root/boot
    set http-url http://192.168.87.8                # /var/www
    set http-menu-url ${http-url}/ds/menu           # /var/www/ds/menu

    # Some menu defaults
    set menu-timeout 0 # 60000
    set submenu-timeout ${menu-timeout}
    isset ${menu-default} || set menu-default exit

    chain ${http-menu-url}/menu.ipxe
    ```
    ```
    > vim menu/menu.ipxe
    #!ipxe


    ###################### MAIN MENU ######################

    :main_menu
    menu Welcome to iPXE Deployment Service
    item

    item --gap --                           --- OS installation ---

    item --key w windows                    Install WINDOWS
    item --key l linux                      Install LINUX (RHEL, SUSE ...)
    item

    item --gap --                           --- Advanced options ---
    item --key c config                     show system information
    item --key s shell                      drop to iPXE shell
    item --key r reboot                     reboot system

    item
    item --key 0x08 exit                    Exit Service and continue boot

    choose --timeout ${menu-timeout} --default ${menu-default} selected || goto cancel
    goto ${selected}

    ###################### Defined Command ######################

    :config
    config
    goto main_menu

    :back
    goto main_menu

    :cancel
    echo You cancelled the menu, dropping to shell

    :shell
    echo Type 'exit', back to the main menu
    shell
    goto main_menu

    :failed
    echo Booting failed, drop to iPXE shell
    goto shell

    :reboot
    reboot

    :exit
    exit

    ############ MAIN MENU ITEMS ############

    :windows
    set net0/next-server 192.168.87.10
    set net0/filename boot\x64\wdsmgfw.efi
    chain ${tftp-boot-url}\x64\wdsmgfw.efi || goto failed

    :linux
    chain ${http-menu-url}/linux/menu.ipxe || goto failed

    ```


#### DHCP assign IP and bootfile for TFTP (using Windows DHCP)

Since DHCP settings are not the focus of this article, only screenshots and brief descriptions are provided.

Use Windows DHCP to set parameters such as TFTP 066 IP, 067 Bootfile name, 003 router, etc.

![](https://i.imgur.com/P2fPrzB.png =500x)

Also, you may notice that the Legacy policy has another policy set, because installing with WDS will give you the `Windows Deployment Services: PXE Boot Aborted.` error, as [this article](https://www.mail-archive.com/seabios@seabios.org/msg11892.html).

For how to fix the problem, just `disable NetBios over TCPIP, on the WDS server`, you can refer to [here](https://learn.microsoft.com/en-us/troubleshoot/windows-server/networking/disable-netbios-tcp-ip-using-dhcp) or [here](https://www.manageengine.com/vulnerability-management/misconfiguration/legacy-protocols/how-to-disable-netBios-over-tcp-ip.html), if you need.


#### Perform PXE Boot and check it works
![](https://i.imgur.com/P0HERsr.png =500x)


#### Finish up
![](https://i.imgur.com/lMeRq4T.png =500x)


### Reference article


> [Read-only TFTP with Dnsmasq](https://netbeez.net/blog/read-only-tftp-dnsmasq/)
> Here have How to set Dnsmasq as a TFTP server only
> 
> [Setup PXE Boot Server using cloud-init for Ubuntu 20.04 \[Step-by-Step\]](https://www.golinuxcloud.com/pxe-boot-server-cloud-init-ubuntu-20-04/)
> Here Why not using kickstart? and How to use cloud-init or auto-install?
> 
> [How to generate cloud-init user-data file for Ubuntu](https://www.golinuxcloud.com/generate-user-data-file-ubuntu-20-04/)
> Nice guy! you are expert！
> 
> :arrow_down: 
> [Build iPXE and make menu - 1](https://doc.rogerwhittaker.org.uk/ipxe-installation-and-EFI/)
> [Build iPXE and make menu - 2](https://gist.github.com/rikka0w0/50895b82cbec8a3a1e8c7707479824c1)
> [Build iPXE and make menu - 3](https://blog.open4j.com/2019/05/30/ipxe-build-embedded-script/)
