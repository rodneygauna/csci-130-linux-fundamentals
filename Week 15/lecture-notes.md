# CSCI-130 Linux Fundamentals - Week 15 (December 2, 2025) Lecture Notes

## Lecture Outline

- Attendance on Canvas
- Making init level change permanent
- Downloading/removing packages
- Firewall with firewalld
- NFS setup
- Connection to remote server (ssh, ftp)

## Making init level change permanent

Why would you want to change the init level?
There are situations where you might want to change the default of a system's init (initualization) process. For example, you might want to boot into a non-graphical multi-user mode for a server environment or troubleshooting.

Professor Sverdlov went over the "runlevels" in `/lib/systemd/system/` by running the `ls -l /lib/systemd/system/runlevel[0-6].target` command.
You'll notice that these are symbolic links to the actual target files.

Here is an example of the output:

```text
Permissions Size User Date Modified Name
lrwxrwxrwx     - root 11 Jul 10:52  /lib/systemd/system/runlevel0.target -> poweroff.target
lrwxrwxrwx     - root 11 Jul 10:52  /lib/systemd/system/runlevel1.target -> rescue.target
lrwxrwxrwx     - root 11 Jul 10:52  /lib/systemd/system/runlevel2.target -> multi-user.target
lrwxrwxrwx     - root 11 Jul 10:52  /lib/systemd/system/runlevel3.target -> multi-user.target
lrwxrwxrwx     - root 11 Jul 10:52  /lib/systemd/system/runlevel4.target -> multi-user.target
lrwxrwxrwx     - root 11 Jul 10:52  /lib/systemd/system/runlevel5.target -> graphical.target
lrwxrwxrwx     - root 11 Jul 10:52  /lib/systemd/system/runlevel6.target -> reboot.target
```

You can change the default runlevel with the following command:

```bash
systemctl set-default multi-user.target
```

This change will make the system boot into the multi-user target by default, which is similar to the traditional runlevel 3 (multi-user, non-graphical).

Output:

```text
Removed '/etc/systemd/system/default.target'.
Created symlink /etc/systemd/system/default.target → /lib/systemd/system/multi-user.target.
```

## Downloading and Removing Packages

On Linux systems, a package is a collection of files and metadata that are bundled together to provide specific functionality or software. Packages are managed by package managers, which handle the installation, updating, and removal of software on the system.

For example, on Debian-based systems (like Ubuntu), the package manager is `apt`, while on Fedora, Red Hat, and CentOS, the package manager is `dnf` (or `yum` for older versions).

### Package Repositories

Package repositories are centralized locations where software packages are stored and maintained. These repositories are typically hosted by the Linux distribution maintainers or third-party organizations. When you use a package manager to install software, it retrieves the necessary packages from these repositories.

On Debian-based systems, the list of repositories is stored in the `/etc/apt/sources.list` file and additional files in the `/etc/apt/sources.list.d/` directory. On Red Hat-based systems, repository configurations are found in the `/etc/yum.repos.d/` directory.

#### Updating Package Lists

Before installing or updating packages, it's a good practice to update the package lists to ensure you have the latest information about available packages. You can do this with the following commands:

For Debian-based systems:

```bash
sudo apt update
```

For Red Hat-based systems:

```bash
sudo dnf check-update
```

#### Adding Repositories

To add a new repository, you typically need to create a new repository configuration file in the appropriate directory.

For Debian-based systems, you can add a new repository by adding a line to the `/etc/apt/sources.list` file or creating a new file in the `/etc/apt/sources.list.d/` directory.
For Fedora, you can add a new repository by creating a `.repo` file in the `/etc/yum.repos.d/` directory.

For example, to add Docker's official repository on a Fedora system, you would create a file named `docker.repo` with the following content:

```ini
[docker]
name=Docker Repository
baseurl=https://download.docker.com/linux/fedora/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg
```

For Debian-based systems, you can add a repository like this:

```bash
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
```

### Installing Packages

To install a package using `dnf`, you can use the following command:

```bash
sudo dnf install package_name
```

To install multiple packages at once, you can list them separated by spaces:

```bash
sudo dnf install package1 package2 package3
```

For Ubuntu/Debian systems, you would use:

