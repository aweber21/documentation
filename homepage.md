# Homepage

This file contains all of the relevant information regarding Homepage.

## Table Of Contents

1\. [Homepage](#1-homepage)  
1.1\. [Features](#11-features)  
2\. [Pre-Installation](#2-pre-installation)  
2.1\. [Proxmox VE Helper Script](#21-proxmox-ve-helper-script)  
3\. [Installation](#3-installation)  
3.1\. [Install Script](#31-install-script)  
4\. [Post-Installation](#4-post-installation)  
4.1\. [Access Server Via Browser](#41-access-server-via-browser)  
4.2\. [Reserve IP Address On Router](#42-reserve-ip-address-on-router)  
5\. [Customization](#5-customization)  

## 1. Homepage

Homepage is a modern, fully static, fast, secure, fully proxied, highly
customizable application dashboard with integrations for over 100 services and
translations into multiple languages. It is easily configured via YAML files or
through docker label discovery.

### 1.1. Features

- Customizable
- Static and Fast
- Secure
- Service and Docker Integration
- Information and Utility Widgets

## 2. Pre-Installation

This section highlights the prerequisites for installation of a new Homepage
installation.

Homepage can run on Docker, Kubernetes, UNRAID, or built directly from source to
run in an Linux Containter (LXC) or on a bare metal operating system.

### 2.1. Proxmox VE Helper Script

Navigate to 'community-scripts.org' to find a list of Proxmox VE Helper Scripts.
Search for "homepage" and click on the 'Homepage' LXC option. In the pop-up
screen under 'Install', you'll find a bash command that can be run in a Proxmox
VE node's shell to install a Homepage LXC container.

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
Homepage LXC onto. In the shell, run the Proxmox VE Helper Script that was found
above by pasting the command and clicking enter. This will open a terminal user
interface (TUI) to guide you through the installation.

Use the following options for the install script:

<ins>Community-Scripts Options</ins>
Advanced Install

<ins>Container Type</ins>
1 Unprivileged (recommended)

<ins>Root Password</ins>
Insert desired root password

<ins>Container ID</ins>
136

<ins>Hostname</ins>
homepage

<ins>Disk Size</ins>
6 GB

<ins>CPU Cores</ins>
1

<ins>Ram</ins>
2048 MB (2 GB)

<ins>Network Bridge</ins>
vmbr0

<ins>IPv4 Configuration</ins>
dhcp Automatic (recommended)

**NOTE**: Make sure to reserve IP in router settings after installation

<ins>IPv6 Configuration</ins>
auto SLAAC/AUTO (recommended)

<ins>MTU Size</ins>
blank (default 1500)

<ins>DNS Search Domain</ins>
blank (use host setting)

<ins>DNS Server IP</ins>
blank (use host setting)

<ins>MAC Address</ins>
blank (auto-generated)

<ins>VLAN Tag</ins>
blank (no VLAN)

<ins>Container Tags</ins>
blank

<ins>SSH Key Source</ins>
none No keys

<ins>SSH Access</ins>
Yes

<ins>FUSE Support</ins>
Yes

<ins>TUN/TAP Support</ins>
Yes

<ins>Nesting Support</ins>
Yes

<ins>GPU Passthrough</ins>
No

<ins>APT Cacher Proxy</ins>
No

<ins>Container Timezone</ins>
America/Chicago

<ins>Container Protection</ins>
Yes

<ins>Device Node Creation</ins>
No

<ins>Mount Filesystems</ins>
blank (default none)

<ins>Post-Install Hook (Host)</ins>
blank (default skip)

<ins>Verbose Mode</ins>
Yes

<ins>Save these advanced settings as defaults for Homepage</ins>
Yes

Wait for the installation to complete and note the URL provided at the end.

## 4. Post-Installation

This section highlights the recommended post-installation steps for a new
Homepage installation.

### 4.1. Access Server Via Browser

Navigate to the URL provided after the completion of the installation script.
This URL is in the form of 'https://ip-address:3000/' and is used to access the
server from another device. The first time this URL is accessed, your browser
will most likely warn you that the connection is not private. This is expected.
Click 'Show Details' or something similar and click the link that will allow you
to 'Visit This Website'.

**NOTE**: If you are receiving a 'Host Validation Failed' error when trying to
acces the URL, this is due to access permissions for Homepage. To fix this, edit
/opt/homepage/.env in the Homepage LXC shell and enter the correct IP address
that others can access from on the network. It's important to note that this IP
address likely needs to be the same as what the router is assigning to Homepage.
So, if this is updated before reserving and IP address, then it'll need to be
updated again to match it afterwards. It's likely easier to reserve and IP
address first before doing this step.

### 4.2. Reserve IP Address On Router

Open your router settings and locate the new Homepage Linux Container and
reserve the desired IP address.

**NOTE**: Make sure to update /opt/homepage/.env with the newly reserved IP to
maintain access from other devices through that IP address.

## 5. Customization

This section highlights the customization of the Homepage service.
