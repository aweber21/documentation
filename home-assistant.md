# Home Assistant

This file contains all of the relevant information regarding Home Assistant.

## Table Of Contents

1\. [Home Assistant](#1-home-assistant)  
1.1\. [Features](#11-features)  
2\. [Pre-Installation](#2-pre-installation)  
2.1\. [Proxmox VE Helper Script](#21-proxmox-ve-helper-script)  
3\. [Installation](#3-installation)  
3.1\. [Install Script](#31-install-script)  
4\. [Post-Installation](#4-post-installation)  
4.1\. [Access Server Via Browser](#41-access-server-via-browser)  
4.2\. [Users](#42-users)  
4.3\. [Reserve IP Address On Router](#42-reserve-ip-address-on-router)  
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

### 2.1. Proxmox VE Helper Script

Navigate to 'community-scripts.org' to find a list of Proxmox VE Helper Scripts.
Search for "home assistant" and click on the 'Home Assistant OS' VM option. In
the pop-up screen under 'Install', you'll find a bash command that can be run in
a Proxmox VE node's shell to install a Home Assistant VM.

**NOTE**: It is unsafe to run random bash scripts you find on the internet as
they can be harmful. Only run scripts that you are sure of and won't harm your
computer. It is generally good practice to make sure to understand what the bash
scripts are actually doing under the hood before running them.

Proxmox VE Helper Scripts have had mixed opinions since it encourages unsafe
practice, however most deem them to be safe and actually very helpful.

### 3. Installation

This section highlights the installation process for a new Homepage
installation.

#### 3.1. Install Script

Navigate to the shell of the Proxmox VE node that you'd like to install a
Home Assistant VM onto. In the shell, run the Proxmox VE Helper Script that was
found above by pasting the command and clicking enter. This will open a terminal
user interface (TUI) to guide you through the installation.

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

### 4.3. QEMU Guest Agent

In order for the QEMU Guest Agent to work on Proxmox VE, you must install and
start "qemu-guest-agent" on the virtual machine.

Home Assistant comes with "qemu-guest-agent" preinstalled on the machine and should
automatically enable and start the service if Proxmox VE has enabled the QEMU
Guest Agent for the VM. If this is enabled after the VM is already started, it
is required to shutdown the machine completely and then turn it back on. A
reboot will not make enabling the QEMU Guest Agent take effect.

### 4.4. Reserve IP Address On Router

Open your router settings and locate the new Home Assistant virtual machine and
reserve the desired IP address.

## 5. Web Interface

This section highlights the different sections of the Home Assistant web
interface.