```bash
sudo apt install package_name
```

In our example with Docker, you would install Docker Engine like this:

```bash
sudo dnf install docker-ce docker-ce-cli containerd.io
```

```bash
sudo apt install docker-ce docker-ce-cli containerd.io
```

### Removing Packages

To remove a package using `dnf`, you can use the following command:

```bash
sudo dnf remove package_name
```

To remove a package using `apt`, you can use the following command:

```bash
sudo apt remove package_name
```

If you want to remove the package along with its configuration files, you can use:

```bash
sudo apt purge package_name
```

## Firewall with firewalld

`firewalld` is a dynamic firewall management tool that provides a way to manage firewall rules on Linux systems. It uses zones and services to define the level of trust for network connections and allows you to easily configure firewall settings without needing to write complex iptables rules.

### What are zones?

Zones are predefined sets of rules that dictate what traffic is allowed. Each zone has a different level of trust. Some common zones include:

- **public**: For use in public areas. You don't trust other computers on the network.
- **home**: For use at home when you trust most computers on the network.
- **work**: For use at work when you trust most computers on the network.
- **dmz**: For computers in your demilitarized zone that are publicly accessible with limited access to your internal network.
- **internal**: For use on internal networks when you mostly trust the computers on the network.
- **trusted**: All network connections are accepted.
- **drop**: All incoming connections are dropped without reply.
- **block**: All incoming connections are rejected with an icmp-host-prohibited message.

### Managing firewalld Service

To manage the `firewalld` service, you can use the following commands:

| Command                               | Description                              |
|---------------------------------------|------------------------------------------|
| `sudo systemctl start firewalld`      | Start the firewalld service              |
| `sudo systemctl stop firewalld`       | Stop the firewalld service               |
| `sudo systemctl enable firewalld`     | Enable firewalld to start on boot       |
| `sudo systemctl disable firewalld`    | Disable firewalld from starting on boot |
| `sudo systemctl status firewalld`     | Check the status of firewalld           |
| `sudo systemctl restart firewalld`    | Restart the firewalld service           |

### Viewing Zones and Services

To view information about zones and services, use these commands:

```bash
# List all active zones
sudo firewall-cmd --get-active-zones

# List all available zones
sudo firewall-cmd --get-zones

# Get the default zone
sudo firewall-cmd --get-default-zone

# List all services allowed in the public zone
sudo firewall-cmd --zone=public --list-services

# List all open ports in the public zone
sudo firewall-cmd --zone=public --list-ports

# List everything allowed in a zone
sudo firewall-cmd --zone=public --list-all
```

Example output of `--get-active-zones`:

```text
public
  interfaces: eth0
```

Example output of `--zone=public --list-all`:

```text
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: eth0
  sources:
  services: cockpit dhcpv6-client ssh
  ports:
  protocols:
  forward: yes
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

### Adding and Removing Services

To allow or deny services through the firewall:

```bash
# Add a service to a zone (e.g., allow HTTP traffic)
sudo firewall-cmd --zone=public --add-service=http --permanent

# Add multiple services at once
sudo firewall-cmd --zone=public --add-service=http --add-service=https --permanent

# Remove a service from a zone
sudo firewall-cmd --zone=public --remove-service=http --permanent

# Reload firewalld to apply changes
sudo firewall-cmd --reload
```

**Note:** The `--permanent` flag makes the change persistent across reboots. Without it, the change only applies to the current session.

### Opening and Closing Ports

To open or close specific ports:

```bash
# Open a specific port (e.g., port 8080 for TCP)
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent

# Open a range of ports
sudo firewall-cmd --zone=public --add-port=5000-5010/tcp --permanent

# Remove a port
sudo firewall-cmd --zone=public --remove-port=8080/tcp --permanent

# Reload firewalld to apply changes
sudo firewall-cmd --reload
```

### Querying Firewall Rules

To check if a service or port is allowed:

```bash
# Check if a service is allowed in a zone
sudo firewall-cmd --zone=public --query-service=http

# Check if a port is open
sudo firewall-cmd --zone=public --query-port=8080/tcp
```

The command will return `yes` if allowed, or `no` if not.

### Changing the Default Zone

To set a different default zone:

```bash
# Set the default zone to home
sudo firewall-cmd --set-default-zone=home

