# Home Assistant

This file contains all of the relevant information regarding Home Assistant.

## Table Of Contents

1\. [Home Assistant](#1-home-assistant)  
1.1\. [Features](#11-features)  
2\. [Pre-Installation](#2-pre-installation)  
2.1\. [Acquire and Prepare Image](#21-acquire-and-prepare-image)  
3\. [Installation](#3-installation)  
3.1\. [Create Virtual Machine](#31-create-virtual-machine)  
3.2\. [Proxmox Helper Script](#32-proxmox-helper-script)  
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

### 2.1. Acquire and Prepare Image

Refer to [Virtualized Image](common-procedures.md#212-virtualized-iso) instructions for acquiring
and preparing the Home Assistant image.

### 3. Installation

This section highlights the installation process for a new Home Assistant
installation.

### 3.1. Create Virtual Machine

Refer to [Create Virtual Machine](common-procedures.md#31-create-virtual-machine) instructions to
create a Home Assistant virtual machine.

Use the following specific settings for the VM:

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
Import Home Assistant image and assign it to 'scsi0'

<ins>CPU</ins>
Cores: 2
Type: x86-64-v2-AES (default)

<ins>Memory</ins>
Memory (MiB): 4096

**NOTE**: This is the ideal for Home Assistant to run (4GB), but it officially
supports a minimum of 2GB.

<ins>Network</ins>
Defaults

<ins>Confirm</ins>
Start after created: no

### 3.2. Proxmox Helper Script

Refer to [Proxmox Helper Scripts](common-procedures.md#33-proxmox-helper-scripts)
if desired instead.

Use the following specific settings for the helper script:

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

## 4. Post-Installation

This section highlights the recommended post-installation steps for a new
Home Assistant installation.

### 4.1. Access Server Via Browser

Refer to [Access Server Via Browser](common-procedures.md#42-access-server-via-browser)
to access the server.

The URL will be: http, the node's IP address, and a default port of 8123.

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

Refer to [Reserve IP Address On Router](common-procedures.md#43-reserve-ip-address-on-router)
reserve the desired IP address for the new Home Assistant virtual machine.

## 5. Web Interface

This section highlights the different sections of the Home Assistant web
interface.
