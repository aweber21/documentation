# Homepage

This file contains all of the relevant information regarding Homepage.

## Table Of Contents

1\. [Homepage](#1-homepage)  
1.1\. [Features](#11-features)  
2\. [Pre-Installation](#2-pre-installation)  
2.1\. [Acquire and Prepare Image](#21-acquire-and-prepare-installation)  
3\. [Installation](#3-installation)  
3.1\. [Create Linux Container](#31-create-linux-container)  
3.2\. [Proxmox Helper Script](#32-proxmox-helper-script)  
4\. [Post-Installation](#4-post-installation)  
4.1\. [Debian Container Configuration](#debian-container-configuration)  
4.2\. [Install Homepage](#42-install-homepage)  
4.3\. [Access Server Via Browser](#43-access-server-via-browser)  
4.4\. [Reserve IP Address On Router](#44-reserve-ip-address-on-router)  
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

There exists a Proxmox VE Helper Script, if desired.

### 2.1. Acquire and Prepare Image

The recommended operating system to run Frigate on is
'Debian 12 Bookworm (standard)'. Proxmox comes with a LXC Container Template
called 'debian-12-standard' and this is sufficient for the Homepage LXC.

Refer to [Linux Container Template](common-procedures.md#214-linux-container-template)
instructions to download a Debian LXC template.

### 3. Installation

This section highlights the installation process for a new Homepage
installation.

**NOTE**: Some of these steps will likely have been completed for you if the
Proxmox VE Helper Script was used.

Begin by clicking 'Start' in the top right corner of the Frigate LXC page.
Navigate to the console and login using 'root' and the password provided when
creating the LXC.

### 3.1. Create Linux Container

Refer to [Create Linux Container](common-procedures.md#create-linux-container)
instructions to create a Debian Linux Container.

Use the following specific settings for the LXC:

<ins>General</ins>
Node: pve01
VM ID: 136
Name: homepage
Unprivileged container: yes
Provide a password

<ins>Template</ins>
Storage: local
Template: debian-13-standard template

<ins>Disks</ins>
Storage: local-lvm
Disk size (GiB): 16

<ins>CPU</ins>
Cores: 1

<ins>Memory</ins>
Memory (MiB): 2048
Swap (MiB): 2048

<ins>Network</ins>
IPv4: DHCP
IPv6: DHCP

<ins>DNS</ins>
Defaults

<ins>Confirm</ins>
Start after created: yes

### 3.2. Proxmox Helper Script

Refer to [Proxmox Helper Scripts](common-procedures.md#33-proxmox-helper-scripts)
if desired instead.

Use the following specific settings for the helper script:

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

## 4. Post-Installation

This section highlights the recommended post-installation steps for a new
Homepage installation.

### 4.1. Debian Container Configuration

Refer to [Debian Container Configuration](common-procedures.md#41-debian-container-configuration)
to configure the Debian Linux Container.

Make sure to create a Homepage Administrator account with the username of
"homepage_admin".

### 4.2. Install Homepage

When you first run Homepage, it creates the necessary directory structure for
you. However, if you want to do this manually, you will need to create a config
directory, storage directory, and a blank Docker Compose file using the command
`mkdir storage config && touch docker-compose.yml`.

This command needs to be executed within the folder that Homepage is to be
installed in. This can be anywhere on the system, like the "homepage_admin" home
folder for example, but it is cleaner to keep it in a generic system location,
like in a "/opt/homepage" directory.

**NOTE**: If you install Homepage to "/opt/homepage" or another location in the
filesystem that is owned by "root", it will make things easier to change the
owner of the directory to the "homepage_admin" user and the "homepage_admin"
group by executing the command
`sudo chown -R homepage_admin:homepage_admin /opt/homepage`.

Navigate to 'https://gethomepage.dev/installation/docker/' and copy the
initial Homepage Docker Compose contents from the 'Docker Installation' section
and paste it into the 'docker-compose.yml' that was just created. Modify it if
necessary.

Finally, run `docker compose up` to pull down the Homepage container image and
start it for the first time. Afterwards, you can stop the container with
`docker compose down` and start it as a daemon with `docker compose up -d` to
run it in the background.

### 4.3. Access Server Via Browser

Refer to [Access Server Via Browser](common-procedures.md#42-access-server-via-browser)
to access the server.

The URL will be: http, the node's IP address, and a default port of 3000.

**NOTE**: If you are receiving a 'Host Validation Failed' error when trying to
acces the URL, this is due to access permissions for Homepage. To fix this, edit
or create if it doesn't exist, the file '/opt/homepage/.env' to create
environment variables. Add the line `HOMEPAGE_ALLOWED_HOSTS=ip-address:3000` and
fill in the IP address of the Homepage LXC. Then, back in the
'docker-compose.yml' file, replace the 'HOMEPAGE_ALLOWED_HOSTS: gethomepage.dev'
line with 'HOMEPAGE_ALLOWED_HOSTS: ${HOMEPAGE_ALLOWED_HOSTS}'.

**NOTE**: It's important to note that this IP address likely needs to be the
same as what the router is assigning to Homepage. So, if this is updated before
reserving and IP address, then it'll need to be updated again to match it
afterwards. It's likely easier to reserve and IP address first before doing this
step.

### 4.4. Reserve IP Address On Router

Refer to [Reserve IP Address On Router](common-procedures.md#43-reserve-ip-address-on-router)
reserve the desired IP address for the new Homepage LXC.

**NOTE**: Make sure to update /opt/homepage/.env with the newly reserved IP to
maintain access from other devices through that IP address.

## 5. Customization

This section highlights the customization of the Homepage service.
