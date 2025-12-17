# CSCI-130 Linux Fundamentals - Week 16 (December 9, 2025) Lecture Notes

## Lecture Outline

- Class Presentations
- Partitions
- The `dd` command

## Partitions

A partition is like dividing a hard drive into separate sections. Think of it like dividing a filing cabinet into different drawers - each drawer (partition) can store different types of files and be organized differently.

### Why use partitions?

- **Organization**: Keep different types of data separate (like keeping your system files separate from your personal files)
- **Safety**: If one partition has problems, the others are usually safe
- **Performance**: Different partitions can be optimized for different uses
- **Multiple operating systems**: You can have Windows on one partition and Linux on another

### Common partitions in Linux

When you install Linux, you typically create these partitions:

| Partition | Purpose                                              | Typical Size      |
|-----------|------------------------------------------------------|-------------------|
| `/`       | Root partition - holds the entire system             | 20-50 GB          |
| `/boot`   | Boot files needed to start the computer              | 500 MB - 1 GB     |
| `/home`   | Your personal files and settings                     | Remaining space   |
| `swap`    | Virtual memory (used when RAM is full)               | 2-8 GB            |

**Simple approach:** You can just have one `/` (root) partition and a swap partition. This works fine for personal computers.

**Better approach:** Separate `/`, `/boot`, `/home`, and swap. This protects your personal files if you need to reinstall Linux.

### Partition schemes: MBR vs GPT

There are two ways to organize partitions on a disk:

#### MBR (Master Boot Record) - The Old Way

- **Maximum disk size**: 2 TB
- **Maximum partitions**: 4 primary partitions (or 3 primary + 1 extended with multiple logical partitions)
- **Best for**: Older computers and smaller disks

#### GPT (GUID Partition Table) - The Modern Way

- **Maximum disk size**: Over 9 billion TB (essentially unlimited)
- **Maximum partitions**: 128 partitions
- **Best for**: Modern computers and larger disks

**Which should you use?** If your computer was made after 2010, use GPT. It's more reliable and flexible.

### Viewing your partitions

To see what partitions you have:

```bash
# Simple view of all disks and partitions
lsblk

# Detailed information
sudo fdisk -l
```

Example output of `lsblk`:

```text
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0 500G  0 disk
├─sda1   8:1    0   1G  0 part /boot
├─sda2   8:2    0  50G  0 part /
├─sda3   8:3    0 440G  0 part /home
└─sda4   8:4    0   8G  0 part [SWAP]
```

This shows:

- **sda**: Your main hard drive (500 GB total)
- **sda1**: Boot partition (1 GB) mounted at `/boot`
- **sda2**: Root partition (50 GB) mounted at `/`
- **sda3**: Home partition (440 GB) mounted at `/home`
- **sda4**: Swap partition (8 GB)

### Understanding disk names

Linux names disks and partitions in a specific way:

- **sda**: First hard drive (SATA or SCSI)
- **sdb**: Second hard drive
- **sdc**: Third hard drive
- **nvme0n1**: First NVMe SSD drive
- **sda1, sda2**: Partitions on the first drive

### Creating partitions with fdisk

**Warning:** Creating partitions can erase data! Only do this on new or backup drives.

```bash
# Start fdisk on a disk (replace X with your disk letter)
sudo fdisk /dev/sdX
```

**Common fdisk commands:**

| Command | Action                           |
|---------|----------------------------------|
| `m`     | Show help menu                   |
| `p`     | Print partition table            |
| `n`     | Create a new partition           |
| `d`     | Delete a partition               |
| `t`     | Change partition type            |
| `w`     | Write changes and exit           |
| `q`     | Quit without saving              |

### Basic steps to create a partition

1. **Start fdisk:**

   ```bash
   sudo fdisk /dev/sdb
   ```

2. **Create new partition:**
   - Press `n` for new partition
   - Choose `p` for primary (or `e` for extended)
   - Enter partition number (1-4)
   - Accept default first sector (press Enter)
   - Enter size (like `+10G` for 10 gigabytes) or accept default for remaining space

3. **Save changes:**
   - Press `w` to write changes

4. **Format the partition:**

   ```bash
   # Format as ext4 (most common Linux filesystem)
   sudo mkfs.ext4 /dev/sdb1
   ```

5. **Mount the partition:**

   ```bash
   # Create a directory to mount to
   sudo mkdir /mnt/mydata

   # Mount the partition
   sudo mount /dev/sdb1 /mnt/mydata
   ```

### Making mounts permanent

To automatically mount a partition when the computer starts, add it to `/etc/fstab`:

```bash
sudo nano /etc/fstab
```

Add a line like this:

```text
/dev/sdb1    /mnt/mydata    ext4    defaults    0    2
```

**Format explanation:**

- `/dev/sdb1`: The partition to mount
- `/mnt/mydata`: Where to mount it
- `ext4`: The filesystem type
- `defaults`: Use default mount options
- `0`: Don't dump (backup) - usually 0
- `2`: Check filesystem order - 0 for swap, 1 for root, 2 for others

### Swap partition

Swap is like extra memory on your hard drive. When your RAM is full, Linux moves some data to swap.

**How much swap do you need?**

| RAM Size   | Swap Size Recommendation |
|------------|--------------------------|
| < 2 GB     | 2x RAM                   |
| 2-8 GB     | Same as RAM              |
| > 8 GB     | 4-8 GB (or same as RAM if you hibernate) |

**Check your swap:**

```bash
# See swap usage
free -h

# See swap partitions
swapon --show
```

**Create and enable swap:**

```bash
# Create swap on a partition
sudo mkswap /dev/sdb1

# Enable the swap
sudo swapon /dev/sdb1

# Make it permanent (add to /etc/fstab)
echo '/dev/sdb1 none swap sw 0 0' | sudo tee -a /etc/fstab
```

### Checking disk space

To see how much space you're using:

```bash
# See disk usage by partition
df -h

# See disk usage by directory
du -sh /home/*
```

Example output:

```text
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2        50G   20G   28G  42% /
/dev/sda1       974M  128M  779M  15% /boot
/dev/sda3       440G  200G  218G  48% /home
```

### Common partition issues

#### Problem: "No space left on device"

- Check with `df -h` to see which partition is full
- Clean up unnecessary files
- Move files to a different partition with more space

#### Problem: "Can't mount partition"

- Check if partition exists with `lsblk`
- Check if mount point directory exists
- Check `/etc/fstab` for typos
- Try mounting manually first: `sudo mount /dev/sdX1 /mnt/test`

#### Problem: "Permission denied" on mounted partition

- Check ownership: `ls -ld /mnt/mountpoint`
- Change permissions: `sudo chown username:username /mnt/mountpoint`

## The `dd` Command

The `dd` command is a powerful tool for copying and converting data at a low level. It can be used for tasks like creating disk images, backing up partitions, and writing data directly to disks.

Warning: Be very careful with `dd`, as it can overwrite data irreversibly.

### Basic Syntax

```bash
dd if=<input_file> of=<output_file> [options]
```

- `if=`: Input file (source)
- `of=`: Output file (destination)
- `[options]`: Additional options like block size, count, etc.
