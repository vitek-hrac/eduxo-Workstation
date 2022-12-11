# About eduxo Workstation

## Why do we use the Debian distribution?

There are several reasons why Debian is a good choice. One reason is that it is a stable and reliable platform, with a long history.

There are several advantages to using the Debian operating system. Some of these include:

1. It offers a stable and reliable platform, with a history of being used in mission-critical environments.
2. It has a large and active community of users and developers, who contribute to the development and improvement of the operating system.
3. It is versatile and can be used on a wide range of hardware platforms, making it a good choice for users with diverse computing needs.
4. It offers a wide range of tools and features that make it easy to set up and manage a server, including support for various server applications and services.
5. It is a constantly evolving and improving platform, with regular updates and new versions being released. 


## Basic information

**OS:** Debian 11 (Bullseye)  
**Login:** sysadmin:Netlab!23  
**Hostname:** eduxo  
**FQDN:** eduxo.lab 


## Requirements

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


## Topology 
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


## Use 

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
