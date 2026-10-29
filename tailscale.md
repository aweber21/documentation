# Tailscale

This file contains all of the relevant information regarding Tailscale.

## Table Of Contents

1\. [Tailscale](#1-tailscale)  
1.1\. [Features](#11-features)  
2\. [Pre-Installation](#2-pre-installation)  
2.1\. [Acquire and Prepare Image](#21-acquire-and-prepare-installation)  
2.2\. [Create Tailscale Account](#22-create-tailscale-account)  
3\. [Installation](#3-installation)  
3.1\. [Create Linux Container](#31-create-linux-container)  
3.1.1\. [TUN Device Passthrough](#311-tun-device-passthrough)  
3.2\. [Proxmox Helper Script](#32-proxmox-helper-script)  
4\. [Post-Installation](#4-post-installation)  
4.1\. [Debian Container Configuration](#debian-container-configuration)  
4.2\. [Install Tailscale](#42-install-tailscale)  
4.2.1\. [Disable Key Expiry](#421-disable-key-expiry)  
4.2.2\. [Configure Subnet Router](#422-configure-subnet-router)  
4.2.3\. [Configure Exit Node](#423-configure-exit-node)  
4.3\. [Reserve IP Address On Router](#44-reserve-ip-address-on-router)  
5\. [Customization](#5-customization)  

## 1. Tailscale

Tailscale is a Zero Trust identity-based connectivity platofrm that replaces
your legacy VPN, SASE, and PAM and connects remote teams, multi-cloud
environments, CI/CD pipelines, Edge & IoT devices, and AI workloads.

It is a secure networking solution that streamlines connecting devices
and services securely across different networks. It enables encrypted
point-to-point connections using the open source WireGuard protocol, which means
only devices on your private network can communicate with each other. Tailscale
creates a peer-to-peer mesh network (known as a tailnet). However, you can still
use Tailscale like a traditional VPN by routing all traffic through an exit
node.

### 1.1. Features

- Application Networking
- Continuous Monitoring
- Least Privilege Access
- Mobile Device Management
- Network Connectivity
- Posture Management
- Services Management
- User Management

## 2. Pre-Installation

This section highlights the prerequisites for installation of a new Tailscale
installation.

There are multiple ways to download, install, and update versions of the
Tailscale client.

This document will cover installation for an LXC on Proxmox.

There exists a Proxmox VE Helper Script, if desired.

### 2.1. Acquire and Prepare Image

Refer to [Linux Container Template](common-procedures.md#214-linux-container-template)
instructions to download a Debian LXC template.

### 2.2. Create Tailscale Account

Navigate to 'https://tailscale.com' and click the 'Login' button in the top
right. You need to sign in with another identity provider because Tailscale does
not support authentication themselves. Continue through the account creation
process.

Once you are logged in, navigate to the 'General' tab under 'Settings' to change
the display name for the tailnet. Also if desired, navigate to the 'Device
management' tab and turn on the 'Manually approve new devices' switch if you
want to explicitly approve new devices that try and join the tailnet. This is
more secure than allowing any device to join if provided the correct link.

### 3. Installation

This section highlights the installation process for a new Tailscale
installation.

**NOTE**: Some of these steps will likely have been completed for you if the
Proxmox VE Helper Script was used.

### 3.1. Create Linux Container

Refer to [Create Linux Container](common-procedures.md#create-linux-container)
instructions to create a Debian Linux Container.

Use the following specific settings for the LXC:

<ins>General</ins>
Node: pve01
CT ID: 103
Name: tailscale
Unprivileged container: yes
Provide a password

<ins>Template</ins>
Storage: local
Template: debian-13-standard template

<ins>Disks</ins>
Storage: local-lvm
Disk size (GiB): 16

<ins>CPU</ins>
Cores: 2

<ins>Memory</ins>
Memory (MiB): 2048
Swap (MiB): 2048

<ins>Network</ins>
IPv4: DHCP
IPv6: DHCP

<ins>DNS</ins>
Defaults

<ins>Confirm</ins>
Start after created: no

#### 3.1.1. TUN Device Passthrough

Navigate to the 'Resources' tab under the newly created LXC. Click 'Add' in the
top left to add a new 'Device Passthrough'. You must then add the TUN device
path that is located on the host Proxmox VE system. This device path should be
`/dev/net/tun`.

<ins>Add: Device</ins>
Device Path: /dev/net/tun

### 3.2. Proxmox Helper Script

Refer to [Proxmox Helper Scripts](common-procedures.md#33-proxmox-helper-scripts)
if desired instead.

## 4. Post-Installation

This section highlights the recommended post-installation steps for a new
Tailscale installation.

Begin by clicking 'Start' in the top right corner of the Tailscale LXC page.
Navigate to the console and login using 'root' and the password provided when
creating the LXC.

### 4.1. Debian Container Configuration

Refer to [Debian Container Configuration](common-procedures.md#41-debian-container-configuration)
to configure the Debian Linux Container.

Make sure to create a Tailscale Administrator account with the username of
"tailscale_admin".

### 4.2. Install Tailscale

In order to install Tailscale, it is best to follow the official documentation
provided at 'https://tailscale.com/docs/install/linux'. Specifically, follow the
section that is named "Mainstream distributions".

This section will tell you to run the command
`curl -fsSL https://tailscale.com/install.sh | sh` if the Linux distribution
contains a specified package manager. Debian uses the 'apt' package manager.

**NOTE**: You may need to install curl via `sudo apt install curl` to run the
installation command.

After the installation command is ran, run `sudo tailscale up` to display the
link to authenticate and add the device to the tailnet.

#### 4.2.1. Disable Key Expiry

In the tailnet console under the 'Machines' tab under the 'Network' ground, find
the device that was just added and select the three dots to the right of the
device. Select the 'Disable key expiry' button to prevent a relogin after a
specified amount of time. This should be done for devices that should always be
connected, like a server.

#### 4.2.2. Configure Subnet Router

In order to access devices on the local network of your LXC running Tailscale,
you must make the LXC a subnet router. To do this, you must enable IP forwarding
and advertise subnet routes.

Navigate to "https://tailscale.com/docs/features/subnet-routers" and follow the
instructions under the "Connect to Tailscale as a subnet router" section. Make
sure to advertise the correct subnet routes for other devices on the tailnet to
see. This is likely the same subnet as your local network. For example:

`sudo tailscale set --advertise-routes=10.0.0.0/24`

Navigate to the tailnet admin console and locate the device that is advertising
the subnet routes. Click on the device and click one of the 'Edit' buttons under
the "Subnets" section. Enable the correct subnet to advertise to the tailnet and
click 'Save'.

#### 4.2.3. Configure Exit Node

In order to route all network traffic through your LXC running Tailscale, you
must make the LXC an exit node. To do this, you must enable IP forwarding and
advertise exit node.

Navigate to "https://tailscale.com/docs/features/exit-nodes" and follow the
instructions under the "Configure an exit node" section. For example:

`sudo tailscale set --advertise-exit-node`

Navigate to the tailnet admin console and locate the device that is advertising
the exit node. Click on the device and click one of the 'Edit' buttons under the
"Routing Settings" section. Select the "Use as exit node" option to allow the
device to be used as an exit node and click 'Save'.

### 4.3. Reserve IP Address On Router

Refer to [Reserve IP Address On Router](common-procedures.md#43-reserve-ip-address-on-router)
reserve the desired IP address for the new Tailscale LXC.

## 5. Customization

This section highlights the customization of the Tailscale service.
