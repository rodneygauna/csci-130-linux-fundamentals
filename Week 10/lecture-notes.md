# CSCI-130 Linux Fundamentals - Week 10 (October 28, 2025) Lecture Notes

## Lecture Outline

- Attendance on Canvas
- Running and testing a simple script
- Crude job scheduling with the cron
- Links
  - Symbolic links
  - Hard links
  - Using hard links for incremental backups
- Running jobs on a background
- Named pipes

## Running and Testing a Simple Script

Professor Sverdlov started by demonstrating a command that you might run once a month. His example:

```bash
find /home -atime +30 -exec du -s '{}' \; 2>/dev/null | sort -nr | head -5
```

This command finds files on the home directory that have not been accessed in the last 30 days, calculates their disk usage, sorts them in descending order, and displays the top results. The `2>/dev/null` part suppresses error messages.

Command breakdown:

- `find /home -atime +30`: Finds files in `/home` not accessed in the last 30 days.
- `-exec du -s '{}' \;`: For each found file, executes `du -s` to get its size.
- `2>/dev/null`: Redirects error messages to `/dev/null`.
- `| sort -nr`: Sorts the output numerically in reverse order.
- `| head -5`: Displays the top 5 results.

Next, we started to turn the example command into a script. We did the following steps:

1. Created a new script file named `du_script.sh` using the `cat` command.
2. Add the shebang line `#!/usr/bin/bash` at the top of the script to specify the interpreter. This line tells the system to use the Bash shell to execute the script.
3. Pasted the example command into the script.
4. Ended the input with `^D` (Ctrl + D) to save and exit the `cat` command.
5. Made the script executable using the `chmod +x du_script.sh` command.
6. Ran the script with `./du_script` to see the output.

Let's modify the script so that the output is saved to a file instead of being displayed on the terminal. We can do this by redirecting the output to a file using the `>` operator. For example, we can change the last part of the command in the script to:

```bash
find /home -atime +30 -exec du -s '{}' \; 2>/dev/null | sort -nr | head -5 > /home/user/mysearch.log
```

This will save the output to `mysearch.log` in the user's home directory.

## Crude Job Scheduling with the cron

To automate the execution of our script, we can use `cron`, a time-based job scheduler in Unix-like operating systems.
`cron` allows users to schedule scripts or commands to run at specified times and intervals.

```bash
$ ls -l /etc/cron*
cron.d/
cron.daily/
cron.deny
cron.hourly/
cron.monthly/
crontab
cron.weekly/
```

Let's explain the directories and files related to `cron`:

- `cron.d/`: Directory for system-wide cron jobs.
- `cron.daily/`: Directory for scripts that run daily.
- `cron.deny`: File that lists users who are not allowed to use `cron`.
- `cron.hourly/`: Directory for scripts that run hourly.
- `cron.monthly/`: Directory for scripts that run monthly.
- `crontab`: File that contains user-specific cron jobs.
- `cron.weekly/`: Directory for scripts that run weekly.

