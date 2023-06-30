# ipxe-menu
this is settings for ipxe menu


If you are interested in knowing the details of the implementation, you can refer to the doc directory.

Might help you understand how PXE works.

### Environment

Internal network: 192.168.87.0/24

IP: 192.168.87.8
OS: Ubuntu 22.04.1 LTS
Role: iPXE Boot Server (Apache2 + Dnsmasq + iPXE)

IP: 192.168.87.9
OS: Windows Server 2016
Role: OS image storage

IP: 192.168.87.10
OS: Windows Server 2016
Role: DHCP server

IP: 192.168.87.100-150
OS: N/A
Role: Client with DHCP IP