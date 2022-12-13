# About eduxo Workstation

## Why do we use the Ubuntu Server distribution?

There are several reasons why Ubuntu Server is a good choice. One reason is that it is a stable and reliable platform.

There are several advantages to using the Ubuntu operating system. Some of these include:

1. It offers a stable and reliable platform.
2. It has a large and active community of users and developers, who contribute to the development and improvement of the operating system.
3. It is versatile and can be used on a wide range of hardware platforms, making it a good choice for users with diverse computing needs.
4. It offers a wide range of tools and features that make it easy to set up and manage a server, including support for various server applications and services.
5. It is a constantly evolving and improving platform, with regular updates and new versions being released. 


## What can/cannot I use eduxo Workstation for? 

**This environment can be used to teach practical exercises in the areas of:**
- Linux workstation administration,
- Linux server administration,
- Linux security,
- Linux network service management,
- introduction to computer networks,
- switching and routing,
- security in computer networks,
- computer network administration and monitoring,
- computer network diagnostics,
- computer network design.
- cryptography,
- security of networks and services,
- computer network administration and supervision,
- detection and prevention of network attacks,
- security testing.

**This environment CANNOT be used to teach practical exercises in the areas of:**
- Windows workstation administration
- Windows server administration
- Windows security
- Windows network services management


## How to get eduxo Workstation

### 1. Download VM

**Download link:** https://drive.google.com/drive/folders/1A_opDISoGS34Qv2K3pXFpJlER598i9vg?usp=sharing

#### Basic information about VM

**OS:** Ubuntu Server 22.04  
**Login:** sysadmin:Netlab!23  
**Hostname:** eduxo  
**FQDN:** eduxo.lab  

#### Requirements

```
+---------------------- MINIMUM ----------------------+
|    Host System:           64-bit x86 System         |
|    Memory:                4 GB RAM                  |
|    Number of Processors:  2                         |
|    Free Disk Space:       60 GB Hard Disk           |
+-----------------------------------------------------+

+-------------------- RECOMMENDED --------------------+
|    Host System:           64-bit x86 System         |
|    Memory:                16 GB RAM                 |
|    Number of Processors:  4                         |
|    Free Disk Space:       80 GB Hard Disk           |
+-----------------------------------------------------+
```

#### Internal Networks Topology 
```
+----------------+
|    INTERNET    |
+----------------+
        |
        +----------------------------------------+
        |-----------+                            |
    +-->|   ens32   |-----> DHCP                 |
    |   |-----------+                            |
    |   |                                        |
    [NAT]                                        |
    |   |                                        |                               
    |   |-----------+                            |
    +-->|  virtbr0  |-----> 192.168.122.1/24     |
    |   |-----------+                            |
    |   |                                        |                                  
    |   |-----------+                            |
    +-->|  docker0  |-----> 172.17.0.1/16        |
    |   |-----------+                            |
    |   |                                        |                                  
    |   |-----------+                            |
    +-->|  lxdbr0   |-----> 10.20.30.1/24        |
        |-----------+                            |
        +----------------------------------------+
```

### 2. Running the ```init-VM.sh``` script

1. Install the Linux Ubuntu operating system (we recommend Ubuntu Server 22.04),
2. Download the init-VM.sh script,
3. Run the script,
4. Sit back comfortably with a cup of good coffee and wait for the installation of all tools to complete.


