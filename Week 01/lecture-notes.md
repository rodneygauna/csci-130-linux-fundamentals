# CSCI-130 Linux Fundamentals - Week 1 (August, 26, 2025) Lecture Notes

The course is an introduction to foundamental end-user skills and tools in Linux, designed for students with little or no command-line Linux or UNIX experience. Emphasis on shell script programming to create tools, applications and to automate routine functions.

The course instructor is [Vladimir Sverdlov](vsverdlov@plaomore.edu)

## Syllabus Review

Course topics will include:

- Introduction (logging in and logging out)
- File system and hierarchy, file permissions, archiving, moving, copying, and symbolic links.
- Editing files
- Filters and redirection
- Shell and basic shell scripting.
- Communications and archiving (ftp, telnet, SSH)
- Email
- Basic system administration:
  - User management
  - Asset management (disk partitioning, formatting, mounting)
  - Process scheduling (cron, at boot)
  - Package management (installation)
  - Network management (static and dynamic configuration, network up/down, system with multiple network cards, routing tables)
  - Firewalls
  - Samba
  - NFS
  - Linux RAID systems

Professor Sverdlov emphasised that the scripting is going to be minimal.

What not to expect:

- This is not a programming class. We will not learn how to write programs.
- We will not learn how to write complex shell scripts involving tests and decisions.
- This is not a system administration, networking, security, etc. course.

