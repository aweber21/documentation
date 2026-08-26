# Home Assistant

This file contains all of the relevant information regarding Home Assistant.

## Table Of Contents

1\. [Home Assistant](#1-home-assistant)  
1.1\. [Features](#11-features)  
2\. [Pre-Installation](#2-pre-installation)  
2.1\. [Installation Image and Media](#21-installation-image-and-media)  
2.1.1\. [Acquire and Prepare Installation](#211-acquire-and-prepare-installation)  
2.2\. [Create Virtual Machine](#22-create-virtual-machine)  
2.3\. [Proxmox VE Helper Script](#23-proxmox-ve-helper-script)  
3\. [Installation](#3-installation)  
3.1\. [Add Image To Virtual Machine](#31-add-image-to-virtual-machine)  
4\. [Post-Installation](#4-post-installation)  
4.1\. [Access Server Via Browser](#41-access-server-via-browser)  
4.2\. [Users](#42-users)  
4.3\. [Reserve IP Address On Router](#43-reserve-ip-address-on-router)  
5\. [Web Interface](#5-web-interface)  

## 1. Home Assistant

Home Assistant is a free and open-source smart home platform that acts as a
centralized brain for connected devices. It allows you to monitor and automate
thousands of different brands and ecosystems form one dashboard without relying
on the cloud.

### 1.1. Features

- Automations
- Dashboards
- Apps
- Voice Assistant
- Compatibility

## 2. Pre-Installation

This section highlights the prerequisites for installation of a new Home
Assistant installation.

Home Assistant can run on any hardware or virtual machine as an operating system
or as a Docker container (with limitations).

### 2.1. Installation Image and Media

#### 2.1.1. Acquire and Prepare Installation

Navigate to 'http://www.home-assistant.io/installation/alternative' and find the
link to download the 'KVM/Proxmox (.qcow2)' image. Instead of downloading to the
PC, right click and copy the download's link address. Save it for use in a later
step.

### 2.2. Create Virtual Machine

Once the image link is found is complete, click 'Create VM' in the top right
corner to create a virtual machine. Use the following settings for the VM while
making sure 'Advanced' is checked for every menu:

<ins>General</ins>
Node: pve01
VM ID: 101
Name: homeassistant
Start at boot: yes

<ins>OS</ins>
Do not use any media

<ins>System</ins>
Machine: q35
BIOS: OVMF (UEFI)
EFI Storage: local-lvm
Pre-Enroll keys: no
Qemu Agent: yes

<ins>Disks</ins>
Delete the SCSI drive and any other disks

<ins>CPU</ins>
Cores: 2
Type: x86-64-v2-AES (default)

**NOTE**: Using 'Type: host' will have better performance, but sacrifices the
ability to move between multiple hosts if necessary. The performance boost is
negligible so portability is usually opted for.

<ins>Memory</ins>
Memory (MiB): 4096

**NOTE**: This is the ideal for Home Assistant to run (4GB), but it officially
supports a minimum of 2GB.

<ins>Network</ins>
Defaults

<ins>Confirm</ins>
Start after created: no

### 2.3. Proxmox VE Helper Script

**NOTE**: It is unsafe to run random bash scripts you find on the internet as
they can be harmful. Only run scripts that you are sure of and won't harm your
computer. It is generally good practice to make sure to understand what the bash
scripts are actually doing under the hood before running them.

Proxmox VE Helper Scripts have had mixed opinions since it encourages unsafe
practice, however most deem them to be safe and actually very helpful.

Navigate to 'community-scripts.org' to find a list of Proxmox VE Helper Scripts.
Search for "home assistant" and click on the 'Home Assistant OS' VM option. In
the pop-up screen under 'Install', you'll find a bash command that can be run in
a Proxmox VE node's shell to install a Home Assistant VM.

Use the following options for the install script:

<ins>Homeassistant OS VM</ins>
Yes

<ins>Settings</ins>
Advanced

<ins>Homeassistant OS Version</ins>
17.3 Stable

<ins>Container ID</ins>
101

<ins>Machine Type</ins>
q35 Modern (PCIe, UEFI, default)

<ins>Disk Size</ins>
32 GB

<ins>Disk Cache</ins>
Write Through (Default)

<ins>Hostname</ins>
homeassistant

<ins>CPU Model</ins>
KVM64 Default - safe for migration/compatibility

<ins>Core Count</ins>
2

<ins>Ram</ins>
2048 MB (2 GB)

<ins>Bridge</ins>
vmbr0

<ins>MAC Address</ins>
02:61:C0:1A:00:4D (default)

<ins>VLAN</ins>
blank (default)

<ins>MTU Size</ins>
blank (default)

<ins>Start Virtual Machine</ins>
Yes

<ins>Advanced Settings Complete</ins>
Yes

<ins>Image Cache</ins>
Yes

### 3. Installation

This section highlights the installation process for a new Home Assistant
installation.

#### 3.1. Add Image To Virtual Machine

Navigate to the shell of the Proxmox VE node that the Home Assistant virtual
machine was installed to. In the node's console, use the command
`wget link-to-qcow2-file` to download the image using the link acquired in a
previous step.

**NOTE**: Feel free to store the image in a dedicated image storage location on
the host if desired. For example, the 'local' storage 'Import' menu can be found
at '/var/lib/vz/import' so any images added there will appear in the Proxmox
GUI.

Once the file is downloaded, expand the compressed image using
`unxz /path/to/qcow2.xz` using the newly downloaded file.

**NOTE**: This may take a couple of minutes.

After the image is successfully downloaded and expanded, import the image from
the host to the virtual machine using
`qm importdisk vm-id /path/to/qcow2 efi-location`. For example,
`qm importdisk 101 haos_ova-18.2.qcow2 local-lvm`.

Once the image is imported to the virtual machine, navigate to the Home
Assistant VM's 'Hardware' tab. Select the 'Unused Disk' and click the 'Edit'
button. In the 'Add: Unused Disk' menu, enable 'Discard' if you're using an SSD.
Click 'Add' to add the disk.

Navigate to the VM's 'Options' tab. Select 'Boot Order' and click the 'Edit'
button. Check the newly created drive (scsi0) and unselect the rest.

Start the Home Assistant VM to complete installation.

**NOTE**: The manual process was described above. It is also possible to
download and expand the Home Assistant image and store it in
'/var/lib/vz/import'. This can then be used when creating the Home Assistant VM
on the 'Disks' page by removing all drives and pressing 'Import' in the bottom
left and proceeding to select the Home Assistant image for the 'scsi0' drive.

## 4. Post-Installation

This section highlights the recommended post-installation steps for a new
Home Assistant installation.

### 4.1. Access Server Via Browser

Navigate to the URL provided after the completion of the installation script.
This URL is in the form of 'https://homeassistant.local:8123/' and is used to
access the server from another device. The first time this URL is accessed,
your browser may warn you that the connection is not private. This is expected.
Click 'Show Details' or something similar and click the link that will allow you
to 'Visit This Website'.

After navigating to the URL, press 'Create my smart home' to continue with the
onboarding.

It will prompt you to create a user for this Home Assistant installation. It's
encouraged to create an admin account at this time and create a separate user
account in the future. This way the admin account is used to make changes and
the user account is there for actual functionality. This is personal preference
and can be done however you'd like.

For example, create a 'homeassistant_admin' account for updating integrations
and automations, and an account per user for utilization of Home Assistant.

Then, it'll prompt you to select your home location. This is used primarily for
setting the time zone, unit system, and currency but can also be used for
cloud-based integrations in the future. This also creates a "home zone" which
designates the area of your home with a default radius of 100 meters.

Lastly, it'll ask for what information you are willing to share with Home
Assistant. Sharing is disabled by default, but you can enable certain data to
share if desired.

Click finish to complete onboarding and show the default dashboard.

### 4.2. Users

Navigate to 'People' under 'Settings' when logged in as an administrator and add
the necessary users by clicking 'Add person' in the bottom right of the page.
Make sure to 'Allow login' by username and password to let that person login on
another device.

### 4.3. Reserve IP Address On Router

Open your router settings and locate the new Home Assistant virtual machine and
reserve the desired IP address.

## 5. Web Interface

This section highlights the different sections of the Home Assistant web
interface.
