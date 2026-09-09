# Frigate

This file contains all of the relevant information regarding Frigate.

## Table Of Contents

1\. [Frigate](#1-frigate)  
1.1\. [Features](#11-features)  
2\. [Pre-Installation](#2-pre-installation)  
2.1\. [Installation Image and Media](#21-installation-image-and-media)  
2.2\. [Create Linux Container](#22-create-linux-container)  
2.2.1\. [Media Mount Point](#221-media-mount-point)  
2.2.2\. [Hardware Acceleration Passthrough](#222-hardware-acceleration-passthrough)  
3\. [Installation](#3-installation)  
3.1\. [Update System](#31-update-system)  
3.2\. [Create Frigate Administrator](#32-create-frigate-administrator)  
3.2.1\. [Create New User](#321-create-new-user)  
3.2.2\. [Install and Configure Sudo](#322-install-and-configure-sudo)  
3.3\. [Install Docker](#33-install-docker)  
3.4\. [Install Frigate](#34-install-frigate)  
4\. [Post-Installation](#4-post-installation)  
4.1\. [Access Server Via Browser](#41-access-server-via-browser)  
4.2\. [Create Ethernet Bridge For Local Camera Network](#42-create-ethernet-bridge-for-local-camera-network)  
4.3\. [Configure NTP On Proxmox Host](#43-configure-ntp-on-proxmox-host)  
4.4\. [Update Shared Memory](#44-update-shared-memory)  
4.5\. [Users](#45-users)  
4.?\. [Reserve IP Address On Router](#45-reserve-ip-address-on-router)  
5\. [Web Interface and Configuration](#5-web-interface-and-configuration)  

## 1. Frigate

Frigate is an open source NVR build around real-time AI object detection. All
processing is performed locally on your own hardware, and your camera feeds
never leave your home.

It is a complete and local NVR designed for Home Assitant with AI object
detection. It uses OpenCV and Tensorflow to perform realtime object detection
locally for IP cameras.

Visit "https://frigate.video" for more information.

### 1.1. Features

- Local Object Detection
- Detection Review
- Fine Tune Events and Alerts with Zones
- Home Assistant Integration

## 2. Pre-Installation

This section highlights the prerequisites for installation of a new Frigate
installation.

Frigate is primarily designed to run in a Docker container on bare metal. Many
have also found success in running Frigate in a Docker container in a Proxmox
Virtual Machine or Linux Container (LXC). This document will cover installation
for an LXC on Proxmox.

There exists a Proxmox VE Helper Script, but it is not recommended because it is
highly resistant to updates and prevents upgrading to a newer version in the
future.

### 2.1. Installation Image and Media

#### 2.1.1. Acquire and Prepare Installation

The recommended operating system to run Frigate on is
'Debian 12 Bookworm (standard)'. Proxmox comes with a LXC Container Template
called 'debian-12-standard' and this is sufficient for the Frigate LXC.

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
Node: pve02
VM ID: 100
Name: frigate
Unprivileged container: yes
Provide a password

<ins>Template</ins>
Storage: local
Template: debian-13-standard template

**NOTE**: Frigate officially supports Debian 12, but Docker containers
should be OS agnostic as long as it has a working kernel.

<ins>Disks</ins>
Storage: local-lvm
Disk size (GiB): 32

**NOTE**: This is just for the LXC filesystem. The storage allocation for
recordings will be stored in a mount point added later on. If desired, you can
avoid using a mount point for storage and directly increase this storage
allocation for storing Frigate media. The reason a mount point will be used is
to work better with Proxmox Backup Server.

<ins>CPU</ins>
Cores: 4

<ins>Memory</ins>
Memory (MiB): 4096
Swap (MiB): 4096

<ins>Network</ins>
IPv4: DHCP
IPv6: DHCP

**NOTE**: Use DHCP IP Reservations for main Ethernet interface but use static IP
for Ethernet interface connecting to cameras.

<ins>DNS</ins>
Defaults

<ins>Confirm</ins>
Start after created: no

#### 2.2.1. Media Mount Point

At this point, it is good to start thinking about where Frigate will be
installed in the LXC filesystem. Typically, it's good to keep it generic by
installing in '/opt/frigate', and this documentation will assume that. However,
you can install Frigate anywhere, and this mount point will need to be updated
accordingly. The mount point location can be modified later.

**NOTE**: This section is optional. It is possible to instead increase the LXC
filesystem allocation to store Frigate media.

The mount point that you are specifying here is a logically separate piece of
storage that will house all of Frigate's media like recordings and snapshots of
events. The reason for mounting a separate mount point like this is to easily
separate this from the actual configuration of Frigate, especially when
utilizing Proxmox Backup Server.

Navigate to the 'Resources' tab under the newly created LXC. Click 'Add' in the
top left to add a new 'Mount Point'. Use the following settings:

<ins>Create: Mount Point</ins>
Storage: local-lvm
Disk size (GiB): 300
Path: /opt/frigate/storage
Backup: no

**NOTE**: This is only for the Frigate media and does not include any of the LXC
filesystem. The path can be set to anything as long as you update the Frigate
configuration to map to it later on.

**NOTE**: This will create a 'lost+found' directory in this location. This is
created by the filesystem and not needed by the LXC. By default, only the 'root'
user on the Proxmox host will have access to this directory anyway, not even the
'root' on the LXC is given access to this folder. It is safe to ignore it.

#### 2.2.2. Hardware Acceleration Passthrough

It is highly recommended to use hardware acceleration for processing images and
videos in Frigate. This can be done using integrated graphics, a dedicated
graphics card, a dedicated TPU, or anything that can be used for processing.

Whichever hardware you decide to use, you need to pass-through that device to
the new LXC.

Navigate to the 'Resources' tab under the newly created LXC. Click 'Add' in the
top left to add a new 'Device Passthrough'. You must then add the device path
that is located on the host Proxmox VE system.

For an Intel iGPU to use with OpenVINO, it is required to pass-through the
device `/dev/dri/renderD128`. This device should be found in `/dev/dri` on the
host system and can be confirmed by entering a shell and running the command
`ls /dev/dri` to make sure it appears.

<ins>Add: Device</ins>
Device Path: /dev/dri/renderD128

## 3. Installation

This section highlights the installation process for a new Frigate system using
a Proxmox VE Linux Container.

Begin by clicking 'Start' in the top right corner of the Frigate LXC page.
Navigate to the console and login using 'root' and the password provided when
creating the LXC.

### 3.1. Update System

Once booted into the Frigate LXC, run a standard `apt update && apt upgrade -y`
to update the container. This may take a few minutes to complete. After the
system upgrade is complete, reboot if prompted to.

### 3.2. Create Frigate Administrator

It is strongly recommended to run Frigate from a non-root account. This is good
practice to prevent irreversible commanding by accident, and to only use
elevated privileges when explicitly asking to.

**NOTE**: If you decide to make a Frigate administrator account, make sure to
log out of root and log in as the new account before proceeding to download
Docker. This is done by executing `logout` or pressing 'Ctrl-D' and logging in
as the new user.

#### 3.2.1. Create New User

Run the command `useradd -m frigate_admin` to create a new user with the name
"frigate_admin" and to create a home folder for this user.

Then, execute `passwd frigate_admin` to set a password for this user.

If you'd like, you can also set the default shell for this user by editing the
line in '/etc/passwd' that starts with the username. At the end of the line,
it'll point to the current shell to be used on login, likely '/bin/sh' by
default. Change this to '/bin/bash' to use bash, or just type `bash` after
logging in to enter the 'bash' shell.

#### 3.2.2. Install and Configure Sudo

Install `sudo` by executing `apt install sudo`. Wait for the installation to
complete.

Then, add the new user to the "sudo" group in order to execute commands with
elevated privileges. To do this, execute `usermod -aG sudo frigate_admin`.

If desired, you can enable "frigate_admin" to use passwordless `sudo`. This is
done by the following command:

`echo 'frigate_admin    ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/user`

### 3.3. Install Docker

**NOTE**: Log out of root and log in as the new user if one was created.

In order to install the Docker Engine, it is best to follow the official
documentation provided on the Docker website. This website is
'https://docs.docker.com/engine/install/debian/'. Specifically, follow the
section that is named "Install using the apt repository".

After installing Docker, follow the Linux post-installation steps for Docker
Engine at 'https://docs.docker.com/engine/install/linux-postinstall/'.

### 3.4. Install Frigate

When you first run Frigate, it creates the necessary directory structure for
you. However, if you want to do this manually, you will need to create a config
directory, storage directory, and a blank Docker Compose file using the command
`mkdir storage config && touch docker-compose.yml`.

**NOTE**: If you added a mount point earlier on, you can omit 'storage' in the
command above, but keeping it in shouldn't make a difference.

This command needs to be executed within the folder that Frigate is to be
installed in. This can be anywhere on the system, like the "frigate_admin" home
folder for example, but it is cleaner to keep it in a generic system location,
like in a "/opt/frigate" directory.

**NOTE**: If you install Frigate to "/opt/frigate" or another location in the
filesystem that is owned by "root", it will make things easier to change the
owner of the directory to the "frigate_admin" user and the "frigate_admin" group
by executing the command
`sudo chown -R frigate_admin:frigate_admin /opt/frigate`. If a mount point was
added, this will present with an error about permission to the 'lost+found'
directory is denied. This can be ignored.

Navigate to 'https://docs.frigate.video/guides/getting_started/' and copy the
initial Frigate Docker Compose contents from the 'Setup directories' section and
paste it into the 'docker-compose.yml' that was just created. Modify it if
necessary.

Finally, run `docker compose up` to pull down the Frigate container image and
start it for the first time. Afterwards, you can stop the container with
`docker compose down` and start it as a daemon with `docker compose up -d` to
run it in the background.

**NOTE**: Frigate says to run `docker compose up -d` to run the container as a
daemon, but for the first time it is helpful to have it run in the foreground to
visualize what is happening during the initial setup.

It is necessary to retrieve the username and password for the first login from
the Frigate Docker logs. If ran in the foreground, you can find it on the screen
at some point in the installation process. If ran in the background/as a daemon,
you can run `docker logs frigate` to find it also.

## 4. Post-Installation

This section highlights the recommended post-installation steps for the new
Frigate system.

### 4.1. Access Server Via Browser

Navigate to the URL provided on the first boot to the Proxmox VE installation.
This URL is in the form of 'https://ip-address:8971/' and is used to access the
server from another device. The first time this URL is accessed, your browser
will most likely warn you that the connection is not private. This is expected.
Click 'Show Details' or something similar and click the link that will allow you
to 'Visit This Website'.

After navigating to the URL, login as 'admin' with the admin password recorded
from the logs during the installation. Immediately while the temporary password
is still in your clipboard, in the bottom left corner click the person icon and
select 'Set Password' to change the admin password.

### 4.2. Create Ethernet Bridge For Local Camera Network

If you are connecting your cameras to the Proxmox VE host via a local switch
network on a different Ethernet port, it is necessary to add another network
device to the Frigate LXC.

First, you must map another Linux Bridge to the new Ethernet port network
device. This can be done by navigating to the 'Network' section under the
Proxmox VE node's 'System' menu. In this menu, you should see a list of all of
the network devices connected to the Proxmox host, as well as any bridges,
bonds, or VLANs created within Proxmox.

**NOTE**: If the network device has a random name/hasn't been pinned yet, go
into the node's shell and execute `pve-network-interface-pinning generate`. This
will generate the ".link" files for all physical network interfaces and stores
them in `/usr/local/lib/systemd/network`. After rebooting, the network devices
should be pinned and configured with a more standardized name, usually beginning
with "nic".

To add a Linux Bridge, click 'Create' in the top left and select 'Linux Bridge'.
Create the bridge with the following settings and reboot for them the bridge
creation to take effect:

<ins>Create: Linux Bridge</ins>
Name: vmbr1
IPv4/CIDR: 192.168.1.45/24
Bridge ports: nic1

**NOTE**: The IP address of the bridge itself is the same as the IP address of
the network device on the Proxmox host itself. Each connected LXC will have
their own separate IP address.

To add the network device to the Frigate LXC, navigate to the 'Network' page of
the Frigate LXC. Click 'Add' in the top right to add a new network device.
Configure it with the following settings:

<ins>Add: Network Device (veth)</ins>
Name: eth1
Bridge: vmbr1
IPv4: Static
IPv4/CIDR: 192.168.1.100/24

### 4.3. Configure NTP On Proxmox Host

If you are avoiding connecting the cameras to the internet, you are likely going
to want to set up a Network Time Protocol (NTP) server to periodically sync the
cameras' times to prevent drift. This can be done by running another LXC in
Proxmox, within the Frigate LXC, or directly on the host. It is generally not
recommended to touch anything on the Proxmox host machine, however Proxmox is
already configured to easily set up serving its time to other machines.

Enter the 'Shell' of the Proxmox VE node and open '/etc/chrony/chrony.conf' in a
text editor. Add an "allow" line with the subnet the node will allow to receive
time synching requests from. For example, append the line 'allow 192.168.1.0/24'
to the end of the file. Restart chrony using `systemctl restart chrony` for the
changes to take effect.

To verify NTP is set up correctly, navigate back to the 'Console' of the Frigate
LXC. Log in and install 'ntpsec-ntpdate' using the command
`sudo apt install ntpsec-ntpdate`. After it is finished, query the NTP server of
the Proxmox host using the command `ntpdig 192.168.1.45`.

### 4.4. Update Shared Memory

TODO:
There may be a warning at the bottom right of the screen that says something
along the lines of "/dev/shm allocation should be increased". This is important
as this value should be increased to be able to support multiple cameras. There
is a specific formula on the Frigate Installation page, but to be safe you can
overallocate to prevent crashes. For multiple cameras with higher resolutions,
you'll likely want to do at least 1GB.

To update the shared memory amount, you can add `--shm-size=2gb` to the `docker
run` command that runs Frigate, or you can append it to the configuration file
later on by adding to 'service.shm_size'.

### 4.5. Users

TODO:

### 4.?. Reserve IP Address On Router

Open your router settings and locate the new Frigate LXC and reserve the desired
IP address.

## 5. Configuration

This section highlights the different parts of Frigate configuration.

### 5.?. Home Assistant Integration
