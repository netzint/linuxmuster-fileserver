# Linuxmuster Fileserver

This tool installs a file server and joins it to the Linuxmuster server's AD. The share is configured on the server for the specified school and can then be integrated into the Linuxmuster server via the DFS configuration. All home drives, share drives, and project drives are then located on the separate file server.

## Benefits

- Separation of services (AD on the Linux sample server, files on the file server)
- Better backup strategy (files can be backed up separately from the AD)
- Security (a separate file server can be used for each school (multi-school setup))
- Easy maintenance and updates (AD remains available during a file server restart or update)
- Performance improvement (see [Performance improvement](#performance-improvement))

## Maintenance Details
<div align="center">
Linuxmuster.net official | ✅  YES
:---: | :---: 
[Community support](https://ask.linuxmuster.net) | ✅  YES*
Actively developed | ✅  YES
Maintainer organisation |  Linuxmuster.NET
Primary maintainer | lukas.spitznagel@netzint.de  
    
\* The linuxmuster community consist of people who are nice and happy to help. They are not directly involved in the development though, and might not be able to help in all cases.
</div>

## Installation

### 1. Import key

```bash
wget -qO- "https://deb.linuxmuster.net/pub.gpg" | gpg --dearmour -o /usr/share/keyrings/linuxmuster.net.gpg
```

### 2. Add repo

```bash
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/linuxmuster.net.gpg] https://deb.linuxmuster.net/ lmn73 main" > /etc/apt/sources.list.d/lmn73.list'
```

### 3. Update & install

```bash
sudo apt update && sudo apt install linuxmuster-fileserver
```

## Setup

1. Add fileserver to ```devices.csv``` and import the devices with ```linuxmuster-import-devices```. Example:
```csv
server;file01;nopxe;BC:24:11:4D:97:AB;10.0.0.101;;;;server;;0;;;;SETUP;
```

2. Setup the fileserver
```
linuxmuster-fileserver setup [-d DOMAIN] [-u USERNAME] [-p PASSWORD] [-s SCHOOL]
```
| Parameter | Description | Default |
|-----------|-------------|---------|
| -h        | Helppage    |         |
| -d        | Domain of the AD | linuxmuster.lan |
| -u        | Username of an adminitrative user | global-admin |
| -p        | Password for the administrative user (will be asked if not specified) |  |
| -s        | Schoolname for the share (same as in AD) | default-school |

## Performance improvement

### 📊 SMB Performance Comparison: file01 vs. server

As part of an internal benchmark, we evaluated the SMB performance of two shares:

    file01 – a dedicated file server

    server – a domain controller that also hosts file shares

### 🔧 Test Setup

We used the following command to upload and immediately delete a 1 GB test file (http://speedtest.belwue.net/random-1G) in each run:

```bash
smbclient //<target>/<share> -U global-admin -k -c "put random-1G;rm random-1G"
```

    Each test was repeated 100 times

    The execution time was measured for every run

    Average times were calculated for both servers

### 📈 Average Results
| Target	| Avg. Time (Seconds) |
|-----------|---------------------|
| file01	| 2.102               |
| server	| 5.418               |

### 🚀 Relative Performance

    file01 is 61.2% faster than server

    server is 157.7% slower than file01

### 🧠 Summary

A dedicated file server (file01) not only improves system architecture by separating concerns, but also provides significantly better performance in real-world SMB file operations.

This result reinforces the recommendation to avoid using domain controllers for file storage in performance-sensitive environments. A standalone file server improves throughput, reduces latency, and simplifies resource scaling.