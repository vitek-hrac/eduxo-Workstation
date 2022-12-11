# About eduxo Workstation

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
