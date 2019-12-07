# Enable Virtualization Bios Setting

PCs and Laptops ship with a **<code>BIOS virtualization setting</code>** that is either turned on or off. The <strong>base cli</strong> uses VirtualBox provisioned VMs and these in turn require the <strong>BIOS virtualization setting</strong> to be turned on.

As a system administrator you'll need to

- know the BIOS virtualization setting for your inventory of PCs and Laptops
- decide on a stragegy to switch on this BIOS setting for the users that need it
- require that this flag is set either at the factory, or during PC provisioning

## All HyperVisors, Not Just VirtualBox

All Hypervisors depend on this Virtualization setting, not just VirtualBox. This includes

- VMWare Fusion
- VMWare Server
- Windows Virtual PC
- Oracle VirtualBox

## How to Enable Virtualization BIOS Setting

The keystrockes to get into the BIOS vary wildly from PC to PC, laptop to laptop, and server to server.

It invariably involves **pressing a function key and/or space bar** right at the beginning when the machine boots up. This is usually before the boot process starts running the installed operating system.

When in the BIOS look for words such as

- **VT-X**
- **Virtualization Setting**


## Is Virtualization On or Off?

**You can read the BIOS setting without hijacking the boot process** and steering into the BIOS. So how do we do this in Linux and Windows.

### Linux | Is Virtualization On or Off?

<code>**cat /proc/cpuinfo**</code>

The output lists the processors you have available and the flags that are set.

Look for the ***vmx flag*** - if it exists then your virtualization is on.

```
processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 26
model name	: Intel(R) Core(TM) i7 CPU         950  @ 3.07GHz
stepping	: 5
microcode	: 0xf
cpu MHz		: 2000.000
cache size	: 8192 KB
physical id	: 0
siblings	: 8
core id		: 2
cpu cores	: 4
apicid		: 4
initial apicid	: 4
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf pni dtes64 monitor ds_cpl ***vmx*** est tm2 ssse3 cx16 xtpr pdcm sse4_1 sse4_2 popcnt lahf_lm tpr_shadow vnmi flexpriority ept vpid dtherm ida
bugs		:
bogomips	: 6147.53
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
```


### Windows | Is Virtualization On or Off?

On Windows the **systeminfo** and/or the ***msinfo32*** commands come into play to ascertain whether virtualization is enabled in the BIOS.

Look for this line near the end of the below output.

<code>***Virtualization Enabled In Firmware: Yes***</code>


#### Sample Output from systeminfo

<pre>
Host Name:                 NEWDEVPC
OS Name:                   Microsoft Windows 10 Pro
OS Version:                10.0.14393 N/A Build 14393
OS Manufacturer:           Microsoft Corporation
OS Configuration:          Member Workstation
OS Build Type:             Multiprocessor Free
Registered Owner:          Hewlett-Packard Company
Registered Organization:   Hewlett-Packard Company
Product ID:                00330-50349-77921-AAOEM
Original Install Date:     17/01/2017, 08:38:56
System Boot Time:          11/04/2017, 17:25:34
System Manufacturer:       HP
System Model:              HP EliteDesk 800 G2 SFF
System Type:               x64-based PC
Processor(s):              1 Processor(s) Installed.
                           [01]: Intel64 Family 6 Model 94 Stepping 3 GenuineIntel ~3307 Mhz
BIOS Version:              HP N01 Ver. 02.17, 01/11/2016
Windows Directory:         C:\windows
System Directory:          C:\windows\system32
Boot Device:               \Device\HarddiskVolume1
System Locale:             en-ie;English (Ireland)
Input Locale:              en-ie;English (Ireland)
Time Zone:                 (UTC+00:00) Dublin, Edinburgh, Lisbon, London
Total Physical Memory:     16,265 MB
Available Physical Memory: 9,064 MB
Virtual Memory: Max Size:  18,697 MB
Virtual Memory: Available: 9,334 MB
Virtual Memory: In Use:    9,363 MB
Page File Location(s):     C:\pagefile.sys
Domain:                    mycompany.ie
Logon Server:              \\DOMUS
Hotfix(s):                 1 Hotfix(s) Installed.
                           [01]: KB3176938
Network Card(s):           2 NIC(s) Installed.
                           [01]: Intel(R) Ethernet Connection (2) I219-LM
                                 Connection Name: Ethernet
                                 DHCP Enabled:    Yes
                                 DHCP Server:     192.168.3.2
                                 IP address(es)
                                 [01]: 192.168.3.143
                                 [02]: fe80::a8f3:3b87:70ed:9100
                           [02]: VirtualBox Host-Only Ethernet Adapter
                                 Connection Name: VirtualBox Host-Only Network
                                 DHCP Enabled:    No
                                 IP address(es)
                                 [01]: 192.168.56.1
                                 [02]: fe80::5c06:794a:668d:8a3c
Hyper-V Requirements:      VM Monitor Mode Extensions: Yes
                           Virtualization Enabled In Firmware: Yes
                           Second Level Address Translation: Yes
                           Data Execution Prevention Available: Yes
</pre>

