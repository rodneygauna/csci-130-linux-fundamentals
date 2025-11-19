# CSCI-130 Linux Fundamentals - Week 13 (November 18, 2025) Lecture Notes

## Lecture Outline

- Attendance on Canvas
- Process management
- System Shutdown
- User management
  - Locking/unlocking user's account
  - Adding a new user
  - Deleting a user
  - Adding user to the sudo list
- The /proc file system
- Init levels

## Process Management

There are a few commands to manage processes in Linux:

- `ps`: Displays information about active processes.
- `top`: Provides a dynamic, real-time view of running processes.

### Singnals

Signals are a form of inter-process communication in Unix-like operating systems. They are used to notify processes of events. Some common signals include:

- `SIGTERM (15)`: Termination signal, requests a process to stop. (Ctrl + C)
- `SIGKILL (9)`: Kill signal, forcefully stops a process.
- `SIGSTOP (19)`: Stops a process. (Ctrl + Z)
- `SIGCONT (18)`: Continues a stopped process. (`fg` command)

### Viewing Processes

- `ps aux`: Lists all running processes with detailed information.
- `ps -ef`: Another format to list all running processes.
- `ps -u [username]`: Lists processes for a specific user.

Example output of `ps aux`:

```text
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME   COMMAND
root         1  0.0  0.1 225280  8328 ?        Ss   Nov17   0:04 /sbin/init
rodney-gauna  2345  0.1  1.2 1056784 123456 ?      S    Nov17   2:30 /usr/bin/python3 my_script.py
```

Let's use an example where you run a job that uses `sleep 1000` in the background 10 times:

```bash
for i in {1..10}; do sleep 1000 & done
```

You can view these processes using `ps -ef -u rodney-gauna | grep sleep`:

```text
rodney-gauna  3456  0.0  0.0  12345  6789 ?        S    Nov18   0:00 sleep 1000
rodney-gauna  3457  0.0  0.0  12345  6789 ?        S    Nov18   0:00 sleep 1000
rodney-gauna  3458  0.0  0.0  12345  6789 ?        S    Nov18   0:00 sleep 1000
rodney-gauna  3459  0.0  0.0  12345  6789 ?        S    Nov18   0:00 sleep 1000
rodney-gauna  3460  0.0  0.0  12345  6789 ?        S    Nov18   0:00 sleep 1000
...
rodney-gauna  3465  0.0  0.0  12345  6789 ?        S    Nov18   0:00 sleep 1000
```

### Stopping and Killing Processes

- `kill [PID]`: Sends a signal to a process to terminate it.
- `kill -9 [PID]`: Forcefully kills a process.
- `pkill [process_name]`: Kills processes by name.
- `killall [process_name]`: Kills all processes with the specified name.

In the example above, to kill one of the `sleep` processes, you can use:

```bash
kill 3456
```

You can also kill all `sleep` processes with:

```bash
pkill sleep
```

## System Shutdown

To shut down or reboot the system, you can use the following commands:

- `shutdown -h now`: Shuts down the system immediately.
- `shutdown -r now`: Reboots the system immediately.
- `halt`: Halts the system.
- `reboot`: Reboots the system.
- `poweroff`: Powers off the system.

What are the differences between these commands? Here are key points:

| Command        | Action                     | Notes                          |
|----------------|----------------------------|--------------------------------|
| `shutdown -h`  | Halts the system           | Can schedule shutdown          |
| `shutdown -r`  | Reboots the system         | Can schedule reboot            |
| `halt`         | Halts the system           | May not power off              |
| `reboot`       | Reboots the system         | Immediate reboot               |
| `poweroff`     | Powers off the system      | Immediate power off            |

### Use Case - Shutdown in 15 Minutes

To schedule a shutdown in 15 minutes, you can use:

```bash
shutdown -h +15 "System will shut down in 15 minutes. Please save your work."
```

### Use Case - Cancel Shutdown

To cancel a scheduled shutdown, use:

```bash
shutdown -c
```

### User Case - Logging out a user

To log out a specific user, you can use the `pkill -KILL -u [username]` command:

```bash
pkill -KILL -u rodney-gauna
```

### User Case - Logging yourself out

To log yourself out, you can use the `logout` command or press `Ctrl + D` in the terminal.

## User Management

User management in Linux involves creating, modifying, and deleting user accounts. Here are some common commands:

| Command               | Description                              |
|-----------------------|------------------------------------------|
| `adduser [username]`  | Adds a new user                          |
| `userdel [username]`  | Deletes a user                           |
| `usermod -L [username]` | Locks a user's account                  |
| `usermod -U [username]` | Unlocks a user's account                |
| `usermod -aG sudo [username]` | Adds a user to the sudo group         |
| `passwd [username]`   | Changes a user's password                |
| `chage -l [username]` | Lists password aging information        |

### Adding a user

To add a new user, use the `adduser` command:

```bash
sudo adduser newuser
```

This command will prompt you to set a password and fill in additional information for the new user.

### Deleting a user

