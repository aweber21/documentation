# Proxmox VE

This file contains all of the relevant information regarding Proxmox VE.

## Table Of Contents

1\. [Proxmox VE](#1-proxmox-ve)  
1.1\. [Features](#11-features)  
2\. [Pre-Installation](#2-pre-installation)  
2.1\. [Installation Image and Media](#21-installation-image-and-media)  
2.1.1\. [Acquire and Prepare Installation](#211-acquire-and-prepare-installation)  
2.1.2\. [Boot to Proxmox VE Installation Media](#212-boot-to-proxmox-ve-installation-media)  
3\. [Installation](#3-installation)  
3.1\. [Graphical Installer](#31-graphical-installer)  
3.2\. [OS Drive](#32-os-drive)  
3.3\. [Location, Time Zone, and Keyboard Layout](#33-location-time-zone-and-keyboard-layout)  
3.4\. [Administration Password and Email Address](#34-administration-password-and-email-address)  
3.5\. [Network Configuration](#35-network-configuration)  
3.6\. [Confirm and Install](#35-confirm-and-install)  
4\. [Post-Installation](#4-post-installation)  
4.1\. [Access Server Via Browser](#41-access-server-via-browser)  
4.2\. [Fix Repositories](#42-fix-repositories)  
4.3\. [Remove Warning](#43-remove-warning)  
4.4\. [Enable IOMMU](#44-enable-iommu)  
4.5\. [Update GRUB For UEFI](#45-update-grub-for-uefi)  
4.6\. [Reserve IP Address On Router](#46-reserve-ip-address-on-router)  
5\. [Web Interface](#5-web-interface)  
5.1\. [Cluster, Nodes, Networks, and Storage](#51-cluster-nodes-networks-and-storage)  

## 1. Proxmox VE

Proxmox Virtual Environment is a complete, open-source server management
platform for enterprise virtualization. It tightly integrates the KVM hypervisor
and Linux Containers (LXC), software-defined storage and networking
functionality, on a single platform. With the integrated web-based user
interface you can manage VMs and containers, high availabilty for clusters, or
the integrated disaster recovery tools with ease.

Visit "https://www.proxmox.com/en/products/proxmox-virtual-environment/overview"
for more information.

### 1.1. Features

- Server virtualization
- Central Management
- Clustering
- Authentication
- Proxmox VE High Availability (HA) Cluster
- Networking
- Flexible Storage Options
- Software-Defined Storage with Ceph
- Proxmox VE Firewall
- Backup/Restore
- Proxmox Backup Server Integration

## 2. Pre-Installation

This section highlights the prerequisites for installation of a new Proxmox VE
system.

Proxmox VE should run on an Intel 64 or AMD64 CPU with Intel VT/AMD-V CPU flag
with a minimum of 2GB RAM for the OS and Proxmox VE services. For PCI(e)
passthrough, a CPU with VT-d/AMD-d CPU flag is needed. A wired NIC, such as
ethernet, is ideal for serving a network.

### 2.1. Installation Image and Media

#### 2.1.1. Acquire and Prepare Installation

Go to "https://www.proxmox.com/en/downloads/proxmox-virtual-environment/iso" to
download a Proxmox VE image. The desired file will have the name:
"proxmox-ve_#.#-#.iso"

Download Rufus to write ISO to USB Drive. Select the Proxmox VE ISO and the USB
Drive while keeping all other settings as default. A warning will appear
acknowledging that the ISO is a ISOHybrid image, meaning DD image writing mode
will be enforced. Click start to install ISO to the USB Drive.

#### 2.1.2. Boot to Proxmox VE Installation Media

Insert the USB Drive with the Proxmox VE ISO installed into the system you want
to install Proxmox VE on. Go into BIOS and set the Proxmox VE USB Drive as the
primary boot device.

While in the BIOS, make sure to enable all virtualization settings necessary for
a server, such as VT-d for PCI(e) passthrough and AHCI for the SATA controller.
It may also be desired to allow "magic packets" to remotely wake up the server,
or to set whether the system will reboot on power loss.

## 3. Installation

This section highlights the installation process for a new Proxmox VE system
using the Proxmox VE Installation Media.

### 3.1. Graphical Installer

Once booted into the Proxmox VE Installation Media, select the option that says
"Install Proxmox VE (Graphical)" and wait for the graphical installation menu to
come back up after initial setup is ran. Click 'I agree' on the EULA page to
proceed to installation.

### 3.2. OS Drive

Select the 'Target Harddisk' or the drive to install the Proxmox VE OS
onto. It is recommended to at least have an SSD as the OS drive to make the
overall experience much faster. Clicking the 'Options' button will bring up a
menu for more granular control over the installation. The 'ext4' filesystem is
recommended for a singular drive but if there with be redundant OS drives then
the 'zfs' filesystem is recommended.

Click 'Next' to continue.

### 3.3. Location, Time Zone, and Keyboard Layout

Select the country, time zone, and keyboard layout for the Proxmox VE
installation.

Click 'Next' to continue.

### 3.4. Administration Password and Email Address

Enter the desired 'root' password for this Proxmox VE installation. Type the
password in again to confirm the correct entry. Then, provide an email address.
This email address can be used to send important alert information if desired.

Click 'Next' to continue.

### 3.5. Network Configuration

Select the Network Interface Card (NIC) to use for this installation. Some
systems may have multiple NICs, but more than likely the motherboard NIC is
what will be used.

Enter a hostname, or Fully Qualified Domain Name (FQDN). This will be in the
form 'hostname.domain.name'. For example, 'pve.server.com' will cause Proxmox
VE to have a hostname of 'pve' with a domain name of 'server.com'. The domain
name usually doesn't matter unless you're explicitly trying to use it. If you
don't want to use a domain name or don't have one, it's common practice to use
'hostname.internal' or 'hostname.lan' set the proper hostname and make the
domain either '.internal' or '.lan'.

Enter the IP address that you want to assign to the Proxmox VE system. Make
sure that this address is in the same subnet of you Local Area Network (LAN).

Enter the Default Gateway and the DNS Server that is used by your local network
to properly configure Proxmox VE to access the internet.

It is highly recommended to check 'Pin network interface names' and to use the
'Options' menu to name them if desired. This prevents Proxmox VE from causing
problems when NICs are assigned a new name on reboot. This check box keeps track
of NICs by known names to maintain stability.

Click 'Next' to continue.

### 3.6. Confirm and Install

Verify all information for the new Proxmox VE system is correct and make sure
the box to 'Automatically reboot after successful installation' is checked.

Click 'Install' to install the OS. When prompted, remove the Proxmox VE
installation media to prepare for boot into actual Proxmox VE installation.

## 4. Post-Installation

This section highlights the recommended post-installation steps for the new
Proxmox VE system to properly configure the server.

### 4.1. Access Server Via Browser

Navigate to the URL provided on the first boot to the Proxmox VE installation.
This URL is in the form of 'https://ip-address:8006/' and is used to access the
server from another device. The first time this URL is accessed, your browser
will most likely warn you that the connection is not private. This is expected.
Click 'Show Details' or something similar and click the link that will allow you
to 'Visit This Website'.

After navigating to the URL, login as 'root' with the root password you
configured during the installation. The realm set to 'Linux PAM standard
authentication' and language set to 'English - English' do not need to be
changed.

### 4.2. Fix Repositories

When you first log in to Proxmox VE via a web browser, you can see errors in the
task list at the bottom of the screen that say 'Update package database' is
throwing an error.

To fix this, click on the Proxmox VE system on the lefthand side menu to open
up details and options about it. Navigate to the 'Repositories' section under
'Updates'. Select an enterprise repository and click disable. Repeat for the
second enterprise repository. Then, add the 'No-Subscription' repository.

After the repositories are fixed, navigate up to the 'Updates' section and click
'Refresh' to run a `apt update` and update references to apt packages. Once that
completes, click 'Upgrade' to run a `apt upgrade` and upgrade all installed
packages. Reboot to finalize updates by selecting the system on the left and
clicking 'Reboot' in the top right.

### 4.3. Remove Warning

**NOTE**: Removing the subscription warning will break a few things in the web
GUI, such as 'Refresh' on the 'Updates' menu for a node.

When you log in to Proxmox VE via a web browser, a warning pops up saying that
there is 'No valid subscription'. The easiest way to fix this is to manually
edit a file located at
`/usr/share/javascript/proxmox-widget-toolkit/proxmoxlib.js` using Vim or Nano.

**NOTE**: Vim will need to be installed using `apt install vim` on the Proxmox
VE system before it can be used.

There are a few different ways to fix this, but essentially you want to avoid
executing 'Ext.Msg.show({' and instead run 'void({ //Ext.Msg.show({' (could
break things) or just 'orig_cmd()'. There are scripts online that do this for
you. Keep in mind, this will be reset after any update to the
proxmox-widget-toolkit. Afterwards, restart the pveproxy.service using
`systemctl restart pveproxy.service`.

### 4.4. Enable IOMMU

Input Output Memory Management Unit (IOMMU) should be enabled if you plan on
running virtual machines (VMs) that need direct hardware access, such as a GPU
pass-through. This can be enabled by editing the file `/etc/default/grub` at the
'GRUB_CMDLINE_LINUX_DEFAULT' line. In the quotes, add a space followed by
'intel_iommu=on' or 'amd_iommu=on' depending on your CPU hardware. After this is
added, save the file and run `update-grub` to confirm changes and reboot system
for them to take effect.

After rebooted, you can verify if the IOMMU is enabled using  `dmesg | grep -e
DMAR -e IOMMU` and `dmesg | grep 'remapping'`

### 4.5. Update GRUB For UEFI

In the Proxmox VE node's shell, run `cat /sys/firmware/efi/fw_platform_size`. If
this returns '64', it is necessary to install 'grub-efi-amd64' using
`apt install grub-efi-amd64`. After this completes, execute `update-grub` again
and also run `update-initramfs -u -k all` for good measure. Restart to take
effect.

### 4.6. Reserve IP Address On Router

Open your router settings and locate the new Proxmox VE installation and
reserve the same IP address that was specified during the installation process.

## 5. Web Interface

This section highlights the different sections of the Proxmox VE web interface.

### 5.1. Cluster, Nodes, Networks, and Storage

On the left side of the web interface, there is a tree containing Datacenters,
Nodes, Networks, and Storages.

A Cluster is a group of Proxmox VE nodes. In the web UI, you can see a tree on
the left side with the top level called 'Datacenter'. This "Datacenter" is
essentially your Proxmox VE cluster that contains all of your Proxmox VE nodes.

Under the datacenter, you can have multiple nodes. Nodes are another name for a
physical system. Each node can have networks and storages associated with them.

Networks are the interfaces and connections when communicating with other
devices.

Storages are essentially partitions for the node. By default, there is a
partition for ISOs, Container templates, and backups, as well as a partition for
running actual VMs and Containers. The second partition is an Logical Volume
Manager (LVM) which is a flexible, block-level storage management system that
allows multiple VMs and Containers to only use storage that is actively being
used and not what has been allocated to them.