Professor Sverdlov talked about changing to the root user to move the script to the cron.daily directory so that it runs automatically every day. Althrough, he talked about how copying the script may not be synced if the original script is updated. Therefore, he suggested using symbolic links instead. Before we continued scheduling the job, we explored links in Linux.
You can see where we left off in the [Cron Job Scheduling Continued](#cron-job-scheduling-continued) section.

## Links

In Linux, there are two types of links: symbolic links (soft links) and hard links.

### Symbolic Links

A symbolic link is a special type of file that points to another file or directory. It acts as a shortcut to the target file. You can create a symbolic link using the `ln -s` command. Using the script we created, we can create a symbolic link to it as follows:

```bash
ln -s /home/user/du_script.sh /etc/cron.daily/du_script.sh
```

This command creates a symbolic link named `du_script.sh` in the `/etc/cron.daily/` directory that points to the original script located at `/home/user/du_script.sh`.

```bash
$ ls -l /etc/cron.daily/
lrwxrwxrwx 1 root root   29 Oct 28 10:00 du_script.sh -> /home/user/du_script.sh
```

If the original script is updated, the changes will be reflected when the symbolic link is accessed, since it points to the original file's path.
If the original file is deleted, the symbolic link will become broken and will not function.

### Hard Links

A hard link is another name for an existing file on the filesystem. Unlike symbolic links, hard links point directly to the inode of the file, meaning they are indistinguishable from the original file. Using the script we created, we can create a hard link to it as follows:

```bash
ln /home/user/du_script.sh /etc/cron.daily/du_script_hardlink.sh
```

This command creates a hard link named `du_script_hardlink.sh` in the `/etc/cron.daily/` directory that points to the same inode as the original script located at `/home/user/du_script.sh`.

```bash
$ ls -l /etc/cron.daily/
-rwxr-xr-x 2 root root  512 Oct 28 10:05 du_script_hardlink.sh -> /home/user/du_script.sh
-rwxr-xr-x 2 root root  512 Oct 28 10:00 du_script.sh -> /home/user/du_script.sh
```

If the original script is updated, the changes will be reflected in both the original file and the hard link, since they point to the same inode.
If the original file is deleted, the hard link will still function, as it points directly to the inode of the file.

### Understanding `ln` Output With Links

Using the examples above, we can see the differences in the output of the `ls -lrt` command for symbolic and hard links.

When we did the Symbolic Link, the output was `lrwxrwxrwx`, indicating that it is a symbolic link (the leading `l`).

When we did the Hard Link, the output was `-rwxr-xr-x`, indicating that it is a regular file (the leading `-`), but with a link count of `2`, showing that there are two names (the original and the hard link) pointing to the same inode. This means that both the original file and the hard link share the same data on disk.
The Symbolic Link shows a link count of `1`, as it is a separate file that points to the original file's path.

### Summary of Differences

| Feature            | Symbolic Link                  | Hard Link                      |
|--------------------|--------------------------------|--------------------------------|
| Points to          | File path                      | Inode of the file              |
| Can link to        | Files and directories          | Only files                     |
| Cross-filesystem   | Yes                            | No                             |
| Deletion effect    | Original file remains intact   | Original file remains intact   |
| Broken link        | Yes, if original is deleted    | No, remains functional         |

### Use Cases when to Use Each Link Type

- Use Symbolic Links when:
  - You need to link to directories.
  - You want to link across different filesystems.
  - You want a clear indication that the link points to another file.
- Use Hard Links when:
  - You want to ensure that the file remains accessible even if the original is deleted.
  - You want to save disk space by avoiding duplicate copies of the same file.

### Removing Symbolic Links

To remove a symbolic link, you can use the `rm` command followed by the name of the symbolic link. For example:

```bash
rm /etc/cron.daily/du_script.sh
```

This command removes the symbolic link `du_script.sh` from the `/etc/cron.daily/` directory without affecting the original script.

### Using Hard Links for Incremental Backups

Hard links can be useful for creating incremental backups. By using hard links, you can create multiple backup copies of files without duplicating the actual data on disk. This saves disk space and allows for efficient backups.

For example, you can create a backup directory and use hard links to create backups of files following these steps:

**Step 1. Create a backup directory:**

```bash
mkdir /home/user/backup
```

**Step 2. Create hard links for files you want to back up:**

```bash
ln /home/user/important_file.txt /home/user/backup/important_file_backup.txt
```

This command creates a hard link named `important_file_backup.txt` in the `/home/user/backup/` directory that points to the same inode as the original file `important_file.txt`.

**Step 3. Repeat the process for other files you want to back up.**

By using hard links for backups, you can efficiently manage your files and save disk space while ensuring that your important data is backed up.

## Cron Job Scheduling Continued

To schedule our script to run automatically, we can use `cron`. We can create a symbolic link to our script in the `/etc/cron.daily/` directory so that it runs daily.

```bash
ln -s /home/user/du_script.sh /etc/cron.daily/du_script.sh
```

This command creates a symbolic link named `du_script.sh` in the `/etc/cron.daily/` directory that points to the original script in the user's home directory.

```bash
$ ls -l /etc/cron.daily/
lrwxrwxrwx 1 root root   29 Oct 28 10:00 du_script.sh -> /home/user/du_script.sh
```

Now, the script will run automatically every day at the scheduled time defined by the system's cron configuration.

## Running Jobs in the Background

To run jobs in the background, you can use the `&` symbol at the end of the command. This allows the command to run asynchronously, freeing up the terminal for other tasks. For example:

```bash
$ ./du_script.sh &
[1] 12345
```

This command runs the `du_script.sh` script in the background. The output `[1] 12345` indicates that the job is running in the background with job number `1` and process ID `12345`.

### Suspending a Job with Ctrl + Z (^Z)

You can also pause a running job and send it to the background using `Ctrl + Z`. This suspends the job and allows you to resume it later. For example:

```bash
$ ./du_script.sh
^Z
[1]+  Stopped                 ./du_script.sh
```

This command suspends the `du_script.sh` script and sends it to the background. The output `[1]+  Stopped` indicates that the job is stopped and can be resumed later.

### Resuming a Job in the Background

To resume the job in the background, you can use the `bg` command:

```bash
$ bg 1
[1]+ ./du_script.sh &
```

### Foregrounding a Background Job

To bring a background job back to the foreground, you can use the `fg` command followed by the job number. For example:

```bash
$ fg 1
./du_script.sh
```

This command brings the job with job number `1` back to the foreground, allowing you to interact with it directly.

### Listing Jobs

You can list all background jobs using the `jobs` command. This will display the status of all jobs that are currently running or stopped in the background. For example:

```bash
$ jobs
[1]+  Running                 ./du_script.sh &
[2]-  Stopped                 another_script.sh &
```

This command lists all background jobs along with their status (Running or Stopped) and job numbers.

The '+' indicates the most recently used job, while the '-' indicates the second most recently used job.

### Running a Command with `nohup`

To run a command that continues to run even after you log out, you can use the `nohup` command. This is useful for long-running processes that you want to keep running in the background. For example:

```bash
nohup ./du_script.sh &
```

This command runs the `du_script.sh` script in the background and ensures that it continues to run even if you log out of the terminal session. The output will be redirected to a file named `nohup.out` by default.

## Named Pipes

Named pipes, also known as FIFOs (First In, First Out), are a type of inter-process communication (IPC) mechanism that allows data to be passed between processes in a unidirectional manner. Named pipes are created using the `mkfifo` command.

The producer-consumer model is a common use case for named pipes. In this model, one process (the producer) writes data to the pipe, while another process (the consumer) reads data from the pipe.

Professor Sverdlov demonstrated how to create a named pipe:

```bash
$ mkfifo myfifo
$ ls -l
prw-r--r-- 1 user user 0 Oct 28 10:30 myfifo
```

The `p` at the beginning of the permissions indicates that it is a named pipe.

To use the named pipe, you can have one process write to it while another process reads from it. For example, in one terminal, you can write data to the pipe:

```bash
echo "some lines of data" > myfifo
```

In a second terminal, try this:

```bash
$ cat myfifo
some lines of data
```

Back to the first terminal, try writing more data:

```bash
$ echo "some lines of data 1" > myfifo &
$ echo "some lines of data 2" > myfifo &
$ echo "some lines of data 3" > myfifo &
$ jobs
[1]+  Running                 echo "some lines of data 1" > myfifo &
[2]-  Running                 echo "some lines of data 2" > myfifo &
[3]+  Running                 echo "some lines of data 3" > myfifo &
```

In the second terminal, you will see the data being read from the pipe as it is written by the first terminal.

```bash
$ cat myfifo
some lines of data
some lines of data 1
some lines of data 2
some lines of data 3
```

Back to the first terminal, you can check the jobs running in the background:

```bash
$ jobs
[1]+  Done                    echo "some lines of data 1" > myfifo
[2]-  Done                    echo "some lines of data 2" > myfifo
[3]+  Done                    echo "some lines of data 3" > myfifo
```

Named pipes are useful for scenarios where you need to facilitate communication between processes without using temporary files. They provide a simple and efficient way to transfer data in real-time.