To delete a user, use the `userdel` command:

```bash
sudo userdel newuser
```

You can also use the `-r` option to remove the user's home directory and mail spool:

```bash
sudo userdel -r newuser
```

### Locking a user's account

To lock a user's account, use the `usermod -L` command:

```bash
sudo usermod -L newuser
```

### Unlocking a user's account

To unlock a user's account, use the `usermod -U` command:

```bash
sudo usermod -U newuser
```

### Adding a user to the sudo group

The "sudo" group allows users to execute commands with superuser privileges.

To add a user to the sudo group, use the `usermod -aG sudo` command:

```bash
sudo usermod -aG sudo newuser
```

### Checking what groups a user belongs to

To check what groups a user belongs to, use the `groups` command:

```bash
groups newuser
```

### Find information about a group

To find information about a group, use the `getent group [groupname]` command:

```bash
getent group sudo
```

This will display information about the "sudo" group, including its GID and members.

Example output:

```text
sudo:x:27:newuser,anotheruser
```

This indicates that the "sudo" group has a GID of 27 and includes "newuser" and "anotheruser" as members.
GID stands for Group ID, which is a unique identifier for each group in the system.

### Removing a user from a group

To remove a user from a group, you can use the `gpasswd -d` command:

```bash
sudo gpasswd -d newuser sudo
```

It removes "newuser" from the "sudo" group.

### Adding a user to the sudoers file

To add a user to the sudoers file, you can use the `visudo` command, which safely edits the sudoers file. Open the sudoers file with:

```bash
sudo visudo
```

Then, add the following line at the end of the file:

```text
newuser ALL=(ALL:ALL) ALL
```

### Changing a user to have "nologin" shell

To change a user's shell to "nologin", which prevents them from logging in, use the `usermod -s /sbin/nologin` command:

```bash
sudo usermod -s /sbin/nologin newuser
```

### Changing the user to have "/bin/bash" shell

To change a user's shell to "/bin/bash", which allows them to use the Bash shell, use the `usermod -s /bin/bash` command:

```bash
sudo usermod -s /bin/bash newuser
```

### Setting password expiration

To set password expiration for a user, you can use the `chage` command. For example, to set a password to expire in 30 days:

```bash
sudo chage -M 30 newuser
```

You can do the same using a date. For example, to set the password to expire on December 31, 2025:

```bash
sudo chage -E 2025-12-31 newuser
```

## The /proc File System

The `/proc` file system is a virtual file system in Linux that provides a mechanism to access kernel and process information. It is mounted at `/proc` and contains a hierarchy of files and directories that represent the current state of the system.
Some important files and directories in `/proc` include:

| File/Directory       | Description                              |
|----------------------|------------------------------------------|
| `/proc/cpuinfo`      | Information about the CPU(s)             |
| `/proc/meminfo`      | Information about system memory          |
| `/proc/uptime`       | System uptime information                 |
| `/proc/[PID]`        | Directory containing information about a specific process (replace `[PID]` with the process ID) |
| `/proc/loadavg`      | System load average information              |
| `/proc/filesystems`  | List of supported file systems            |
| `/proc/mounts`       | List of currently mounted file systems   |

You can view the contents of these files using commands like `cat`, `less`, or `more`. For example, to view CPU information, you can use:

```bash
cat /proc/cpuinfo
```

## Init Levels

Init levels (or runlevels) are a concept in Unix-like operating systems that define the state of the machine after booting. Each runlevel corresponds to a specific mode of operation, such as single-user mode, multi-user mode, or graphical mode. The traditional SysV init system defines the following runlevels:

| Runlevel | Description                          |
|----------|--------------------------------------|
| 0        | Halt the system                      |
| 1        | Single-user mode (no networking)    |
| 2        | Multi-user mode without networking (no Network File System)   |
| 3        | Multi-user mode with networking      |
| 4        | Undefined (user-defined)             |
| 5        | Multi-user mode with graphical interface |
| 6        | Reboot the system                    |

Note: Modern Linux distributions often use `systemd` instead of SysV init, which uses "targets" instead of runlevels. However, the concept is similar.

To check the current runlevel, you can use the `runlevel` command:

```bash
runlevel
```

Example output:

```text
N 3
```

This indicates that the previous runlevel was "N" (none) and the current runlevel is "3" (multi-user mode with networking).

To change the runlevel, you can use the `init` command followed by the desired runlevel number. For example, to switch to runlevel 3:

```bash
sudo init 3
```

Alternatively, you can use the `telinit` command, which is a symbolic link to `init`:

```bash
sudo telinit 3
```

What is the difference between `init` and `telinit`? The `init` command is used to change the runlevel of the system directly, while `telinit` is a symbolic link to `init` that is specifically designed to change the runlevel. Here are some key differences:

| Command   | Description                              | Notes                          |
|-----------|------------------------------------------|--------------------------------|
| `init`    | Changes the runlevel of the system       | Directly invokes the init process |
| `telinit` | Changes the runlevel of the system       | Symbolic link to `init`, used for compatibility |
