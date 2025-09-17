# CSCI-130 Linux Fundamentals - Week 4 (September 16, 2025) Lecture Notes

## Lecture Outline

- Attendance on Canvas
- Couple of comments
- Restoring PATH from the profile
- Three types of quotes in Linux
- How to read content of the file
  - cat
  - more
  - less
- Environment variables
- A find utility
- Redirecting the output

## Couple of comments

### Copying from VM to Host Computer

Professor Sverdlov showed how to copy files from the virtual machine to your host computer. This is useful for saving assignments.

#### Method 1: Shared Folders

1. In VirtualBox, go to **Settings** → **Shared Folders**
2. Add a shared folder from your host computer
3. Access it in the VM at `/media/sf_shared`

```bash
$ cp assignment.txt /media/sf_shared/
```

#### Method 2: Copy and Paste

1. In VirtualBox, go to **Settings** → **General** → **Advanced**
2. Set "Shared Clipboard" to "Bidirectional"
3. Now you can copy and paste text between VM and host

### Working with Groups and Permissions

Groups allow multiple users to share access to files. You can add users to groups and set permissions for the entire group.

Example of giving a group access to a file:

```bash
$ ls -l myfile.txt
-rw-r--r-- 1 user group 100 Sep 16 10:30 myfile.txt
$ chmod g+w myfile.txt
$ ls -l myfile.txt
-rw-rw-r-- 1 user group 100 Sep 16 10:30 myfile.txt
```

### Basic ACL (Access Control Lists)

ACL allows you to give specific permissions to individual users or groups beyond the basic owner/group/other permissions.

#### Viewing ACL

Check if a file has ACL permissions:

```bash
$ getfacl myfile.txt
# file: myfile.txt
# owner: user
# group: group
user::rw-
group::r--
other::r--
```

#### Setting ACL

Give a specific user read and write access:

```bash
$ setfacl -m u:alice:rw myfile.txt
```

Give a specific group read access:

```bash
$ setfacl -m g:students:r myfile.txt
```

#### Removing ACL

Remove ACL permissions:

```bash
$ setfacl -b myfile.txt
```

**Note:** Not all file systems support ACL. Use basic permissions (chmod) for most situations.

## Restoring PATH from the Profile

Sometimes the PATH variable gets messed up and you can't run commands properly. Professor Sverdlov showed how to fix this by restoring the default PATH settings.

### What is PATH?

PATH tells the shell where to look for commands. See [Week 03 Lecture Notes](../Week%2003/lecture-notes.md) for the introduction to PATH.

### Restoring Default PATH

If your PATH gets broken, you can restore it using:

```bash
source /etc/profile
```

This reloads the system's default PATH settings.

### Manual PATH Fix

If you know what the PATH should be, you can set it manually:

```bash
export PATH="/usr/local/bin:/usr/bin:/bin"
```

### Making PATH Changes Permanent

To save PATH changes permanently, add them to your `.bashrc` file:

```bash
echo 'export PATH="/usr/local/bin:/usr/bin:/bin"' >> ~/.bashrc
source ~/.bashrc
```

## Three Types of Quotes in Linux

Professor Sverdlov explained how different quotes work in Linux. This is important when working with filenames that have spaces or special characters.

### Single Quotes ('')

Single quotes treat everything literally - nothing gets expanded or interpreted.

```bash
$ name="John"
$ echo 'Hello $name'
Hello $name
```

### Double Quotes ("")

Double quotes allow variables to be expanded but preserve spaces.

```bash
$ name="John"
$ echo "Hello $name"
Hello John
$ cd "My Documents"
```

### Backslash (\)

Backslash escapes special characters to make them literal.

```bash
$ cd My\ Documents
$ echo "The price is \$50"
The price is $50
```

### When to Use Each

- Use **single quotes** when you want exact text
- Use **double quotes** when you need variables expanded or have spaces
- Use **backslash** to escape individual special characters

## How to Read Content of Files

Professor Sverdlov showed three commands for viewing file contents.

### `cat` - Display File Contents

The `cat` command shows the entire content of a file on the screen.

```bash
$ cat filename.txt
This is the content of the file.
Line 2 of the file.
Line 3 of the file.
```

**Useful for:**

- Small files
- Quickly viewing file content
- Combining multiple files: `cat file1.txt file2.txt`

### `less` - View Files Page by Page

The `less` command lets you scroll through large files.

```bash
less filename.txt
```

**Key commands in less:**

- `Space` - Next page
- `b` - Previous page
- `/word` - Search for "word"
- `q` - Quit

### `more` - Simple File Viewer

The `more` command is similar to `less` but simpler.

```bash
more filename.txt
```

**Key commands in more:**

- `Space` - Next page
- `q` - Quit

### Which Command to Use?

