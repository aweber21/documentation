# Common Procedures

This file contains all of the relevant information regarding common procedures.

## Table Of Contents

1\. [Common Procedures](#1-common-procedures)  
2\. [Pre-Installation](#2-pre-installation)  
2.1\. [Acquire and Prepare Image](#21-acquire-and-prepare-installation)  
2.1.1\. [Bare Metal Image](#211-bare-metal-iso)  
2.1.2\. [Virtualized Image](#212-virtualized-iso)  
2.1.3\. [Disk Image](#213-disk-image)  
2.1.4\. [Linux Container Template](#214-linux-container-template)  
3\. [Installation](#3-installation)  
3.1\. [Create Virtual Machine](#31-create-virtual-machine)  
3.2\. [Create Linux Container](#32-create-linux-container)  
3.3\. [Proxmox Helper Scripts](#33-proxmox-helper-scripts)  
4\. [Post-Installation](#4-post-installation)  
4.1\. [Debian Container Configuration](#41-debian-container-configuration)  
4.1.1\. [Update System](#411-update-system)  
4.1.2\. [Create New User](#412-create-new-user)  
4.1.2.1\. [Install And Configure Sudo](#4121-install-and-configure-sudo)  
4.1.3\. [Install Docker](#413-install-docker)  
4.2\. [Access Server Via Browser](#42-access-server-via-browser)  
4.3\. [Reserve IP Address On Router](#43-reserve-ip-address-on-router)  

## 1. Common Procedures

When it comes to the installation or configuration of systems, services, Linux
Containers (LXC), Virtual Machines (VM), operating systems, etc., there are many
steps that are common amongst a few of these processes, or are used repeatedly
when executing the above processes. This file is meant to pull all of the
non-specific procedures into one location to reference as needed.

## 2. Pre-Installation

This section highlights the common procedures that occur prior to installation.

### 2.1. Acquire and Prepare Image

An image can be in the form of an '.iso', '.img', '.qcow2', etc. These can be
found on their respective websites and can be directly downloaded and saved
somewhere.

**NOTE**: It may take a bit of time to download these images because they are
usually a larger file size.

#### 2.1.1. Bare Metal Image

Navigate to the respective website to find the desired image file.
Download it and store it in a known location.

On Windows, download Rufus to write the ISO to a USB drive that is already
inserted into the PC. Keep all settings as default. Balena Etcher is another
application that will work as well. Eject the USB drive when completed.

On Linux, use the `dd` command with the ISO as the input file and the USB drive
as the output file with a block size of 4 megabytes. You can find the USB drive
with the `lsblk` command if needed. Remove the USB drive when completed.
For example: `dd if=image-file of=/dev/sdb bs=4M`

After the ISO is written to the USB drive and removed from the PC, insert it
into the system you'd like to install the image on. Turn on the system and boot
into the BIOS. Select the USB drive as the boot device and continue booting like
normal.

Follow the necessary installation instructions for the booted image.

#### 2.1.2. Virtualized Image

Navigate to the respective website to find the desired image file.
Either download the file and store it in a known location, or right click on the
download button and copy the download's link address.

Navigate to the Proxmox VE host that will contain the virtualized system that
will use this image. Find the local storage where ISO images can be downloaded
and stored. This is usually found under 'Datacenter > Node > local' under the
'ISO Images' menu.

If the image was downloaded, select 'Upload' and upload the image.
If the download's link address was copied, select 'Download from URL' and 'Query
URL' to verify its contents.

#### 2.1.3. Disk Image

Navigate to the respective website to find the desired image file.
Either download the file and store it in a known location, or right click on the
download button and copy the download's link address.

Navigate to the Proxmox VE host that will contain the virtualized system that
will use this image. Find the local storage where ISO images can be downloaded
and stored. This is usually found under 'Datacenter > Node > local' under the
'Import' menu.

If the image was downloaded, select 'Upload' and upload the image.
If the download's link address was copied, select 'Download from URL' and 'Query
URL' to verify its contents.

**NOTE**: You can also do this manually from the Proxmox node's shell. Enter the
shell and navigate to an installation location for the image.
Use the following commands to download the image and extract it if required:
`wget link-to-image`
`unxz /path/to/image`
If the location used is '/var/lib/vz/import' then the image will appear in the
same menu as described above.

#### 2.1.4. Linux Container Template

Navigate to 'local' storage under the Proxmox VE Node and select 'Templates'
under the 'CT Templates' section. Select the desired template and download it.

## 3. Installation

This section highlights the common procedures that occur during creation of a
new system.

### 3.1. Create Virtual Machine

Click 'Create VM' in the top right corner of the Proxmox VE Web GUI to create a
virtual machine. Use the following default settings for the VM while making sure
'Advanced' is checked for every menu and modifying as needed for the specific
system:

**NOTE**: If an option is not given here, assume it is the defaults that are
provided.

<ins>General</ins>
Node: _PVE Node Name_ (the name of the PVE node the VM is being installed on)
VM ID: _###_ (usually the same as the last digits of the IP address)
Name: _VM Hostname_ (can be anything but should match VM hostname for consistency)
Start at boot: yes

<ins>OS</ins>
Use CD/DVD disk image file (iso)
    Storage: local
    ISO image: _Desired Image_

<ins>System</ins>
Qemu Agent: yes

<ins>Disks</ins>
Defaults

<ins>CPU</ins>
Cores: 2
Type: x86-64-v2-AES (default)

**NOTE**: Using 'Type: host' will have better performance, but sacrifices the
ability to move between multiple hosts if necessary. The performance boost is
negligible so portability is usually opted for.

<ins>Memory</ins>
Memory (MiB): 4096

<ins>Network</ins>
Defaults

<ins>Confirm</ins>
Start after created: _Optional_

### 3.2. Create Linux Container

Click 'Create CT' in the top right corner of the Proxmox VE Web GUI to create a
Linux Container. Use the following default settings for the LXC while making
sure 'Advanced' is checked for every menu and modifying as needed for the
specific system:

**NOTE**: If an option is not given here, assume it is the defaults that are
provided.

<ins>General</ins>
Node: _PVE Node Name_ (the name of the PVE node the LXC is being installed on)
VM ID: _###_ (usually the same as the last digits of the IP address)
Name: _LXC Hostname_ (this will be the LXC's hostname)
Unprivileged container: yes
Provide a password (this will be the root user's password)

<ins>Template</ins>
Storage: local
Template: _Desired Template_

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

**NOTE**: You can assign static IP addresses if desired, but either way you
should rely solely on IP reservations to assign the correct IP addresses to
LXCs.

<ins>DNS</ins>
Defaults

<ins>Confirm</ins>
Start after created: _Optional_

### 3.3. Proxmox Helper Scripts

Proxmox VE Helper Scripts have had mixed opinions since it encourages unsafe
practice, however most deem them to be safe and actually very helpful.

**NOTE**: It is unsafe to run random bash scripts you find on the internet as
they can be harmful. Only run scripts that you are sure of and won't harm your
computer. It is generally good practice to make sure to understand what the bash
scripts are actually doing under the hood before running them.

Navigate to 'community-scripts.org' to find a list of Proxmox VE Helper Scripts.
Search for the application and click on the desired installation option. In the
pop-up screen under 'Install', you'll find a bash command that can be run in a
Proxmox VE node's shell to install the application. Each script will have
different installation options, so use the settings for VMs and LXCs above as a
guide.

## 4. Post-Installation

This section highlights the common procedures that occur after creation of a new
system.

### 4.1. Debian Container Configuration

This section highlights the common procedures that occur after creating a Debian
Linux Container (LXC).

#### 4.1.1. Update System

Once booted into the Debian LXC, run a standard `apt update && apt upgrade -y`
to update the container. This may take a few minutes to complete. After the
system upgrade is complete, reboot if prompted to.

#### 4.1.2. Create New User

It is strongly recommended to use Debian from a non-root account. This is good
practice to prevent irreversible commanding by accident, and to only use
elevated privileges when explicitly asking to. This can be used as the admin
account for the system.

Run the command `useradd -m debian_admin` to create a new user with the name
"debian_admin" and to create a home folder for this user.

Then, execute `passwd debian_admin` to set a password for this user.

If you'd like, you can also set the default shell for this user by editing the
line in '/etc/passwd' that starts with the username. At the end of the line,
it'll point to the current shell to be used on login, likely '/bin/sh' by
default. Change this to '/bin/bash' to use bash, or just type `bash` after
logging in to enter the 'bash' shell.

##### 4.1.2.1. Install And Configure Sudo

Install `sudo` by executing `apt install sudo`. Wait for the installation to
complete.

Then, add the new user to the "sudo" group in order to execute commands with
elevated privileges. To do this, execute `usermod -aG sudo debian_admin`.

If desired, you can enable "debian_admin" to use passwordless `sudo`. This is
done by the following command:

`echo 'debian_admin    ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/user`

#### 4.1.3. Install Docker

**NOTE**: Log out of root and log in as the new user if one was created.

In order to install the Docker Engine, it is best to follow the official
documentation provided on the Docker website. This website is
'https://docs.docker.com/engine/install/debian/'. Specifically, follow the
section that is named "Install using the apt repository".

After installing Docker, follow the Linux post-installation steps for Docker
Engine at 'https://docs.docker.com/engine/install/linux-postinstall/'.

### 4.2. Access Server Via Browser

Navigate to the application's URL to access the Web GUI from another device. The
URL is usually in the form: '{http,https}://{ip-address}][:port]/'

Occasionally when the URL is accessed, your browser might warn you that the
conection is not private. This is expected. Click 'Show Details' or something
similar and click the link that will allow you to 'Visit This Website'.

### 4.3. Reserve IP Address On Router

Open your router settings and locate the new system and reserve the desired IP
address.
