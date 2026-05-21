# TrueNAS

This file contains all of the relevant information regarding TrueNAS.

## Table Of Contents

1\. [TrueNAS](#1-truenas)  
1.1\. [Features](#11-features)  
2\. [Pre-Installation](#2-pre-installation)  
2.1\. [Installation Image and Media](#21-installation-image-and-media)  
2.1.1\. [Acquire and Prepare Installation](#211-acquire-and-prepare-installation)  
2.2\. [Create Virtual Machine](#22-create-virtual-machine)  
3\. [Installation](#3-installation)  
3.1\. [TrueNAS Installer](#31-truenas-installer)  
4\. [Post-Installation](#4-post-installation)  
4.1\. [Access Server Via Browser](#41-access-server-via-browser)  
4.2\. [Users and Groups](#42-users-and-groups)  
4.3\. [Pass-Through Drives to Virtual Machine](#43-pass-through-drives-to-virtual-machine)  
4.3.1\. [Pass-Through Host Bus Adapter](#431-pass-through-host-bus-adapter)  
4.3.2\. [Pass-Through Individual Drives](#432-pass-through-individual-drives)  
4.4\. [Configure Drive Pool](#44-configure-drive-pool)  
4.5\. [Configure Datasets](#45-configure-datasets)  
4.5.1\. [Adding Users and Groups](#451-adding-users-and-groups)  
4.5.2\. [Server Message Block](#452-server-message-block)  
4.5.3\. [Snapshots](#453-snapshots)  
4.6\. [Backups](#46-backups)  
4.7\. [Additional Settings](#47-additional-settings)  
4.7.1\. [Localization](#471-localization)  
4.7.2\. [Alerts](#472-alerts)  
4.8\. [Save Configuration](#48-save-configuration)  
4.9\. [Reserve IP Address On Router](#49-reserve-ip-address-on-router)  
5\. [Web Interface](#5-web-interface)  
5.1\. [Pools, Datasets, and Shares](#51-pools-datasets-and-shares)  

## 1. TrueNAS

TrueNAS is an operating system designed for functioning as a Network Attached
Storage (NAS). It is built on OpenZFS using the ZFS filesystem for emphasis on
not losing data.

### 1.1. Features

- Snapshots
- Replication
- RAID-Z
- ZFS
- Applications

## 2. Pre-Installation

This section highlights the prerequisites for installation of a new TrueNAS
installation.

TrueNAS should run on any x86 system with a minimum of 8GB of RAM.

### 2.1. Installation Image and Media

#### 2.1.1. Acquire and Prepare Installation

Navigate to TrueNAS.com and find where to download the latest version. Instead
of downloading to the PC, right click and copy the download's link address.
Navigate back to Proxmox and find the local storage where ISO images can be
downloaded. Click 'Download from URL' and paste the download URL. Query the URL
and as long as everything looks good, click 'Download' to download the image to
the Proxmox VE installation.

#### 2.2. Create Virtual Machine

Once the installation is complete, click 'Create VM' in the top right corner to
create a virtual machine. Use the following settings for the VM while making
sure 'Advanced' is checked for every menu:

<ins>General</ins>
Node: pve01
VM ID: 100
Name: TrueNAS
Start at boot: yes

<ins>OS</ins>
Use CD/DVD disk image file (iso)
    Storage: local
    ISO image: TrueNAS ISO

<ins>System</ins>
Defaults

<ins>Disks</ins>
Defaults

<ins>CPU</ins>
Cores: 2
Type: x86-64-v2-AES (default)

**NOTE**: Using 'Type: host' will have better performance, but sacrifices the
ability to move between multiple hosts if necessary. The performance boost is
negligible so portability is usually opted for.

<ins>Memory</ins>
Memory (MiB): 8192

**NOTE**: This is the minimum for TrueNAS to run (8GB)

<ins>Network</ins>
Defaults

<ins>Confirm</ins>
Start after created: yes

## 3. Installation

This section highlights the installation process for a new TrueNAS
installation.

### 3.1. TrueNAS Installer

After the virtual machine is created, click on it and open the console to
prepare to install TrueNAS. Wait until the 'TrueNAS Console Setup' appears.

Select '1 Install/Upgrade' using the Enter key.

On the 'Choose Destination Media' page, since there hasn't been any other drives
added you should only see the TrueNAS boot drive allocated to 32GB. Select this
drive with the Space bar and confirm with the Enter key.

Confirm the installation by selecting 'Yes' and pressing the Enter key.

On the 'Web UI Authentication Method' select '2 Configure using Web UI' and
press the Enter key.

Under 'Legacy Boot' we want to select 'Yes' to 'Allow EFI boot' if the TrueNAS
boot drive will be running on an NVMe SSD (for a default configuration, this
drive will be the same as the Proxmox VE host boot drive).

Wait for installation to complete and press the Enter key to continue.

After returning to the 'TrueNAS Console Setup' window, navigate to
'3 Reboot System' and press the Enter key. The VM will then restart
and boot directly into TrueNAS.

## 4. Post-Installation

This section highlights the recommended post-installation steps for a new
TrueNAS installation.

### 4.1. Access Server Via Browser

Navigate to the URL provided on the first boot to the TrueNAS installation.
This URL is in the form of 'https://ip-address:8006/' and is used to access the
server from another device. The first time this URL is accessed, your browser
will most likely warn you that the connection is not private. This is expected.
Click 'Show Details' or something similar and click the link that will allow you
to 'Visit This Website'.

After navigating to the URL, create a new administrator account. The default
administrator is 'truenas_admin'. Create the password and log in. If this is
somehow bypassed by a reboot, navigate to the TrueNAS console and select 'Reset
configuration to defaults' to prompt for creating an administrator account
again.

### 4.2. Users and Groups

Navigate to 'Users' under 'Credentials' and add the necessary users and their
permissions. For a simple NAS purpose, give the users only SMB access.

Navigate to 'Groups' under 'Credentials' and add the necessary groups and their
permissions. For a simple NAS purpose, give the groups only SMB access.

### 4.3. Pass-Through Drives to Virtual Machine

There are two ways to pass-through drives to a virtual machine.

One way is to pass-through the entire Host Bus Adapter (HBA) that the drives
are connected to. This could be a dedicated HBA or just the motherboard's SATA
controller. However, you'll likely loose access to other hardware in the same
group as the SATA controller and also will likely have struggles to even get it
set up.

The other way is to pass-through each drive individually. This sacrifices
Self-Monitoring, Analysis, and Reporting Technology (S.M.A.R.T.) diagnostics for
the drives.

S.M.A.R.T. diagnostics are very important for storage so it's often recommended
to pass-through an HBA if available.

#### 4.3.1. Pass-Through Host Bus Adapter

To pass-through an HBA, you need to use Peripheral Component Interconnect
(PCI) Passthrough. This can be done through the Proxmox VE web interface.

Before proceeding, make sure that IOMMU is enabled on the Proxmox VE host
system. Make sure to add `iommu=pt` to '/etc/default/grub' and run
`update-grub`.

Also, add `vfio`, `vfio_iommu_type1`, and `vfio_pci` to '/etc/modules' with
each on separate lines and run `update-initramfs -u -k all`.
**NOTE**: This may require you to install the 'grub-efi-amd64' package using
`apt install grub-efi-amd64`.

Navigate to the TrueNAS VM's 'Hardware' menu. At the top, click 'Add' and select
'PCI Device'. Select 'Raw Device' and select your system's HBA. Check
'All Functions' and 'Add' to pass-through the HBA.

After the HBA is added, they should now appear in the TrueNAS VM 'Hardware'
menu. Also, in the TrueNAS web interface, if you navigate to 'Storage' on the
left side and then to 'Disks' on the top right, you should be able to see the
boot drive and all of the drives you just added.

#### 4.3.2. Pass-Through Individual Drives

Passing through individual drives are also known as virtual drives.

Navigate to the Proxmox VE node's 'Disks' menu to locate the drives that you'd
like to use. Note the model and serial number. Go into the node's console and
type `ls /dev/disk/by-id` to list all of the disk IDs. Locate the entries that
end with the same serial number as noted above. Copy the full IDs and save them
for later.

Navigate to the TrueNAS VM's 'Hardware' menu in Proxmox VE. You should be able
to see all of the hardware allocated to the TrueNAS VM. There should be one hard
disk assigned as 'scsi0' which is the TrueNAS boot drive.

**NOTE**: Don't forget to remove the installation media in the CD/DVD Drive by
selecting it and clicking 'Remove' at the top.

To add drives to TrueNAS, you need to run a command in the node's console.
In the console, run
`qm set VMID -scsi# /dev/disk/by-id/model_serial,serial=serial` where 'VMID'
is the ID of the TrueNAS VM, '-scsi#' is the SCSI number for that drive,
'model-serial' is the copied disk ID from above, and 'serial' is the serial
number of the disk from above. Repeat this process by incrementing the SCSI
number for each drive.

**NOTE**: In order to delete a drive if there is a mistake, you can run
`qm set VMID -delete scsi#` in the node's console.

After all drives are added, they should now appear in the TrueNAS VM 'Hardware'
menu. Also, in the TrueNAS web interface, if you navigate to 'Storage' on the
left side and then to 'Disks' on the top right, you should be able to see the
boot drive and all of the drives you just added.

### 4.4. Configure Drive Pool

To configue a drive pool, navigate to the 'Storage' menu on the left side and
click 'Create Pool'.

Name the pool. The traditional, classic ZFS default is "tank". Whether or not to
encrypt is chosen based on the use case.

The other options are optional and are based on the use case. In general, these
options are not needed.

A scrub is a ZFS data integrity check that reads every block of data in a pool,
compares it against stored checksums, and automatically repairs silent data
corruption (bit rot) using redundancy. A default scrub task is created upon
creation of a new drive pool. This scrub task tries to run a scrub every Sunday
at midnight and will succeed if the last scrub was performed over 35 days ago.
The scrub task can be configured to whatever increment is desired.

**NOTE**: The following 'S.M.A.R.T.' tests can only be ran on physical hardware.
So, if you passed through individual disks, thus using virtual disks, these
tests will not run.

On top of the scrub task, you're going to want to also create 'S.M.A.R.T. Test'
task. This is no longer configured under the 'Data Protection' menu but instead
configured using Cron jobs. Navigate to 'Advanced Settings' under 'System' to
locate the 'Cron Jobs' box. Click 'Add' to configure a new Cron job. Add a
description like 'S.M.A.R.T. Long sdX' for long S.M.A.R.T. tests for
'/dev/sdX'. This can be scheduled at whatever increment is desired.

To monitor the 'S.M.A.R.T. Test' results, install the 'Scrutiny' app with
default settings. You also need to set up another Cron job to collect S.M.A.R.T.
metrics. The command to collect these metrics is `docker exec
xi-scrutiny-scrutiny-1 /opt/scrutiny/gin/scrutiny-collector-metrics run`
This should be ran the day after S.M.A.R.T. is ran every month.

### 4.5. Configure Datasets

The configure a dataset, navigate to 'Datasets' on the left side of the screen.
Select the drive pool you'd like to create a dataset in and click 'Add Dataset'
in the top left corner. Name the dataset to something simple but descriptive
like 'share' or 'media'. Select the 'Dataset Preset' that this dataset will be.

#### 4.5.1. Adding Users and Groups

To add a user to a dataset, select the dataset and click the 'Edit' button under
the 'Permissions' box. Under the 'Access Control List', click 'Add Item' and add
a user or group to the Access Control List (ACL). You generally want to add a
user or group with the 'Modify' permissions to read and write but not modify the
dataset properties themselves. The rest of the options can remain as default.
Click 'Save Access Control List' to add the user or group to the ACL. Repeat the
process for all users and groups to add.

#### 4.5.2. Server Message Block

For a Server Message Block (SMB) share, select 'SMB' as the 'Dataset Preset'.
Make sure that 'Create SMB Share' is checked and modify the 'SMB Name' if
desired to be different than the dataset. Click 'Save' to create the dataset. If
there is a pop-up asking to 'Start SMB Service', make sure that the switch is
turned on to 'Enable this service to start automatically' and click 'Start' to
start the SMB Service.

#### 4.5.3. Snapshots

Snapshots are literally snapshots of your datasets at certain points in time.
These can be very beneficial by minimizing data loss in case of accidental
deletion or corruption. These snapshots help preserve data stats for recover,
backup, and versioning purposes.

To create snapshot tasks that happen periodically, navigate to the 'Data
Protection' menu. You're going to want to 'Add' new 'Periodic Snapshot Tasks'.

These tasks should ideally follow the 'Grandfather-Father-Son' backup scheme.
It's a hierarchical data retention strategy.

- Son (Hourly/Daily): Frequent backups to capture day-to-day changes for
  immediate file restoration
- Father (Weekly/Biweekly): Full, consolidated backups to provide mid-term
  recovery points
- Grandfather (Monthly/Yearly): Full backups saved for long term, typically
  stored off-site or in the cloud

This backup scheme can be followed by creating multiple tasks to cover each
frequency and retention. An example set of tasks would be:

- Hourly with a lifetime of 3 days
- Daily at midnight with a lifetime of 2 weeks
- Weekly on Sunday at midnight with a lifetime of 2 months

Make sure to keep 'Allow Taking Empty Snapshots' checked for each task.

### 4.6. Backups

Backups can be configured under the 'Data Protection' menu as well. There are a
few different ways to back up data and can be utilized depending on the use
case. These options include 'TrueCloud Backup', 'Cloud Sync', 'Rsync', and
'Replication'.

### 4.7. Additional Settings

This section has additional settings that may need to be changed if desired.

#### 4.7.1. Localization

Navigate to 'General Settings' under 'System' on the left side of the screen and
make sure to update your 'Localization' if necessary.

#### 4.7.2. Alerts

Navigate to 'Users' under 'Credentials' and add an email for the 'truenas_admin'
account to the email that you'd like to use for alerts.

Navigate to 'General Settings' under 'System' and configure the Email 'Settings'
for TrueNAS to use to actually send emails. Make sure to use the same email for
the 'From Email' field if configuring over SMTP.

### 4.8. Save Configuration

Once everything is configured, navigate to the 'Advanced Settings' menu under
'System'. Click the button in the top right labeled 'Manage Configuration' and
select 'Download File'. This file contains a backup of the TrueNAS configuration
so that it can be restored later if necessary. Make sure to select 'Export
Password Secret Seed' to restore configuration from a new drive. If this is not
checked then the same installation of TrueNAS is required to decode the
configuration.

### 4.9. Reserve IP Address On Router

Open your router settings and locate the new TrueNAS virtual machine and reserve
the desired IP address.

## 5. Web Interface

This section highlights the different sections of the TrueNAS web interface.

### 5.1. Pools, Datasets, and Shares

Pools are a group of drives that have storage and can be used for datasets and
shares. These can be configured in different ways to help with data redundancy.

Datasets are logical sets of data that are greated within a pool. Each dataset
has their own role in what they're supposed to function as.

Shares, specifically SMB shares, are network attached datasets. So, they can be
accessed from anywhere on the network as long as the correct credentials are
given for a known user. Sometimes accessing SMB shares using the TrueNAS IP
address needs to be prepended by 'smb://' for it to work.