Not textbook is needed, but Professor Sverdlov did publish a book.
[Linux As No One Had Told You](https://www.amazon.com/Linux-One-Had-Told-You/dp/B08VCJ1MXP)

Attendance in important, present to the lectures and labs.

There are going to be two tests, the Mid-Term and Final.
There may be quizzes.
There will be class work and assignments, potentially including research essays.
Lastly, there will be a presentation assignment at the end of the course. The expectation is that the presentation is about five minutes per student.

Assignments are due before the next class and Professor Sverdlov grades them the following week. If you do not see a grade in two weeks, reach out to him as there might have been a problem with the submission in Canvas.

Professor Sverdlov spoke about how most students receive an A or B as final grades in most of this classes. He is willing to work with students that need help.

## Introduction to Linux

Linux is an open-source operating system that is widely used for servers, desktops, and embedded systems. It is known for its stability, security, and flexibility, making it a popular choice for developers and system administrators. Most Linux distributions are based on the Linux kernel, which was first released by Linus Torvalds in 1991. Since then, Linux has grown into a large ecosystem of software and tools, with contributions from thousands of developers around the world.

Most of the world's web servers run on Linux, and it is the operating system of choice for many cloud computing platforms. Linux is also widely used in scientific computing, data analysis, and machine learning, thanks to its powerful command-line tools and support for programming languages like Python and R.

Per [DistroWatch](https://distrowatch.com/dwres.php?resource=family-tree), there are over 300 active Linux distributions.

## Why Linux?

Linux offers several advantages that make it a preferred choice for many users and organizations:

1. **Open Source**: Linux is open-source software, which means its source code is freely available for anyone to view, modify, and distribute. This fosters a large community of developers and users who contribute to its improvement.
2. **Stability and Reliability**: Linux is known for its stability and reliability. It can run for long periods without crashing or requiring a reboot, making it ideal for servers and critical applications.
3. **Security**: Linux has a strong security model, with user permissions and access controls that help protect the system from unauthorized access and malware. Regular updates and a proactive community also contribute to its security.
4. **Flexibility**: Linux can be customized to meet the specific needs of users and organizations. There are many different distributions (distros) available, each with its own features and tools.
5. **Cost-Effective**: Most Linux distributions are free to use, which can significantly reduce software licensing costs for organizations.
6. **Strong Community Support**: Linux has a large and active community of users and developers who provide support, documentation, and resources for troubleshooting and learning.
7. **Compatibility**: Linux supports a wide range of hardware architectures and can run on everything from embedded devices to supercomputers.

These advantages make Linux a popular choice for a variety of use cases, from personal computing to enterprise-level server deployments.

## What do you expect from a modern Operating System (OS)?

Class participation offered the following categories:

- Usability
- Performance
- Security
- Compatibility
- Support
- Reliability

## Installation

Professor Sverdlov discussed the use of [VirtualBox](https://www.virtualbox.org/) to create a virtual machine for running Linux. He noted that he will be using Fedora Desktop as the guest operating system but we are welcome to use any Linux distribution of our choice.

## Post-Installation

Due to Professor Sverdlov's computer not having the right tools, he was not able to provide a live demostration. He did show a few screenshots from a Google search and encouraged us to explore the post-installation steps for our chosen Linux distribution.

## Linux File System

The Linux file system is a hierarchical directory structure that organizes files and directories in a tree-like format. The root directory is represented by a forward slash (/) and contains all other directories and files. Some key features of the Linux file system include:

Most Linux distributions follow the Filesystem Hierarchy Standard (FHS), which defines the directory structure and directory contents in Unix-like operating systems. Key directories include:

- `/`: The root directory. The top-level directory in the Linux file system hierarchy; all other directories branch from here.
- `/bin`: Essential user binaries. Contains fundamental command-line utilities and programs needed for basic system operation (e.g., `ls`, `cp`, `mv`, `cat`, `grep`).
- `/boot`: Boot loader files. Stores files required for booting the system, such as the Linux kernel, initial ramdisk (initrd), and bootloader configuration files.
- `/dev`: Device files. Contains special files that represent hardware devices (e.g., disks like `/dev/sda`, terminals like `/dev/tty`, USB devices).
- `/etc`: Configuration files. Holds system-wide configuration files and shell scripts used to boot and configure the system (e.g., `/etc/passwd`, `/etc/hosts`).
- `/home`: User home directories. Each user gets a subdirectory here for personal files, settings, and data (e.g., `/home/username`).
- `/lib`: Essential shared libraries. Contains shared library files required by programs in `/bin` and `/sbin` for basic system functionality.
- `/media`: Removable media devices. Temporary mount points for external devices like USB drives, CDs, and DVDs that are automatically mounted.
- `/mnt`: Mount point for temporary file systems. Used for mounting filesystems temporarily, often for system maintenance or manual mounting of devices.
- `/opt`: Optional application software packages. Used for installing third-party or additional software packages that don't fit into the standard directory structure.
- `/proc`: Virtual file system for process information. Provides a real-time interface to kernel and process information; not a real directory on disk but exists in memory.
- `/root`: Home directory for the root user. The superuser's personal directory, separate from other users and located outside `/home` for security reasons.
- `/run`: Runtime variable data. Stores volatile runtime data, such as process IDs and system information, that is cleared on reboot.
- `/sbin`: System binaries. Contains essential system administration binaries, typically used by the root user (e.g., `fdisk`, `mount`, `iptables`).
- `/srv`: Service data. Holds data for services provided by the system, such as web server files or FTP server content.
- `/sys`: Virtual file system for kernel information. Exposes kernel and hardware information; used for system management and configuration, similar to `/proc`.
- `/tmp`: Temporary files. Used for storing temporary files created by programs; often cleared on reboot and accessible to all users.
- `/usr`: User programs and data. Contains user applications, libraries, documentation, and other non-essential system files. Often the largest directory.
- `/var`: Variable data files. Stores files that change frequently, such as logs (`/var/log`), mail (`/var/mail`), print spool files, and caches.

Understanding the Linux file system is essential for navigating and managing files in a Linux environment.

## Navigating and Changing Directories

We reviewed a few commands for navigating the Linux file system.

### `pwd` Print Working Directory

The `pwd` command displays the current working directory, which is the directory you are currently in. This is useful for confirming your location within the file system.

Example:

```bash
$ pwd
/home/username
```

### `cd` Change Directory

The `cd` command is used to change the current directory. You can specify an absolute path (starting from the root directory) or a relative path (relative to the current directory).

Example:

```bash
$ cd /home/username/Documents
$ pwd
/home/username/Documents
```

Users can utilize absolute and relative paths to navigate the file system effectively. Absolute paths provide the complete directory structure from the root, while relative paths are based on the current directory, allowing for quicker navigation without typing the full path.

Examples of absolute and relative paths:

- Absolute path: `/home/username/Documents`
- Relative path: `Documents` (when in `/home/username`)

Scenarios:

Changing to a directory using an absolute path:

**Scenario 1** Navigating to the `/var/log` directory:

```bash
$ cd /var/log
$ pwd
/var/log
```

**Scenarion 2** Navigating to the `tmp` directory:

```bash
$ cd /tmp
$ pwd
/tmp
```

Changing to a directory using a relative path:

**Scenario 3** Navigating to the `Documents` directory from the `home` directory:

```bash
$ pwd
/home/username
$ cd ../username/Documents
$ pwd
/home/username/Documents
```

**Scenario 4** Navigating to the `Documents` directory from the `tmp` directory:

```bash
$ pwd
/tmp
$ cd ../username/Documents
$ pwd
/home/username/Documents
```

**Scenario 5** Navigating from the user's `Documents` directory to the `tmp` directory:

```bash
$ pwd
/home/username/Documents
$ cd ../../tmp
$ pwd
/tmp
```

The `cd -` command is a convenient way to switch back to the previous directory you were in. This can be particularly useful when you need to toggle between two directories frequently.

Example:

```bash
$ cd /var/log
$ pwd
/var/log
$ cd -
$ pwd
/home/username
```

Additionally, using `cd` without any arguments will take you back to your home directory.

Example:

```bash
$ cd /var/log
$ pwd
/var/log
$ cd
$ pwd
/home/username
```

## Assignment

Determine what Linux distribution you will be utilizing for the course. Professor Sverdlov recommended Fedora Workstation (which is what he will be using) or Ubuntu Desktop. We are free to choose what we want to use as the course's topics will be applicable to any Linux distribution. We can use a virtual machine (VM) or install it directly on our hardware (at our own discretion and risk). He also mentioned that using a VM can be a safer option for experimentation. Lastly, we can also use an emulator like WSL (Windows Subsystem for Linux) if we are on a Windows machine or an online linux terminal/emulator.

Professor Sverdlov will be posting an assignment on Canvas. There is no submission needed (no grade).
