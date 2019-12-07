
# Unique Identifiers in Ubuntu

## Bootup Identifier | From Boot to Shutdown

If you need to know whether a Linux computer has been rebooted or you need an identifier that stays the same until the computer reboots, look no further than the read only (non sudoer accessible) **boot id**. The boot ID is a (hyphenated) unversal and unique UUID thus providing us with a robust quality guarantee.

```bash
cat /proc/sys/kernel/random/boot_id
```

The contract that Linux honours is that **the boot id is always**

- the **same** between a bootup/shutdown time span
- **different** after the machine reboots

You can read the boot id in Ruby this way.

```ruby
    # @return [String] the bootup ID hash value
    def self.get_bootup_id

      bootup_id_cmd = "cat /proc/sys/kernel/random/boot_id"
      bootup_id_str = %x[ #{bootup_id_cmd} ]
      return bootup_id_str.chomp

    end
```

# Bootup Identifier History

Using proc will give you the current boot identifier but if you want history then check out **journalctl**.

```bash
journalctl --list-boots
```

Not only does it tell you the IDs, it also lists the corresponding times when the machine started up and shut down.


## The Machine Identifier | CPU and MotherBoard

The machine identifier is a UUID based hash value that is tied to the CPU and motherboard of the machine. This read-only identifier can be accessed without sudoer permissions so is perfect for license generators and environment sensitive software.

```bash
cat /etc/machine-id
```

This machine ID is a also a unversal and unique UUID (although non-hyphenated) which again provides a guarantee of being both unique and hard to reproduce.

You can read the machine id in Ruby this way.

```ruby
    # @return [String] the machine ID hash value
    def self.get_machine_id

      machine_id_cmd = "cat /etc/machine-id"
      machine_id_str = %x[ #{machine_id_cmd} ]
      return machine_id_str.chomp

    end
```

Here are more ways of generating machine IDs but they require super user permissions.

```bash
sudo dmidecode | grep -i uuid
sudo cat /sys/class/dmi/id/board_serial
sudo dmidecode -s system-uuid
```

## Hard Drive Block ID | blkid

**blkid** provides hard disk UUIDs in a no-nonsense manner.

The first command uses regular expressions to retrieve just the UUID per line for each disk drive.

```bash
$ blkid | grep -oP 'UUID="\K[^"]+'
345fdg-SD34-xxxxxxxxxxxxxx
535cabad-1234-xxxx-xxxx-xxxxxxxxxx
abcdefghijk-xxxx-xxxx-xxxx-xxxxxxxxxx
$ blkid
/dev/mapper/nabc123445vm: UUID="sd4SD-SD42-s24f-sf4H-s4Py-sdWf-LI03ss4V" TYPE="LVM2_member"
/dev/mapper/ubuntu--vg-root: UUID="5e35ff33-0baf-44ac-9dee-12341234abcdabcd" TYPE="ext4"
$ sudo blkid -po udev /dev/mapper/ubuntu--vg-root
```

Don't forget to replace the device name above to retrieve drilled down details.


## dmidecode | Database of Installed Components

A rich source of unique identifiers flows from **dmidecode** which can access the system's database of installed hardware components.

Needing sudoer permissions is the key downside to using dmidecode assuming that you want to script the commands.

```bash
$ sudo dmidecode -t 4 | grep ID | sed 's/.*ID://;s/ //g'  # cpu (microprocessor) id
F08FF33DF222A46DDa
```


## fdisk | Retrieve Drive Identifiers

fdisk can retrieve the drive identifiers, but, like dmidecode, it requires sudoer permissions.

```bash
sudo fdisk -l | grep -i "Disk identifier" | awk '{print $3}'
A12341234-SS33-4SS3-435S-CA9898FDE23
```


## Derive Network Identifiers

This ruby script picks up the UUID and slices off the digits representing the network.

The returned digits will always be the same for a given network instance.

### Laptop | From Home to Work 

If the digits were generated on your laptop at home and then you travelled to work - they are likely to change due to the change in wireless and wired networks.

```ruby
    NETWORK_ID_LENGTH = 12

    def self.derive_network_identity

      require 'uuid'

      the_uuid = UUID.new.generate

      too_short = the_uuid.length <= NETWORK_ID_LENGTH
      raise RuntimeError, "Unexpected UUID format [#{the_uuid}]" if too_short

      net_id_chunk = the_uuid[ (the_uuid.length - NETWORK_ID_LENGTH) .. -1 ]
      perfect_size = net_id_chunk.length == NETWORK_ID_LENGTH
      size_err_msg = "Expected [ #{net_id_chunk} ] net ID length of #{NETWORK_ID_LENGTH}."
      raise RuntimeError,size_err_msg unless perfect_size

      return net_id_chunk

    end
```

## Derive Network IP Address Digits

This ruby script picks up the IP Address of the machine on the network. It is susceptible to the laptop home to work scenario thus changin in a manner that may not be desirable. Also its operation within a docker container or vagrant/virtualbox machine has not been verified.

The returned IP address digits will always be the same on the same network.

### Laptop | From Home to Work 

If the digits were generated on your laptop at home and then you travelled to work - they are likely to change due to the change in wireless and wired networks.

```ruby
    # This method will return the first readable non loopback (127.0.0.1)
    # IP address if the bolean {ip_address_readable?} returns true.
    #
    # @return [String]
    #    the first sensible non-loopback IP address which we know to exist.
    #
    # @raise RuntimeError if the IP address that we have on good authority exists, does not.
    def self.get_net_address_digits

      ip_addresses = get_address_list()
      ip_addresses.each do |candidate_address|
        return candidate_address.to_alphanumeric unless candidate_address.eql?( "127.0.0.1" )
      end
      raise RuntimeError, "Was led to expect at least one readable IP address."

    end
```

## The User Identifier

There are a few user IDs in Linux that are of limited use but come in handy when users must be distinguished from each other.

```bash
id <<username>>
echo $USER
echo $USERNAME
echo $EUID
```


## DIY Identifiers | Generating Your Own

Try **uuidgen** if you must do it yourself and generate your own identifier at the Linux shell.

There are a few user IDs in Linux that are of limited use but come in handy when users must be distinguished from each other.

```bash
uuidgen
```

## Summary | Virtual Machines

In the modern era of virtualization you should always check the behaviour of the above identifiers when used inside

- docker containers
- Amazon EC2 servers (or Azure or GCE)
- vagrant (VirtualBox/VMWare)
- Windows MSGYWIN (Ubuntu) environments
- Kubernetes pods
