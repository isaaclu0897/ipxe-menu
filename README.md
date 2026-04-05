A practical PXE/iPXE deployment project for multi-OS network booting, including custom boot menus, autoinstall configurations (Kickstart/AutoYaST), and supporting automation scripts.

# TOC
- [Key Features](#key-features)
- [Documentation](#documentation)
- [Preview](#preview)
  - [PXE Boot Process](#pxe-boot-process)
  - [iPXE Menu (Multi-OS Selection)](#ipxe-menu-multi-os-selection)
- [Quick Start](#quick-start)
- [Environment](#environment)

## Key Features

- End-to-end PXE/iPXE workflow integrating DHCP, TFTP, and HTTP services
- Multi-OS network boot with custom iPXE menu (Linux / Windows, Legacy / UEFI)
- Automated OS provisioning via Kickstart and AutoYaST


## Documentation
This repository contains step-by-step guides based on real-world hands-on experience in building PXE/iPXE environments.
Each document is based on a real-world lab setup, covering practical configurations, and working solutions for deploying multiple OSes via network boot.

- [How to setup iPXE Boot Server on Ubuntu](./doc/How%20to%20setup%20iPXE%20Boot%20Server%20on%20Ubuntu.md)
- [How to setup iPXE with isc-dhcp-server](./doc/How%20to%20setup%20iPXE%20with%20isc-dhcp-server.md)
- [How to setup WDS as PXE Boot Server on Windows Server](./doc/How%20to%20setup%20WDS%20as%20PXE%20Boot%20Server%20on%20Windows%20Server.md)

## Preview

### PXE Boot Process
PXE boot sequence loading iPXE from network.

<img src="https://i.imgur.com/P0HERsr.png" width="400">

### iPXE Menu (Multi-OS Selection)
<img src="https://i.imgur.com/lMeRq4T.png" width="400"> <img src="https://i.imgur.com/jEeb8Na.png" width="420">


## Quick Start

Pre-built iPXE binaries are available in [`bin/`](./bin/) — you can use them directly without compiling:

| File | Use case |
|------|----------|
| `ipxe.efi` | UEFI PXE boot |
| `snponly.efi` | UEFI (SNP-only, for specific NIC compatibility)) |
| `undionly.kpxe` | Legacy BIOS PXE boot |
| `ipxe.pxe` | Legacy BIOS (full-featured iPXE) |

## Environment

| IP | OS | Role |
|----|----|------|
| 192.168.87.8 | Ubuntu 22.04.1 LTS | iPXE Boot Server (Apache2 + Dnsmasq + iPXE) |
| 192.168.87.9 | Windows Server 2016 | OS image storage |
| 192.168.87.10 | Windows Server 2016 | DHCP server |
| 192.168.87.100-150 | — | DHCP Clients |

Network: `192.168.87.0/24`

This setup demonstrates a typical PXE/iPXE deployment architecture in a controlled lab environment.
