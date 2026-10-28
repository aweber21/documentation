# Caddy

This file contains all of the relevant information regarding Caddy.

## Table Of Contents

1\. [Caddy](#1-caddy)  
1.1\. [Features](#11-features)  
2\. [Pre-Installation](#2-pre-installation)  
2.1\. [Acquire and Prepare Image](#21-acquire-and-prepare-installation)  
3\. [Installation](#3-installation)  
3.1\. [Create Linux Container](#31-create-linux-container)  
3.2\. [Proxmox Helper Script](#32-proxmox-helper-script)  
4\. [Post-Installation](#4-post-installation)  
4.1\. [Debian Container Configuration](#debian-container-configuration)  
4.2\. [Install Caddy](#42-install-caddy)  
4.3\. [Reserve IP Address On Router](#44-reserve-ip-address-on-router)  
5\. [Customization](#5-customization)  

## 1. Caddy

Caddy is a powerful, extensible platform to serve your sites, services, and
apps, written in Go. Most people use Caddy as a web server or proxy, but at its
core, Caddy is a server of servers. Configuration is both dynamic and exportable
with Caddy's API. Most people's favorite way of configuring Caddy is using the
'Caddyfile' that has a native config language of JSON. By default, Caddy
automatically obtains and renews TLS certificates for all your sites.

Caddy compiles for all major platforms and has no runtime dependencies.

### 1.1. Features

- HTTPS/TLS For Custom Domains
- Dynamically Provision Certificates
- Cluster Coordination
- PCI, HIPAA, and NIST Compliant
- Online Config API

## 2. Pre-Installation

This section highlights the prerequisites for installation of a new Caddy
installation.

Caddy compiles for all major platforms and has not runtime dependencies.

This document will cover installation for an LXC on Proxmox.

There exists a Proxmox VE Helper Script, if desired.

### 2.1. Acquire and Prepare Image

The recommended operating system to run Caddy on is
'Debian 12 Bookworm (standard)'. Proxmox comes with a LXC Container Template
called 'debian-12-standard' and this is sufficient for the Caddy LXC.

Refer to [Linux Container Template](common-procedures.md#214-linux-container-template)
instructions to download a Debian LXC template.

### 3. Installation

This section highlights the installation process for a new Homepage
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
Name: caddy
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
Memory (MiB): 1024
Swap (MiB): 1024

<ins>Network</ins>
IPv4: DHCP
IPv6: DHCP

<ins>DNS</ins>
Defaults

<ins>Confirm</ins>
Start after created: no

### 3.2. Proxmox Helper Script

Refer to [Proxmox Helper Scripts](common-procedures.md#33-proxmox-helper-scripts)
if desired instead.

## 4. Post-Installation

This section highlights the recommended post-installation steps for a new
Caddy installation.

Begin by clicking 'Start' in the top right corner of the Caddy LXC page.
Navigate to the console and login using 'root' and the password provided when
creating the LXC.

### 4.1. Debian Container Configuration

Refer to [Debian Container Configuration](common-procedures.md#41-debian-container-configuration)
to configure the Debian Linux Container.

Make sure to create a Caddy Administrator account with the username of
"caddy_admin".

### 4.2. Install Caddy

In order to install Caddy, it is best to follow the official documentation
provided at 'https://caddyserver.com/docs/install/'. Specifically, follow the
section that is named "Debian, Ubuntu, Raspbian".

### 4.3. Reserve IP Address On Router

Refer to [Reserve IP Address On Router](common-procedures.md#43-reserve-ip-address-on-router)
reserve the desired IP address for the new Homepage LXC.

## 5. Customization

This section highlights the customization of the Caddy service.
