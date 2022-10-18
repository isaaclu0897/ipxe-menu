How to setup WDS as PXE Boot Server on Windows Server
===

[TOC]

Setup PXE Boot Server on Windows is easy. It can even help you manage OS images, etc. 

There are many articles on the Internet, and I am not going to do a long introduction.

Although Windows is much easier than Linux, it still has a lot of important points to pay attention to. I will write this article directly using the annotation method.

### How to setup WDS

:arrow_down: About How to setup WDS, you can refer to this article.
> [Windows Deployment Services PXE Boot Configuration](https://www.virtualizationhowto.com/2021/08/windows-deployment-services-pxe-boot-configuration/)
> There are differences between the configuration for BIOS and UEFI PXE boot. Some have noted more problems with UEFI boot. In my lab environment, I found a few settings that worked for me. These included adding options 66 and 67 to DHCP scope options. There are many posts that point to this no longer being recommended. Each environment may be different and your mileage may vary.

There are really some important points here, on my machine I need to do special setup using DHCP to get Legacy to UEFI compatible setup. But I haven't tried it in iPXE, maybe I can achieve the same effect without setting from DHCP. In my environment I set the IP and boot filename of the Linux iPXE Boot Server for Legacy and UEFI.
![](https://i.imgur.com/6Chdumf.png)

Since my main PXE Server is on Linux, if I need to install the Windows OS, I need to return the PXE permissions to the Windows PXE Boot Server, as follows to set the iPXE settings.
![](https://i.imgur.com/hO4Ims0.png)


### How to Setup iPXE Boot Server for Legacy and UEFI in Mircosoft DHCP

:arrow_down: About How to setup Mircosoft DHCP, you can refer to this article.
> [Installing and Configuring Windows Deployment Services for PXE Booting with Windows Server](
https://gal.vin/wds-pxe-booting-windows-server-walkthrough/#configuration-for-bios-and-uefi-clients)
> If you have a mixture of devices with both BIOS and UEFI firmware that you wish to PXE boot, some additional configuration may be required depending on the network and versions of DHCP and WDS.


If you also need to setup DHCP for PXE,
I strongly recommend you to watch [this video, which is a youtube](https://www.youtube.com/watch?v=k5E97ndlRog&list=WL&index=15)

But I think this is not enough for you. After watching this video, you will definitely want to know the parameters of DHCP. I will give it to you directly, no thanks. [Information from the wiki](https://wiki.fogproject.org/wiki/index.php/BIOS_and_UEFI_Co-Existence)
```
Type   Architecture Name
----   -----------------
 0    Intel x86PC
 1    NEC/PC98
 2    EFI Itanium
 3    DEC Alpha
 4    Arc x86
 5    Intel Lean Client
 6    EFI IA32
 7    EFI BC (EFI Byte Code)
 8    EFI Xscale
 9    EFI x86-64
 ```
 
### How to resolve `Windows Deployment Services: PXE Boot Aborted.` on Legacy

Also, you may notice that the Legacy policy has another policy set, because installing with WDS will give you the `Windows Deployment Services: PXE Boot Aborted.` error, as [this article](https://www.mail-archive.com/seabios@seabios.org/msg11892.html).
![](https://i.imgur.com/6Chdumf.png)
For how to fix the problem, just `disable NetBios over TCPIP, on the WDS server`, you can refer to [here](https://learn.microsoft.com/en-us/troubleshoot/windows-server/networking/disable-netbios-tcp-ip-using-dhcp) or [here](https://www.manageengine.com/vulnerability-management/misconfiguration/legacy-protocols/how-to-disable-netBios-over-tcp-ip.html), if you need.