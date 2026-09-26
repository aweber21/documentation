# Gitea

This file contains all of the relevant information regarding Gitea.

## Table Of Contents

1\. [Gitea](#1-gitea)  
1.1\. [Features](#11-features)  
2\. [Pre-Installation](#2-pre-installation)  
2.1\. [Acquire and Prepare Image](#21-acquire-and-prepare-installation)  
3\. [Installation](#3-installation)  
3.1\. [Create Linux Container](#31-create-linux-container)  
3.2\. [Proxmox Helper Script](#32-proxmox-helper-script)  
4\. [Post-Installation](#4-post-installation)  
4.1\. [Debian Container Configuration](#debian-container-configuration)  
4.2\. [Install Gitea](#34-install-gitea)  
4.3\. [Access Server Via Browser](#43-access-server-via-browser)  
4.4\. [Users](#44-users)  
4.5\. [Reserve IP Address On Router](#45-reserve-ip-address-on-router)  
5\. [Configuration](#5-configuration)  

## 1. Gitea

Gitea is a painless self-hosted all-in-one software development service,
including Git hosting, code review, team collaboration, package registry, and
CI/CD. It's open source under MIT license. It is designed to be lightweight,
easy to use, and highly customizable, making it an ideal choise for both small
teams and large organizations.

Visit "https://about.gitea.com/products/gitea" for more information.

### 1.1. Features

- Easy Installation and Configuration
- High Performance
- Collaboration Made Simple
- Full Git Compatibility
- Security and Access Control
- Cross-Platform Compatibility

## 2. Pre-Installation

This section highlights the prerequisites for installation of a new Gitea
installation.

Gitea offers universal compatibility and flexible deployment options. It can be
ran on any operating system, supports popular databases, and offers flexible
deployment options. This document will cover the Docker installation in an Linux
Container (LXC) on Proxmox.

### 2.1. Acquire and Prepare Image

The recommended operating system to run Gitea on is
'Debian 12 Bookworm (standard)'. Proxmox comes with a LXC Container Template
called 'debian-12-standard' and this is sufficient for the Gitea LXC.

Refer to [Linux Container Template](common-procedures.md#214-linux-container-template)
instructions to download a Debian LXC template.

## 3. Installation

This section highlights the installation process for a new Gitea system using
a Proxmox VE Linux Container.

Begin by clicking 'Start' in the top right corner of the Gitea LXC page.
Navigate to the console and login using 'root' and the password provided when
creating the LXC.

### 3.1. Create Linux Container

Refer to [Create Linux Container](common-procedures.md#create-linux-container)
instructions to create a Debian Linux Container.

Use the following specific settings for the LXC:

<ins>General</ins>
Node: pve01
CT ID: 102
Name: gitea
Unprivileged container: yes
Provide a password

<ins>Template</ins>
Storage: local
Template: debian-13-standard template

<ins>Disks</ins>
Storage: local-lvm
Disk size (GiB): 32

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
Start after created: yes

### 3.2. Proxmox Helper Script

There exists a Proxmox VE Helper Script, if desired to install that way instead.
The Gitea helper script seems to be well appreciated.

Refer to [Proxmox Helper Scripts](common-procedures.md#33-proxmox-helper-scripts)
if desired instead.

## 4. Post-Installation

This section highlights the recommended post-installation steps for the new
Gitea system.

### 4.1. Debian Container Configuration

Refer to [Debian Container Configuration](common-procedures.md#41-debian-container-configuration)
to configure the Debian Linux Container.

Make sure to create a Gitea Administrator account with the username of
"gitea_admin".

### 4.2. Install Gitea

When you first run Gitea, it creates the necessary directory structure for
you. You will need to create a blank Docker Compose file using the command
`touch docker-compose.yml`.

This command needs to be executed within the folder that Gitea is to be
installed in. This can be anywhere on the system, like the "gitea_admin" home
folder for example, but it is cleaner to keep it in a generic system location,
like in a "/opt/gitea" directory.

**NOTE**: If you install Gitea to "/opt/gitea" or another location in the
filesystem that is owned by "root", it will make things easier to change the
owner of the directory to the "gitea_admin" user and the "gitea_admin" group
by executing the command `sudo chown -R gitea_admin:gitea_admin /opt/gitea`.

Navigate to 'https://docs.gitea.com/installation/install-with-docker/' and copy
the initial Gitea Docker Compose contents from the 'Basics' section and paste it
into the 'docker-compose.yml' that was just created. Modify it if necessary.

Finally, run `docker compose up` to pull down the Gitea container image and
start it for the first time.

### 4.3. Access Server Via Browser

Refer to [Access Server Via Browser](common-procedures.md#42-access-server-via-browser)
to access the server.

The URL will be: https, the node's IP address, and a default port of 3000.

After navigating to the URL, complete the initial configuration. All of these
settings can be changed later. When done, press 'Install Gitea' to finish the
Gitea installation.

**NOTE**: It is recommended to create an administrator account during this
configuration for administrative tasks that is separate from daily repository
management accounts.

### 4.4. Users

Navigate to the "Site Administration" menu found after clicking the logged in
administrator account picture in the top right. Under "Identity & Access"
navigate to the "User Accounts" menu. Click the 'Create User Account' button in
the top right of the page to create a new user.

### 4.5. Reserve IP Address On Router

Refer to [Reserve IP Address On Router](common-procedures.md#43-reserve-ip-address-on-router)
reserve the desired IP address for the new Frigate LXC.

## 5. Configuration

This section highlights the different parts of Gitea configuration.

### 5.1. Migration

To migrate from an existing platform to Gitea while maintaining the existing
platform as a backup, you can migrate the repository to Gitea and then configure
the existing platform as a push mirror.

For GitHub, navigate to your GitHub account settings and under the "Developer
Settings" menu, generate a "Personal Access Token" in order to access your
GitHub account through Gitea. The PAT will be used instead of the password to
your GitHub account. Make sure to create a "Classic" token under the "Tokens
(classic)" menu. A classic token is an "all-or-nothing" token while
"fine-grained" tokens are repository scoped. We want full access to the account
so a classic token is desired with every scope selected. Make sure to copy this
token as it'll only be available one time.

Navigate to Gitea and log in as the desired user (usually the account that is
the owner of the GitHub repository that is being migrated) and click the '+'
button in the top right and select the 'New Migration' button. Select the
'GitHub' button to proceed with migrating a GitHub repository.

Copy the repository's HTTPS URL from GitHub and the PAT created. Select all of
the migration options except "This repository will be a mirror". If this is
selected, GitHub will be treated as the source of truth and Gitea will
periodically pull from GitHub. Make the repository name and description the same
as the GitHub repository and select desired visibility. Click the 'Migrate
Repository' button to migrate the GitHub repository to Gitea.

In order configure GitHub as a push mirror, inside the newly migrated Gitea
repository navigate to the "Settings" menu in the top right of the repository
page. Select the "Repository" menu on the right and locate the "Push Mirrors"
section. Fill in the "Git Remote Repository URL" field, and the "Username" and
"Password" fields with the GitHub account username and PAT generated above.
Also, select "Sync when commits are pushed" to always sync with GitHub after
commits are pushed to Gitea. Set the "Mirror Interval" to whatever is desired.
Click 'Add Push Mirror' to add GitHub as a push mirror.