# Verify the change
sudo firewall-cmd --get-default-zone
```

### Use Case Example: Setting up a Web Server

Let's say you want to set up a web server that allows HTTP and HTTPS traffic:

```bash
# Enable firewalld
sudo systemctl enable --now firewalld

# Allow HTTP and HTTPS services
sudo firewall-cmd --zone=public --add-service=http --permanent
sudo firewall-cmd --zone=public --add-service=https --permanent

# Reload to apply changes
sudo firewall-cmd --reload

# Verify the services are allowed
sudo firewall-cmd --zone=public --list-services
```

Expected output:

```text
cockpit dhcpv6-client http https ssh
```

## NFS Setup

NFS (Network File System) is a distributed file system protocol that allows a user on a client computer to access files over a network in a manner similar to how local storage is accessed. It was developed by Sun Microsystems in 1984 and is commonly used in Unix and Linux environments.

### Why use NFS?

NFS is useful when you need to:

- Share files between multiple Linux/Unix machines
- Centralize storage management
- Provide users with consistent home directories across multiple systems
- Share application data between servers
- Create network-accessible backup storage

### NFS Architecture

NFS uses a client-server architecture:

- **NFS Server**: The machine that hosts the shared directories
- **NFS Client**: The machine that mounts and accesses the shared directories

### Installing NFS

To set up NFS on your system, you need to install the necessary packages.

**On Fedora:**

```bash
sudo dnf install nfs-utils
```

**On Debian/Ubuntu:**

```bash
sudo apt install nfs-kernel-server
```

### Configuring the NFS Server

#### Step 1: Create a directory to share

```bash
sudo mkdir -p /srv/nfs/shared
```

#### Step 2: Set permissions for the shared directory

```bash
# Change ownership to nobody:nogroup (for security)
sudo chown nobody:nogroup /srv/nfs/shared

# Set appropriate permissions
sudo chmod 755 /srv/nfs/shared
```

**Why `nobody:nogroup`?** This prevents root users on NFS clients from having root access to the shared files, which is a security best practice.

#### Step 3: Configure the exports file

The `/etc/exports` file defines which directories are shared and who can access them.

```bash
sudo nano /etc/exports
```

Add entries to share directories. Here are some common examples:

```text
# Share to a specific subnet with read-write access
/srv/nfs/shared 192.168.1.0/24(rw,sync,no_subtree_check)

# Share to a specific IP address
/srv/nfs/shared 192.168.1.100(rw,sync,no_subtree_check)

# Share to multiple clients
/srv/nfs/shared 192.168.1.100(rw,sync) 192.168.1.101(rw,sync)

# Share with read-only access
/srv/nfs/readonly 192.168.1.0/24(ro,sync,no_subtree_check)
```

**Common NFS Export Options:**

| Option              | Description                                           |
|---------------------|-------------------------------------------------------|
| `rw`                | Read-write access                                     |
| `ro`                | Read-only access                                      |
| `sync`              | Write changes to disk before replying to requests     |
| `async`             | Write changes to disk asynchronously (faster but risky) |
| `no_subtree_check`  | Disable subtree checking (improves reliability)       |
| `no_root_squash`    | Allow root user on client to have root access         |
| `root_squash`       | Map root user to anonymous user (default, more secure) |
| `all_squash`        | Map all users to anonymous user                       |

#### Step 4: Export the shared directory

After editing `/etc/exports`, apply the changes:

```bash
# Export all directories listed in /etc/exports
sudo exportfs -a

# Verify the exports
sudo exportfs -v
```

Example output of `exportfs -v`:

```text
/srv/nfs/shared   192.168.1.0/24(rw,wdelay,root_squash,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)
```

#### Step 5: Start and enable the NFS server

```bash
# Start the NFS server
sudo systemctl start nfs-server

# Enable NFS server to start on boot
sudo systemctl enable nfs-server

# Check the status
sudo systemctl status nfs-server
```

#### Step 6: Configure the firewall

If you have `firewalld` enabled, you need to allow NFS traffic:

```bash
# Add NFS service to the firewall
sudo firewall-cmd --permanent --add-service=nfs
sudo firewall-cmd --permanent --add-service=rpc-bind
sudo firewall-cmd --permanent --add-service=mountd

