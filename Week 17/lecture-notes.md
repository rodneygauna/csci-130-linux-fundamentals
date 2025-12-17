# CSCI-130 Linux Fundamentals - Week 17 (December 16, 2025) Lecture Notes

## Lecture Outline

- SSH
- Copy files between local and remote machines: rsync and scp
- Working with the network cards
  - Assigning an IP address
  - Virtual network card
  - Bringing the network device up and down
- The ping command
- Compression tool (tar)
- Class Presentations
- Final (Test)

## SSH (Secure Shell)

SSH stands for Secure Shell, a protocol used to securely access and manage remote computers over a network. It provides a secure channel over an unsecured network by using encryption techniques. The most common use of SSH is to log into a remote machine and execute commands. It is widely used by system administrators and developers for remote server management.

To connect to a remote machine using SSH, you can use the following command in your terminal:

```bash
ssh username@remote_host
```

Replace `username` with your actual username on the remote machine and `remote_host` with the IP address or domain name of the remote machine.

Note: SSH requires that the SSH server is running on the remote machine and that you have the necessary permissions to access it. The default port for SSH is 22, but it can be configured to use a different port for added security.

### SSH Key-Based Authentication

SSH key-based authentication is a more secure and convenient way to log into a remote machine without using passwords. It involves generating a pair of cryptographic keys: a private key (kept on your local machine) and a public key (placed on the remote machine).

To generate an SSH key pair, you can use the following command:

```bash
ssh-keygen
```

This command will prompt you to specify the location to save the keys and optionally set a passphrase for added security.

After generating the keys, you need to copy the public key to the remote machine using the `ssh-copy-id` command:

```bash
ssh-copy-id username@remote_host
```

## Copy files between local and remote machines: rsync and scp

It's important to know how to transfer files between your local machine and a remote server. Two common tools for this purpose are `scp` (secure copy) and `rsync` (remote sync).

`rsync` is a powerful tool that allows you to synchronize files and directories between two locations over a secure SSH connection. It only transfers the differences between the source and destination, making it efficient for large file transfers.

`scp` is a simpler tool that copies files and directories over SSH. It is straightforward to use for quick file transfers.

### `rsync`

The basic syntax for `rsync` is as follows:

```bash
rsync [options] source destination
```

Example usage:

```bash
# Copy a file from local to remote
rsync -avz /path/to/local/file user@remote_host:/path/to/remote/file
# Copy a directory from local to remote
rsync -avz /path/to/local/directory/ user@remote_host:/path/to/remote/directory/
```

In the above examples:

- `-a` stands for "archive" mode, which preserves file permissions and timestamps.
- `-v` enables verbose output, showing the progress of the transfer.
- `-z` enables compression during transfer, which can speed up the process for large files

To copy files from remote to local, simply reverse the source and destination paths.

```bash
# Copy a file from remote to local
rsync -avz user@remote_host:/path/to/remote/file /path/to/local/file
```

### `scp`

The basic syntax for `scp` is as follows:

```bash
scp [options] source destination
```

Example usage:

```bash
# Copy a file from local to remote
scp /path/to/local/file user@remote_host:/path/to/remote/file
# Copy a directory from local to remote
scp -r /path/to/local/directory/ user@remote_host:/path/to/remote/directory/
```

In the above examples:

- `-r` stands for "recursive", which is necessary when copying directories.

To copy files from remote to local, simply reverse the source and destination paths.

```bash
# Copy a file from remote to local
scp user@remote_host:/path/to/remote/file /path/to/local/file
```

## Working with the network cards

When working with network cards in Linux, you may need to assign IP addresses, create virtual network interfaces, and manage the state of your network devices.

You can use the `ifconfig` command to manage network interfaces.

Example outputs:

```bash
# Show all network interfaces and their details
$ ifconfig
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
      inet 192.168.1.100  netmask 255.255.255.0  broadcast 192.168.1.255
      inet6 fe80::a00:27ff:fe4e:66a1  prefixlen 64  scopeid 0x20<link>
      ether 08:00:27:4e:66:a1  txqueuelen
      RX packets 123456  bytes 12345678 (12.3 MB)
      RX errors 0  dropped 0  overruns 0  frame 0
      TX packets 654321  bytes 87654321 (87.6 MB)
      TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

### Assigning an IP address

Assigning a static IP address to a network interface can be done using the `ifconfig` command.

To assign a static IP address to a network interface, you can use the following command:

```bash
sudo ifconfig eth0 192.168.1.100 netmask 255.255.255.0 up
```

### Virtual network card

You can create virtual network interfaces to simulate multiple network cards on a single physical interface. This is useful for testing and network configuration.

To create a virtual network interface, you can use the `ifconfig` command:

```bash
sudo ifconfig eth0:1 192.168.1.101 netmask 255.255.255.0 up
```

### Bringing the network device up and down

To bring a network interface up or down, you can use the following commands:

```bash
# Bring the interface up
sudo ifconfig eth0 up
# Bring the interface down
sudo ifconfig eth0 down
```

### Stopping all network interfaces

To stop all network interfaces, you can use the following command:

```bash
sudo ifconfig -a down
```

Or, you can also stop the NetworkManager service:

```bash
sudo systemctl stop NetworkManager
```

You can then start it again with:

```bash
ifconfig -a up
```

```bash
sudo systemctl start NetworkManager
```

## The `ping` command

The `ping` command is used to test the reachability of a host on a network and to measure the round-trip time for messages sent from the originating host to a destination computer.

Example usage:

```bash
$ ping google.com
PING google.com (142.250.190.78): 56 data bytes
64 bytes from 142.250.190.78: icmp_seq=0 ttl=115 time=14.2 ms
64 bytes from 142.250.190.78: icmp_seq=1 ttl=115 time=14.0 ms
...
^C
--- google.com ping statistics ---
10 packets transmitted, 10 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 14.0/14.1/14.2/0.1 ms
```

The output shows the response time for each packet sent to the destination. You can stop the ping command by pressing `Ctrl + C`.

## Compression tool (tar)

The `tar` command is used to create and manipulate archive files in Linux. It can combine multiple files and directories into a single archive file, which can be compressed to save space.

### Creating a tar archive

To create a tar archive, you can use the following command:

```bash
tar -cvf archive_name.tar /path/to/directory_or_file
```

In the above command:

- `-c` stands for "create" a new archive.
- `-v` stands for "verbose", which shows the progress of the operation.
- `-f` specifies the name of the archive file.

### Extracting a tar archive

To extract a tar archive, you can use the following command:

```bash
tar -xvf archive_name.tar
```

In the above command:

- `-x` stands for "extract" the contents of the archive.
- `-v` stands for "verbose", which shows the progress of the operation.
- `-f` specifies the name of the archive file.
