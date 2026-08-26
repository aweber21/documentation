# Homepage

This file contains all of the relevant information regarding Homepage.

## Table Of Contents

1\. [Homepage](#1-homepage)  
1.1\. [Features](#11-features)  
2\. [Pre-Installation](#2-pre-installation)  
2.1\. [Create Linux Container](#21-create-linux-container)  
2.2\. [Proxmox VE Helper Script](#22-proxmox-ve-helper-script)  
3\. [Installation](#3-installation)  
3.1\. [Update System](#31-update-system)  
3.2\. [Create Homepage Administrator](#32-create-homepage-administrator)  
3.2.1\. [Create New User](#321-create-new-user)  
3.2.2\. [Install and Configure Sudo](#322-install-and-configure-sudo)  
3.3\. [Install Docker](#33-install-docker)  
3.4\. [Install Homepage](#34-install-homepage)  
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

There exists a Proxmox VE Helper Script, if desired.

### 2.1. Installation Image and Media

#### 2.1.1. Acquire and Prepare Installation

The recommended operating system to run Frigate on is
'Debian 12 Bookworm (standard)'. Proxmox comes with a LXC Container Template
called 'debian-12-standard' and this is sufficient for the Homepage LXC.

If another image is desired, manually download it and upload it to Proxmox, or
download from URL through the Proxmox GUI.

### 2.2. Create Linux Container

Once the OS is acquired, click 'Create CT' in the top right corner to create
a Linux Container.  

**NOTE**: You may need to install the LXC Template ahead of time by navigating
to 'local' storage under the Proxmox VE Node and select 'Templates' under the
'CT Templates' section.

Use the following settings for the LXC while making sure 'Advanced' is checked
for every menu:

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

### 2.2. Proxmox VE Helper Script

**NOTE**: It is unsafe to run random bash scripts you find on the internet as
they can be harmful. Only run scripts that you are sure of and won't harm your
computer. It is generally good practice to make sure to understand what the bash
scripts are actually doing under the hood before running them.

Proxmox VE Helper Scripts have had mixed opinions since it encourages unsafe
practice, however most deem them to be safe and actually very helpful.

Navigate to 'community-scripts.org' to find a list of Proxmox VE Helper Scripts.
Search for "homepage" and click on the 'Homepage' LXC option. In the pop-up
screen under 'Install', you'll find a bash command that can be run in a Proxmox
VE node's shell to install a Homepage LXC container.

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

### 3. Installation

This section highlights the installation process for a new Homepage
installation.

**NOTE**: Some of these steps will likely have been completed for you if the
Proxmox VE Helper Script was used.

Begin by clicking 'Start' in the top right corner of the Frigate LXC page.
Navigate to the console and login using 'root' and the password provided when
creating the LXC.

### 3.1. Update System

Once booted into the Homepage LXC, run a standard `apt update && apt upgrade -y`
to update the container. This may take a few minutes to complete. After the
system upgrade is complete, reboot if prompted to.

### 3.2. Create Homepage Administrator

It is strongly recommended to run Homepage from a non-root account. This is good
practice to prevent irreversible commanding by accident, and to only use
elevated privileges when explicitly asking to.

**NOTE**: If you decide to make a Homepage administrator account, make sure to
log out of root and log in as the new account before proceeding to download
Docker. This is done by executing `logout` or pressing 'Ctrl-D' and logging in
as the new user.

#### 3.2.1. Create New User

Run the command `useradd -m homepage_admin` to create a new user with the name
"frigate_admin" and to create a home folder for this user.

Then, execute `passwd homepage_admin` to set a password for this user.

If you'd like, you can also set the default shell for this user by editing the
line in '/etc/passwd' that starts with the username. At the end of the line,
it'll point to the current shell to be used on login, likely '/bin/sh' by
default. Change this to '/bin/bash' to use bash, or just type `bash` after
logging in to enter the 'bash' shell.

#### 3.2.2. Install and Configure Sudo

Install `sudo` by executing `apt install sudo`. Wait for the installation to
complete.

Then, add the new user to the "sudo" group in order to execute commands with
elevated privileges. To do this, execute `usermod -aG sudo homepage_admin`.

If desired, you can enable "homepage_admin" to use passwordless `sudo`. This is
done by the following command:

`echo 'homepage_admin    ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/user`

### 3.3. Install Docker

**NOTE**: Log out of root and log in as the new user if one was created.

In order to install the Docker Engine, it is best to follow the official
documentation provided on the Docker website. This website is
'https://docs.docker.com/engine/install/debian/'. Specifically, follow the
section that is named "Install using the apt repository".

After installing Docker, follow the Linux post-installation steps for Docker
Engine at 'https://docs.docker.com/engine/install/linux-postinstall/'.

### 3.4. Install Homepage

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

### 4.3. Reserve IP Address On Router

Open your router settings and locate the new Homepage Linux Container and
reserve the desired IP address.

**NOTE**: Make sure to update /opt/homepage/.env with the newly reserved IP to
maintain access from other devices through that IP address.

## 5. Customization

This section highlights the customization of the Homepage service.