# Reload the firewall
sudo firewall-cmd --reload

# Verify the services are allowed
sudo firewall-cmd --list-services
```

### Configuring the NFS Client

#### Step 1: Install NFS client utilities

**On Fedora:**

```bash
sudo dnf install nfs-utils
```

**On Debian/Ubuntu:**

```bash
sudo apt install nfs-common
```

#### Step 2: Create a mount point

```bash
sudo mkdir -p /mnt/nfs/shared
```

#### Step 3: Mount the NFS share

```bash
# Mount the NFS share
sudo mount -t nfs <server_ip>:/srv/nfs/shared /mnt/nfs/shared

# Example with actual IP
sudo mount -t nfs 192.168.1.50:/srv/nfs/shared /mnt/nfs/shared
```

Replace `<server_ip>` with the actual IP address of your NFS server.

#### Step 4: Verify the mount

```bash
# Check if the mount is successful
df -h /mnt/nfs/shared

# List the contents
ls -la /mnt/nfs/shared

# Check all NFS mounts
mount | grep nfs
```

Example output of `df -h`:

```text
Filesystem                      Size  Used Avail Use% Mounted on
192.168.1.50:/srv/nfs/shared    50G   10G   40G  20% /mnt/nfs/shared
```

### Making the NFS Mount Permanent

To ensure the NFS share is mounted automatically at boot, add an entry to `/etc/fstab`:

```bash
sudo nano /etc/fstab
```

Add the following line at the end of the file:

```text
192.168.1.50:/srv/nfs/shared /mnt/nfs/shared nfs defaults 0 0
```

**fstab NFS Options:**

You can customize the mount options in `/etc/fstab`. Here are some common options:

```text
# Basic mount with defaults
192.168.1.50:/srv/nfs/shared /mnt/nfs/shared nfs defaults 0 0

# Mount with specific options
192.168.1.50:/srv/nfs/shared /mnt/nfs/shared nfs rw,hard,intr 0 0

# Mount with timeout and retry options
192.168.1.50:/srv/nfs/shared /mnt/nfs/shared nfs defaults,timeo=900,retrans=5 0 0
```

**Common NFS Mount Options:**

| Option       | Description                                        |
|--------------|----------------------------------------------------|
| `defaults`   | Use default options (rw, suid, dev, exec, auto)   |
| `rw`         | Mount as read-write                                |
| `ro`         | Mount as read-only                                 |
| `hard`       | Retry requests until server responds (recommended) |
| `soft`       | Return error after timeout (can cause data loss)   |
| `intr`       | Allow interruption of NFS operations               |
| `timeo=n`    | Timeout in tenths of a second (default 600)        |
| `retrans=n`  | Number of retries before giving up                 |
| `noauto`     | Don't mount automatically at boot                  |

After editing `/etc/fstab`, test the configuration:

```bash
# Unmount the share if currently mounted
sudo umount /mnt/nfs/shared

# Mount all filesystems in /etc/fstab
sudo mount -a

# Verify the mount
df -h /mnt/nfs/shared
```

### Unmounting NFS Shares

To unmount an NFS share:

```bash
# Unmount the share
sudo umount /mnt/nfs/shared

# If the share is busy, find what's using it
sudo lsof /mnt/nfs/shared

# Force unmount (use with caution)
sudo umount -f /mnt/nfs/shared
```

### Troubleshooting NFS

#### Check NFS server is running

```bash
# On the server
sudo systemctl status nfs-server

# Check what's being exported
sudo exportfs -v

# Check NFS-related services
sudo systemctl status rpcbind
```

#### Check network connectivity

```bash
# Ping the server from client
ping <server_ip>

# Check if NFS port is accessible
telnet <server_ip> 2049
```

#### Check firewall rules

```bash
# On the server
sudo firewall-cmd --list-services
sudo firewall-cmd --list-ports

# Check if NFS is allowed
sudo firewall-cmd --query-service=nfs
```

#### View NFS statistics

```bash
# On the server
nfsstat -s

