# Proxmox Backup Server

This file contains all of the relevant information regarding Proxmox Backup
Server.

## Table Of Contents

1\. [Proxmox Backup Server](#1-proxmox-backup-server)  
1.1\. [Features](#11-features)  
2\. [Pre-Installation](#2-pre-installation)  
2.1\. [Acquire and Prepare Image](#21-acquire-and-prepare-installation)  
3\. [Installation](#3-installation)  
3.1\. [Graphical Installer](#31-graphical-installer)  
3.2\. [OS Drive](#32-os-drive)  
3.3\. [Location, Time Zone, and Keyboard Layout](#33-location-time-zone-and-keyboard-layout)  
3.4\. [Administration Password and Email Address](#34-administration-password-and-email-address)  
3.5\. [Network Configuration](#35-network-configuration)  
3.6\. [Confirm and Install](#36-confirm-and-install)  
4\. [Post-Installation](#4-post-installation)  
4.1\. [Access Server Via Browser](#41-access-server-via-browser)  
4.2\. [Fix Repositories](#42-fix-repositories)  
4.3\. [Adjust Power Settings For Laptops](#43-adjust-power-settings-for-laptops)
4.4\. [Reserve IP Address On Router](#44-reserve-ip-address-on-router)  
5\. [Configuration](#5-configuration)  
5.1\. [Create Datastore](#51-create-datastore)  
5.2\. [Proxmox Backup Server API Token](#52-proxmox-backup-server-api-token)  
5.3\. [Back Up Proxmox VE](#53-back-up-proxmox-ve)  
5.3.1\. [Add Proxmox Backup Server to Proxmox VE](#531-add-proxmox-backup-server-to-proxmox)  
5.3.2\. [Configure Backup Schedule](#532-configure-backup-schedule)  

## 1. Proxmox Backup Server

Proxmox Backup Server (PBS) is an enterprise backup solution, for backing up and
restoring VMs, containers, and physical hosts. By supporting incremental, fully
deduplicated backups, Proxmox Backup Server significantly reduces network load
and saves valuable storage space. With strong encryption and methods of
ensuring data integrity, you can feel safe when backing up data, even to
targets which are not fully trusted.

Visit "https://www.proxmox.com/en/products/proxmox-backup-server/overview"
for more information.

### 1.1. Features

- Backup
- Architecture
- Data Integrity & Security
- Restore
- Management
- Proxmox VE Integration
- Tape

## 2. Pre-Installation

This section highlights the prerequisites for installation of a new Proxmox
Backup Server system.

Proxmox Backup Server should run a modern AMD or Inter 64-bit CPU with at least
4 cores and a minimum of 4GB RAM for the OS, filesystem cache, and Proxmox
Backup Server daemons.

### 2.1. Acquire and Prepare Image

Refer to [Bare Metal Image](common-procedures.md#211-bare-metal-iso)
instructions for acquiring and preparing the Proxmox Backup Server image.

While in the BIOS, make sure to enable all of the desired settings like
"magic packets" to remotely wake up the server, or to set whether the system
will reboot on power loss.

## 3. Installation

This section highlights the installation process for a new Proxmox Backup
Server system using the Proxmox Backup Server Installation Media.

### 3.1. Graphical Installer

Once booted into the Proxmox Backup Server Installation Media, select the
option that says "Install Proxmox Backup Server (Graphical)" and wait for the
graphical installation menu to come back up after initial setup is ran.
Click 'I agree' on the EULA page to proceed to installation.

### 3.2. OS Drive

Select the 'Target Harddisk' or the drive to install the Proxmox Backup Server
OS onto. It is recommended to at least have an SSD as the OS drive to make the
overall experience much faster. Clicking the 'Options' button will bring up a
menu for more granular control over the installation. The 'ext4' filesystem is
recommended for a singular drive but if there with be redundant OS drives then
the 'zfs' filesystem is recommended.

Click 'Next' to continue.

### 3.3. Location, Time Zone, and Keyboard Layout

Select the country, time zone, and keyboard layout for the Proxmox Backup Server
installation.

Click 'Next' to continue.

### 3.4. Administration Password and Email Address

Enter the desired 'root' password for this Proxmox Backup Server installation.
Type the password in again to confirm the correct entry. Then, provide an email
address. This email address can be used to send important alert information if
desired.

Click 'Next' to continue.

### 3.5. Network Configuration

Select the Network Interface Card (NIC) to use for this installation. Some
systems may have multiple NICs, but more than likely the motherboard NIC is
what will be used.

Enter a hostname, or Fully Qualified Domain Name (FQDN). This will be in the
form 'hostname.domain.name'. For example, 'pbs.server.com' will cause Proxmox
Backup Server to have a hostname of 'pbs' with a domain name of 'server.com'.
The domain name usually doesn't matter unless you're explicitly trying to use
it. If you don't want to use a domain name or don't have one, it's common
practice to use 'hostname.internal' or 'hostname.lan' set the proper hostname
and make the domain either '.internal' or '.lan'.

Enter the IP address that you want to assign to the Proxmox Backup Server
system. Make sure that this address is in the same subnet of you Local Area
Network (LAN).

Enter the Default Gateway and the DNS Server that is used by your local network
to properly configure Proxmox Backup Server to access the internet.

It is highly recommended to check 'Pin network interface names' and to use the
'Options' menu to name them if desired. This prevents Proxmox Backup Server from
causing problems when NICs are assigned a new name on reboot. This check box
keeps track of NICs by known names to maintain stability.

Click 'Next' to continue.

### 3.6. Confirm and Install

Verify all information for the new Proxmox Backup Server system is correct and
make sure the box to 'Automatically reboot after successful installation' is
checked.

Click 'Install' to install the OS. When prompted, remove the Proxmox Backup
Server installation media to prepare for boot into actual Proxmox Backup Server
installation.

## 4. Post-Installation

This section highlights the recommended post-installation steps for the new
Proxmox Backup Server system to properly configure the server.

### 4.1. Access Server Via Browser

Refer to [Access Server Via Browser](common-procedures.md#42-access-server-via-browser)
to access the server.

The URL will be: https, the node's IP address, and a default port of 8007.

After navigating to the URL, login as 'root' with the root password you
configured during the installation. The realm set to 'Linux PAM standard
authentication' and language set to 'English - English' do not need to be
changed.

### 4.2. Fix Repositories

When you first log in to Proxmox Backup Server via a web browser, you can see
a warning in the dashboard that says 'Enterprise repository needs valid
subscription'.

To fix this, click on the arrow next to the warning, or navigate to the
'Repositories' section under the 'Administration' menu. Select the enterprise
repository and click disable. Then, add the 'No-Subscription' repository.

After the repositories are fixed, navigate up to the 'Updates' section and click
'Refresh' to run a `apt update` and update references to apt packages. Once that
completes, click 'Upgrade' to run a `apt upgrade` and upgrade all installed
packages. Reboot to finalize updates by selecting the system on the left and
clicking 'Reboot' in the top right.

### 4.3. Additional Laptop Settings

If running Proxmox Backup Server from a laptop, you'll likely need to change
settings to maintain functionality when the laptop lid is closed. Navigate to
`/etc/systemd/logind.conf` and uncomment and edit the following lines:

- HandleLidSwitch=ignore
- HandleLidSwitchExternalPower=ignore
- HandleLidSwitchDocked=ignore

To apply the new settings, restart the systemd service by executing
`systemctl restart systemd-logind`. It is recommended to restart the laptop
afterwards as well to make sure the changes take effect.

This will only prevent the laptop from going to sleep when the lid is closed.
This means that the screen will still stay on when the lid is closed. To fix
this, we need to also edit the file `/etc/default/grub` at the
'GRUB_CMDLINE_LINUX_DEFAULT' line. In the quotes, add a space followed by
'consoleblank=30'. After this is added, save the file and run `update-grub`
to confirm changes and reboot system for them to take effect.

This kernel parameter makes the screen shut off after 30 seconds of inactivity.
Pressing a key on the keyboard will wake it back up if access to the terminal on
the laptop itself is needed.

### 4.4. Reserve IP Address On Router

Refer to [Reserve IP Address On Router](common-procedures.md#43-reserve-ip-address-on-router)
reserve the desired IP address for the new Proxmox VE system.

## 5. Configuration

This section highlights the configuration of the Proxmox Backup Server.

### 5.1. Create Datastore

Proxmox Backup Server utilizes datastores at locations to store backups. There
is a "Datastores" section on the bottom of the sidebar that will bring you to a
menu with a list of the configured datastores. To create a new datastore, click
the 'Add Datastore' button the sidebar.

**NOTE**: It is recommended to create separate datastores for each Proxmox VE
node you are planning to back up. The reason for this is so that LXC IDs and
VM IDs do not clash if the same is used on multiple nodes.

<ins>Add: Datastore</ins>
Name: _Desired Name_
Datastore Type: Local (if the datastore is on the same drive as the OS)
Backing Path: _Desired Path_
GC Schedule: _Desired Schedule_
Prune Schedule: _Desired Schedule_

**NOTE**: Garbage Collection (GC) and Prune is highly recommended to minimize
storage usage. Pruning cleans up the backup index files while Garbage Collection
cleans up the actual files. These should be slightly staggered with Prune
finishing before GC starts. Also, make sure these are executed after backups
have been made so that the jobs are effective.

It is also recommended to set up verify jobs to ensure that backups are being
cleaned up correctly and that they are valid. This can be done by navigating to
the "Verify Jobs" menu in the "Datastores" page. A verify job should be created
for each datastore. This should run after both Prune and Garbage Collection are
executed.

<ins>Add: Verification Job</ins>
Local Datastore: _Desired Datastore_
Namespace: Root
Max. Depth: Full
Schedule: _Desired Schedule_
Skip Verified: yes
Re-Verify After: 30 days

### 5.2. Proxmox Backup Server API Token

In order to allow Proxmox VE to back up to Proxmox Backup Server, you must
create an API Token.

It is common to create a new user and group on Proxmox Backup Server for backup
purposes, but isn't strictly necessary since Proxmox Backup Server API Tokens
can be created with "Privilege Separation". This means that API Token
permissions are separated from the user of the API Tokens. In other words, the
permission allowed through the API Token is no longer tied to the user and
group, but now to the API Token itself.

To create an API Token, navigate to the "Access Control" menu under
"Configuration" and go to the "API Token" tab. Select the desired user and
provide a "Token ID" that describes the purpose of the key, like "pve01". Click
the 'Add' button.

<ins>Add: API Token</ins>
User: _Desired User_@_Desired Realm_
Token Name: _Desired Name_

To modify the permissions of the API Token, click the "Permissions" tab and
click "Add" to add an "API Token Permission". For Proxmox VE backups, use the
following options to allow proper datastore access through this API Token.

<ins>Add: API Token Permission</ins>
Path: _Datastore Location_
API Token: _Desired Token_
Role: DatastoreAdmin
Propagate: yes

### 5.3. Back Up Proxmox VE

This section highlights the steps to back up Proxmox VE using Proxmox Backup
Server.

#### 5.3.1. Add Proxmox Backup Server to Proxmox VE

Navigate to the "Storage" menu under the "Datacenter" menu on your Proxmox VE
console. Click "Add" to add a "Proxmox Backup Server" storage device and fill in
all of the correct information.

<ins>Add: Proxmox Backup Server</ins>
ID: _Desired Name_
Server: _Desired Server_
Username: _Desired User_@_Desired Realm_
Password: _Username's Password_
Datastore: _Desired Datastore_
Fingerprint: _Proxmox Backup Server Fingerprint_

**NOTE**: If you used an API Token instead of a user like shown above, set the
"Username" field to _Desired User_@_Desired Realm_!_Desired Token_ and fill the
"Password" field with the key.

#### 5.3.2. Configure Back Up Schedule

Navigate to the "Backup" menu under the "Datacenter" menu on your Proxmox VE
console. Click "Add" to create a new "Backup Job". It is recommended to schedule
this before Prune and Garbage Collection jobs are scheduled so that the process
is backup, prune, garbage collection, verification. This will allow for the most
efficiency with Proxmox Backup Server. Also, it is recommended to slightly
stagger backups so that individual backups are more efficient due to dedicated
bandwidth.

<ins>Create: Backup Job</ins>
Node: -- All --
Storage: _Proxmox Backup Server Storage_
Schedule: _Desired Schedule_
Selection mode: All
Mode: Snapshot

**NOTE**: You can run the job on demand from the same menu. If desired, you can
run this after initial setup to make sure everything is configured properly.
