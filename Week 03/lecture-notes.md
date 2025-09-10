# CSCI-130 Linux Fundamentals - Week 3 (September 9, 2025) Lecture Notes

## Lecture Outline

- Attendance on Canvas
- Working with files and directories
  - Creating directories
  - Copying, moving, renaming, deleting files and directories
  - Working with wildcards
- Permissions
  - Understanding binary and decimal representation
  - Using `chmod` with numbers and letters
- The PATH variable
- Modifying the PATH variable

## Attendance on Canvas

At the start of every class, Professor Sverdlov takes attendance on Canvas. See [Week 02 Lecture Notes](../Week%2002/lecture-notes.md) for complete details about the attendance process.

## Working with Files and Directories

### Creating Directories

To make a directory, use the `mkdir` command followed by the directory name.

```bash
$ mkdir newfolder
$ ls
newfolder
```

### Moving and Renaming Directories

A directory can be renamed by using the `mv` command. The `mv` command serves dual purposes: it can move files/directories to new locations or rename them in place.

```bash
$ mv newfolder mynewfolder
$ ls
mynewfolder
```

A directory can be moved to a different location using the same `mv` command. The first argument is the source and the second argument is the destination.

```bash
$ mv mynewfolder ~/
$ cd
$ ls
Desktop  Downloads  Pictures  Templates  Documents  Music  Video mynewfolder
```

### Removing Directories

To remove (delete) an empty directory, use the `rmdir` command. The argument should be the directory you want to delete.

```bash
$ rmdir mynewfolder
$ ls
Desktop  Downloads  Pictures  Templates  Documents  Music  Video
```

If the directory contains files or other directories, the `rmdir` command will fail. In such cases, use the `rm -rf` command, where:

- `-r` (recursive) deletes directories and their contents
- `-f` (force) removes files without prompting for confirmation

**Warning:** The `rm -rf` command is powerful and dangerous. Always double-check your path before executing it, as it will permanently delete everything in the specified directory.

Example of preserving attributes:

```bash
$ cp -p myfile.txt backup_myfile.txt
$ ls -l
-rw-r--r-- 1 user user 0 Sep  9 10:30 backup_myfile.txt
-rw-r--r-- 1 user user 0 Sep  9 10:30 myfile.txt
```

Example of interactive copying with confirmation prompt:

```bash
$ touch myfile.txt
$ mkdir myfiles
$ cp myfile.txt myfiles/
$ cp -i myfile.txt myfiles/
cp: overwrite 'myfiles/myfile.txt'?
```

Type `y` for Yes or `n` for No at the prompt.

### Working with Files

#### Creating Files

You can create empty files using the `touch` command:

```bash
$ touch deleteme.txt
$ ls
Desktop  Downloads  Pictures  Templates  Documents  Music  Video deleteme.txt
```

#### Removing Files

You can remove a file by using the `rm` command followed by the filename.

```bash
$ rm deleteme.txt
$ ls
Desktop  Downloads  Pictures  Templates  Documents  Music  Video
```

#### Copying Files

The `cp` command copies files or directories. The first argument is the source and the second argument is the destination.

```bash
$ touch myfile
$ ls
Desktop  Downloads  Pictures  Templates  Documents  Music  Video myfile
$ cp myfile myfile2
$ ls
Desktop  Downloads  Pictures  Templates  Documents  Music  Video myfile myfile2
```

### Working with Wildcards

Wildcards are special characters that can be used to match multiple files or directories at once. They are particularly useful when working with groups of files that have similar names or patterns.

#### The Asterisk (`*`) Wildcard

The asterisk (`*`) matches any number of characters (including zero characters). This is the most commonly used wildcard.

Examples of using the `*` wildcard:

```bash
$ touch file1.txt file2.txt file3.txt document1.doc document2.doc
$ ls
Desktop  Downloads  Pictures  file1.txt  file2.txt  file3.txt  document1.doc  document2.doc
```

Copy all `.txt` files:

```bash
$ mkdir textfiles
$ cp *.txt textfiles/
$ ls textfiles/
file1.txt  file2.txt  file3.txt
```

Copy all files starting with "file":

```bash
$ mkdir myfiles
$ cp file* myfiles/
$ ls myfiles/
file1.txt  file2.txt  file3.txt
```

#### The Question Mark (`?`) Wildcard

The question mark (`?`) matches exactly one character:

```bash
$ ls file?.txt
file1.txt  file2.txt  file3.txt
```

#### Practical Wildcard Examples

Copy multiple files with similar patterns:

```bash
$ cp myfile* ~/Documents/
$ ls ~/Documents/
myfile  myfile2
```

Remove all files with a specific extension (be careful with this command):

```bash
$ touch temp1.tmp temp2.tmp
$ ls *.tmp
temp1.tmp  temp2.tmp
$ rm *.tmp
$ ls *.tmp
ls: cannot access '*.tmp': No such file or directory
```

**Warning:** Be very careful when using wildcards with the `rm` command, as you might accidentally delete files you didn't intend to remove.

## Permissions

Professor Sverdlov discussed the relationship between binary and decimal numbers because of their relevance to file permissions in Linux.

### Binary and Decimal Conversion

Understanding the relationship between binary and decimal numbers is essential for working with Linux file permissions:

| Decimal | Binary |
| ------- | ------ |
| 0 | 000 |
| 1 | 001 |
| 2 | 010 |
| 3 | 011 |
| 4 | 100 |
| 5 | 101 |
| 6 | 110 |
| 7 | 111 |

### Permission Values

Linux permissions use decimal numbers to represent binary combinations for each permission group (Owner, Group, Others). Each permission has a specific value:

- **Read (r)** = 4
- **Write (w)** = 2
- **Execute (x)** = 1

| Decimal | rwx (Read, Write, Execute) | Description |
| ------- | -------------------------- | ----------- |
| 0 | 000 | No permissions |
| 1 | 001 | Execute only |
| 2 | 010 | Write only |
| 3 | 011 | Write and Execute |
| 4 | 100 | Read only |
| 5 | 101 | Read and Execute |
| 6 | 110 | Read and Write |
| 7 | 111 | Full Permissions (Read, Write, Execute) |

### Using `chmod` with Numeric Permissions

The `chmod` command allows you to change permissions for Owner, Group, and Others using the decimal values from the table above. The first argument specifies the permission values, and the second argument is the file or directory.

For example, to give full permissions to the owner, read and write to the group, and read only to everyone else:

```bash
$ touch myfile.txt
$ chmod 764 myfile.txt
$ ls -l myfile.txt
-rwxrw-r--  1 user user  0 Sep  9 12:20 myfile.txt
```

### Using `chmod` with Letter Notation

You can also use letters to modify permissions incrementally. The format is: `chmod [who][operation][permission] filename`

- **Who**: `u` (user/owner), `g` (group), `o` (others), `a` (all)
- **Operation**: `+` (add), `-` (remove), `=` (set exactly)
- **Permission**: `r` (read), `w` (write), `x` (execute)

For example, to give write permissions to owner, group, and everyone else:

```bash
$ chmod +w myfile.txt
$ ls -l myfile.txt
-rwxrw-rw-  1 user user  0 Sep  9 12:20 myfile.txt
```

You can also specify exactly who the permission applies to. For example, give execute permissions to the group and others only:

```bash
$ chmod go+x myfile.txt
$ ls -l myfile.txt
-rwxrwxrwx  1 user user  0 Sep  9 12:20 myfile.txt
```

### Verbose Output

The verbose option `chmod -v` provides detailed output explaining what permissions were changed:

```bash
$ chmod -v 000 myfile.txt
mode of 'myfile.txt' changed from 0777 (rwxrwxrwx) to 0000 (----------)
$ ls -l myfile.txt
----------  1 user user  0 Sep  9 12:20 myfile.txt
```

## The PATH Variable

The PATH variable is an environment variable that tells the shell which directories to search for executable files when you type a command. When you run a command like `ls` or `cat`, the system searches through each directory listed in PATH until it finds the executable.

You can view the current PATH variable using the `echo $PATH` command:

```bash
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
```

The directories are separated by colons (`:`) and are searched in order from left to right. The `which` command shows you exactly which executable file will be used when you run a command:

```bash
$ which ls
/bin/ls
```

## Modifying the PATH Variable

To modify the PATH variable, you can use the `export` command. This allows you to add new directories to the PATH so the shell knows to look there for executable files.

### Example: Adding a Custom Directory to PATH

The following example demonstrates how to create a custom directory, copy an executable to it, and modify PATH to use it:

```bash
$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
$ which ls
/bin/ls
$ mkdir ~/myloc
$ cp /bin/ls ~/myloc/ls
$ export PATH=/home/user/myloc:$PATH
$ echo $PATH
/home/user/myloc:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games
$ which ls
/home/user/myloc/ls
```

### Understanding the PATH Modification

In the above example:

1. We first check the current PATH and see where `ls` is located
2. Create a new directory called `myloc` in the home directory
3. Copy the `ls` executable to our new directory
4. Prepend our new directory to the PATH using `export PATH=/home/user/myloc:$PATH`
5. Verify that `which ls` now points to our custom location

**Important Notes:**

- Adding a directory to the beginning of PATH (as shown) gives it priority over existing directories
- PATH modifications using `export` are temporary and only last for the current session
- To make PATH changes permanent, you would need to add the export command to your shell configuration file (like `~/.bashrc` or `~/.bash_profile`)

## Week 3 Assignment

This week's assignment focuses on hands-on practice with file operations and permission management:

1. Working with Files and Directories
    1. Create a few nested and branched directories in your home directory. Populate them with some files. Copy some files around, use the move command to rename files or move files between directories.
    2. Try to delete a non-empty directory with the `rmdir` command. What do you see? What should you do to delete the directory?
    3. Delete all other directories you created with the `rm -rf` command. Do `ls -l` from your home directory to verify. Make sure you provide the correct path to the `rm` command in this part. **Beware that you may delete something you did not want to.**
2. Changing Permissions
    1. Change permissions on some of the files to add 'x' (execute) and 'w' (write) permissions to you only, to the group, and to all. Do `ls -l` to verify changes. What do you see?
    2. Do a web search and find out how to change permissions recursively.
    3. Look at the screenshot below showing permissions for the `/tmp` directory. Do a web search and find out what is the purpose of the last bit (the 't'). What is the "sticky bit" and why is it needed?

How to Submit

- For problem 1: Submit a relevant history of your commands.
- For problems 2 and 3: Submit a PDF file with a summary of your research.