# On the client
nfsstat -c
```

## SSH (Secure Shell)

Connecting to remote servers allows you to work on other computers from your current machine. This is useful for managing servers, accessing files on other systems, or running commands remotely.

SSH (Secure Shell) is a secure way to connect to another computer over a network. It encrypts all communication, keeping your data and passwords safe. Think of it as a secure tunnel between two computers.

### Why use SSH?

- **Security**: Everything you type and see is encrypted
- **Remote access**: Work on another computer from anywhere
- **File transfer**: Copy files securely between computers
- **Remote commands**: Run programs on other computers

### Installing SSH

#### Installing SSH Client

Most Linux systems already have SSH installed. To check:

```bash
ssh -V
```

If you need to install it:

**On Fedora:**

```bash
sudo dnf install openssh-clients
```

**On Debian/Ubuntu:**

```bash
sudo apt install openssh-client
```

#### Installing SSH Server

If you want other people to connect to your computer, you need to install an SSH server:

**On Fedora:**

```bash
sudo dnf install openssh-server
```

**On Debian/Ubuntu:**

```bash
sudo apt install openssh-server
```

Start the SSH server:

```bash
# Start SSH
sudo systemctl start sshd

# Make it start automatically when computer boots
sudo systemctl enable sshd

# Check if it's running
sudo systemctl status sshd
```

### Connecting with SSH

To connect to another computer:

```bash
ssh username@remote_host

# Example with IP address
ssh rodney@192.168.1.100

# Example with domain name
ssh rodney@example.com
```

**First time connecting?** You'll see a security message:

```text
The authenticity of host '192.168.1.100 (192.168.1.100)' can't be established.
Are you sure you want to continue connecting (yes/no)?
```

Type `yes` and press Enter. This is normal for first-time connections.

**To disconnect:** Type `exit` and press Enter.

### Copying Files with SCP

SCP lets you copy files between computers securely.

```bash
# Copy a file TO the remote computer
scp myfile.txt username@remote_host:/home/username/

# Copy a file FROM the remote computer
scp username@remote_host:/home/username/file.txt ./

# Copy a whole directory
scp -r mydirectory username@remote_host:/home/username/
```

Example:

```bash
scp report.txt rodney@192.168.1.100:/home/rodney/documents/
```

### SSH Key Authentication (Optional)

Instead of typing your password every time, you can use SSH keys. Think of it like a special password file.

#### Step 1: Create your key

```bash
ssh-keygen -t rsa -b 4096
```

Press Enter for all the questions (uses default settings).

This creates two files:

- `~/.ssh/id_rsa` - Your private key (NEVER share this!)
- `~/.ssh/id_rsa.pub` - Your public key (safe to share)

#### Step 2: Copy your key to the remote computer

```bash
ssh-copy-id username@remote_host

# Example
ssh-copy-id rodney@192.168.1.100
```

Enter your password one last time.

#### Step 3: Connect without password

```bash
ssh username@remote_host
```

Now you can connect without typing your password!

### Using SFTP (Secure File Transfer)

SFTP is like FTP but uses SSH for security. It's already available if you have SSH installed.

To start an SFTP session:

```bash
sftp username@remote_host

# Example
sftp rodney@192.168.1.100
```

**Common SFTP commands:**

| Command              | Description                                |
|----------------------|--------------------------------------------|
| `ls`                 | List files on remote computer              |
| `lls`                | List files on your computer                |
| `cd directory`       | Change directory on remote computer        |
| `lcd directory`      | Change directory on your computer          |
| `get filename`       | Download a file                            |
| `put filename`       | Upload a file                              |
| `exit`               | Quit SFTP                                  |

Example SFTP session:

```bash
sftp rodney@192.168.1.100
```

```text
Connected to 192.168.1.100.
sftp> ls
file1.txt    file2.txt    documents/
sftp> get file1.txt
Fetching /home/rodney/file1.txt to file1.txt
sftp> put myfile.txt
Uploading myfile.txt to /home/rodney/myfile.txt
sftp> exit
```

### Allowing SSH Through the Firewall

If you have a firewall enabled, you need to allow SSH connections:

```bash
# Allow SSH through firewall
sudo firewall-cmd --permanent --add-service=ssh

# Apply the changes
sudo firewall-cmd --reload

