# eduxo Workstation

**OS:** Ubuntu 22.04  
**Login:** sysadmin:Netlab!23  
**Hostname:** eduxo  
**FQDN:** eduxo.lab

Tested with VirtualBox Version: 6.1.28 r147628 (Qt5.6.2)  


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


## Changelog
- Version: 1.0.0     30-Apr-2022 - Jaroslav
	- new VM (all-in-one)

- Version: 1.1.0     15-Jun-2022 - Jaroslav
	- add docker for compatible with HAXAGON
	- set web homepage on www.eduxo.cz
	- add secret repo eduxo
	- add VPN client ZeroTier