- **`cat`** - For small files you want to see all at once
- **`less`** - For large files you want to scroll through (recommended)
- **`more`** - Basic file viewing (older systems)

## Environment Variables

Environment variables store system settings that programs can use. They are like global settings for your Linux system.

### What Are Environment Variables?

Environment variables contain information like:

- Where to find programs (PATH)
- Your home directory (HOME)
- Your username (USER)

### Viewing Environment Variables

To see all environment variables:

```bash
$ printenv
USER=john
HOME=/home/john
PATH=/usr/bin:/bin
```

To see a specific variable:

```bash
$ echo $HOME
/home/john
$ echo $USER
john
$ echo $PATH
/usr/bin:/bin
```

### Setting Environment Variables

To set a variable for your current session:

```bash
$ export EDITOR=nano
$ echo $EDITOR
nano
```

### Common Environment Variables

| Variable | What it stores |
|----------|----------------|
| `PATH` | Directories to search for commands |
| `HOME` | Your home directory |
| `USER` | Your username |
| `SHELL` | Your default shell |

## The Find Command

The `find` command helps you locate files and directories. It searches through directories to find what you're looking for.

### Basic Find Usage

```bash
find [where to look] [what to find]
```

### Finding by Name

Search for files by name:

```bash
$ find /home -name "*.txt"
/home/user/notes.txt
/home/user/document.txt
```

Find a specific file:

```bash
$ find . -name "myfile.txt"
./myfile.txt
```

### Finding by Type

Find only directories:

```bash
$ find /home -type d
/home
/home/user
/home/user/Documents
```

Find only files:

```bash
$ find /home -type f -name "*.txt"
/home/user/notes.txt
```

### Find Command Examples

Find all text files in your home directory:

```bash
$ find ~ -name "*.txt"
```

Find all directories named "Documents":

```bash
$ find / -type d -name "Documents"
```

### Saving Results

Save find results to a file:

```bash
$ find /home -name "*.txt" > found_files.txt
```

Hide error messages:

```bash
$ find / -name "*.txt" 2> /dev/null
```

## Output Redirection in Linux

Output redirection allows you to send command output to files instead of displaying it on the terminal. This is useful for saving results, logging, and managing command output.

### Understanding Standard Streams

Every Linux command has three streams:

- **stdin (0)**: Standard input - where commands read input (keyboard)
- **stdout (1)**: Standard output - where normal results go (terminal screen)
- **stderr (2)**: Standard error - where error messages go (terminal screen)

### Basic Redirection Operators

#### Redirect Output (`>`)

The `>` operator sends output to a file, **replacing** any existing content:

```bash
$ ls -l > file_list.txt
$ cat file_list.txt
total 8
-rw-r--r-- 1 user user 1234 Sep 16 10:30 document.txt
-rw-r--r-- 1 user user 5678 Sep 16 10:31 notes.txt
```

#### Append Output (`>>`)

The `>>` operator adds output to the end of a file without replacing existing content:

```bash
$ echo "First line" > log.txt
$ echo "Second line" >> log.txt
$ cat log.txt
First line
Second line
```

#### Redirect Errors (`2>`)

The `2>` operator sends error messages to a file:

```bash
$ ls /nonexistent 2> errors.txt
$ cat errors.txt
ls: cannot access '/nonexistent': No such file or directory
```

#### Redirect Both Output and Errors (`2>&1`)

To send both normal output and errors to the same file:

```bash
$ find / -name "*.xml" > results.txt 2>&1
# Both successful results and permission errors go to results.txt
```

### Redirection Examples

#### Save command results

```bash
$ ps aux > running_processes.txt
$ df -h > disk_usage.txt
$ history > my_commands.txt
```

#### Separate output and errors

```bash
$ find /home -name "*.txt" > found_files.txt 2> search_errors.txt
```

#### Discard unwanted output

```bash
$ find / -name "*.log" 2> /dev/null
# Shows results but hides "Permission denied" errors
```

### Order Matters

**Correct way:**

```bash
$ command > file.txt 2>&1
# Sends both output and errors to file.txt
```

**Wrong way:**

```bash
$ command 2>&1 > file.txt
# Only output goes to file, errors still appear on screen
```

### Practical Tips

1. Use `>` to create new files or replace existing ones
2. Use `>>` to add to existing files (like log files)
3. Use `2>` to capture error messages
4. Use `2>&1` when you want everything in one file
5. Use `/dev/null` to throw away output you don't want

### Quick Reference

| Operator | Purpose | Example |
|----------|---------|---------|
| `>` | Save output (replace file) | `ls > files.txt` |
| `>>` | Add output (append to file) | `date >> log.txt` |
| `2>` | Save errors | `command 2> errors.txt` |
| `2>&1` | Save output and errors together | `command > file.txt 2>&1` |