# Check if it worked
sudo firewall-cmd --list-services
```

## FTP (File Transfer Protocol)

FTP (File Transfer Protocol) is an older method for transferring files between computers. **Important: FTP is NOT secure** - it sends passwords and data without encryption, so anyone can see them. For this reason, most people use SFTP (which we covered above) instead.

### Why learn about FTP?

Even though FTP isn't secure, you might encounter it:

- Some older systems still use it
- Internal networks where security is less critical
- Learning about FTP helps you understand why SFTP is better

**Recommendation:** Use SFTP instead of FTP whenever possible!

### Installing an FTP Server

If you need to set up an FTP server, we'll use `vsftpd` (Very Secure FTP Daemon):

**On Fedora:**

```bash
sudo dnf install vsftpd
```

**On Debian/Ubuntu:**

```bash
sudo apt install vsftpd
```

Start the FTP server:

```bash
# Start FTP
sudo systemctl start vsftpd

# Make it start automatically when computer boots
sudo systemctl enable vsftpd

# Check if it's running
sudo systemctl status vsftpd
```

### Basic FTP Server Configuration

Edit the FTP configuration file:

```bash
sudo nano /etc/vsftpd.conf
```

**Important settings to change:**

```text
# Don't allow anonymous users (for security)
anonymous_enable=NO

# Allow local users to login
local_enable=YES

# Allow users to upload files
write_enable=YES
```

After making changes, restart FTP:

```bash
sudo systemctl restart vsftpd
```

### Allowing FTP Through the Firewall

If you have a firewall enabled, you need to allow FTP connections:

```bash
# Allow FTP through firewall
sudo firewall-cmd --permanent --add-service=ftp

# Apply the changes
sudo firewall-cmd --reload

# Check if it worked
sudo firewall-cmd --list-services
```

### Using an FTP Client

To connect to an FTP server from your computer:

```bash
ftp remote_host

# Example
ftp 192.168.1.100
```

You'll be prompted for a username and password.

**Common FTP commands:**

| Command           | Description                     |
|-------------------|---------------------------------|
| `ls`              | List files on remote computer   |
| `cd directory`    | Change directory on remote      |
| `lcd directory`   | Change directory on your computer |
| `get filename`    | Download a file                 |
| `put filename`    | Upload a file                   |
| `delete filename` | Delete a file                   |
| `mkdir dirname`   | Create a directory              |
| `bye` or `quit`   | Exit FTP                        |

Example FTP session:

```bash
ftp 192.168.1.100
```

```text
Connected to 192.168.1.100.
220 Welcome to FTP server
Name: rodney
331 Please specify the password.
Password:
230 Login successful.
ftp> ls
200 PORT command successful.
150 Here comes the directory listing.
-rw-r--r--    1 1000     1000         1234 Dec 02 10:00 file1.txt
-rw-r--r--    1 1000     1000         5678 Dec 02 11:00 file2.txt
drwxr-xr-x    2 1000     1000         4096 Dec 02 12:00 documents
226 Directory send OK.
ftp> get file1.txt
200 PORT command successful.
150 Opening BINARY mode data connection for file1.txt (1234 bytes).
226 Transfer complete.
1234 bytes received in 0.01 seconds
ftp> put myfile.txt
200 PORT command successful.
150 Ok to send data.
226 Transfer complete.
ftp> bye
221 Goodbye.
```

### Using a Browser as an FTP Client

You can also use a web browser to access FTP servers. Just type the FTP address in the address bar:

```text
ftp://username@remote_host
```

You can also do it SFTP by using:

```text
sftp://username@remote_host
```

### FTP vs SFTP Comparison

| Feature          | FTP                  | SFTP                 |
|------------------|----------------------|----------------------|
| **Security**     | Not encrypted ❌     | Encrypted ✅         |
| **Setup**        | Needs FTP server     | Uses SSH (already have it) |
| **Port**         | Port 21              | Port 22 (SSH)        |
| **Speed**        | Slightly faster      | Slightly slower      |
| **Best for**     | Internal networks    | Internet connections |

### Security Warning

Remember: **FTP sends your password in plain text!** Anyone monitoring network traffic can see:

- Your username and password
- All files you transfer
- Everything you type

**Always use SFTP instead of FTP when connecting over the internet!**
