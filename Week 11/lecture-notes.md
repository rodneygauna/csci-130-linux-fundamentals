# CSCI-130 Linux Fundamentals - Week 10 (October 28, 2025) Lecture Notes

## Lecture Outline

- Attendance on Canvas
- About the rest of the semester (Students presentations)
- Text editor: the vi (vim)
- Mail utility
- Cron

## About the Rest of the Semester

There are only three classes left:

- November 4
- November 18
- December 2
- December 9
- December 16

The last two classes will be dedicated to student presentations. Each student will present on a Linux-related topic of their choice. Please prepare a 10-15 minute presentation

The final will be a take from home exam, details to be provided later.

## The vi (vim) Text Editor

Vi is a powerful text editor available on most Unix-like operating systems. Vim (Vi IMproved) is an enhanced version of vi with additional features.

### Starting vi/vim

__This video provides a good introduction to vi/vim: [Give Me 20 Minutes and I’ll Make You a Vim Motions Expert](https://youtu.be/z4eA2eC28qg?si=41mcC2oZsuFOTndY)__

To start vi or vim, open a terminal and type `vi` or `vim`, followed by the name of the file you want to edit. For example:

```bash
vi myfile.txt
```

If the file does not exist, vi/vim will create it for you.

After opening a file, you will be in Normal Mode.

### Exiting vi/vim

To exit vi/vim, you need to be in Normal Mode. Here are some common commands to exit:

- `:wq`: Save and quit
- `:q!`: Quit without saving
- `:w`: Save the file without quitting

### Basic Modes

Vi/vim operates in two main modes:

- __Normal Mode__: This is the default mode where you can navigate and manipulate text.
- __Insert Mode__: This mode allows you to insert and edit text.

To switch from Normal Mode to Insert Mode, press `i`. To return to Normal Mode from Insert Mode, press `Esc`.

There is also a third mode called Command-Line Mode, which you can access from Normal Mode by typing `:`. This mode allows you to enter commands for saving, quitting, and other operations.

### Basic Vi/vim Commands After Opening a File

- `:set number` or `:set nu`: Enable line numbers
- `:set nonumber` or `:set nonu`: Disable line numbers
- `:set syntax=on`: Enable syntax highlighting
- `:set syntax=off`: Disable syntax highlighting
- `:help <command>`: Get help on a specific command (e.g., `:help w` for help on the write command)
- `:set all`: Show all current settings
- `:set wrap`: Enable word wrap
- `:set nowrap`: Disable word wrap
- `:shell` or `:sh`: Open a shell from within vi/vim

### Basic Commands

Here are some basic commands to get you started:

- `i`: Enter Insert Mode
- `Esc`: Return to Normal Mode
- `:w`: Save the file
- `:q`: Quit vi/vim
- `:wq`: Save and quit
- `:q!`: Quit without saving

To enable line numbers, you can use the command `:set number` or `:set nu`.

### Motion Commands

- `h`: Move left
- `j`: Move down
- `k`: Move up
- `l`: Move right
- `0`: Move to the beginning of the line
- `$`: Move to the end of the line
- `gg`: Move to the beginning of the file
- `G`: Move to the end of the file
- `w`: Move to the beginning of the next word
- `b`: Move to the beginning of the previous word
- `%`: Move to the matching parenthesis, bracket, or brace

You can combine motion commands with numbers to move multiple lines or characters. For example, `5j` moves down five lines.

### Editing Commands

- `o`: Open a new line below the current line and enter Insert Mode
- `O`: Open a new line above the current line and enter Insert Mode
- `i`: Insert text before the cursor
- `a`: Append text after the cursor
- `A`: Append text at the end of the line
- `x`: Delete the character under the cursor
- `dd`: Delete the current line
- `yy`: Yank (copy) the current line
- `p`: Paste the yanked line below the current line
- `u`: Undo the last change
- `Ctrl + r`: Redo the last undone change

You can also use numbers with editing commands. For example, `3dd` deletes three lines.

### Buffers and Windows

Vi/vim supports multiple buffers and windows, allowing you to work on multiple files simultaneously.

#### Buffers

A buffer is an in-memory representation of a file. You can have multiple buffers open at the same time, and you can switch between them easily.

- `:ls`: List all open buffers
- `:buffer <n>`: Switch to buffer number n
- `:bdelete <n>`: Close buffer number n

#### Windows

Windows are separate views into buffers. You can split the screen into multiple windows to view and edit different parts of a file or different files at the same time.

- `:split`: Split the current window horizontally
- `:vsplit`: Split the current window vertically
- `Ctrl + w, h/j/k/l`: Move between windows
- `:close`: Close the current window

### Shell Commands

You can execute shell commands from within vi/vim without leaving the editor.

- `:!<command>`: Execute a shell command (e.g., `:!ls` to list files)
- `:sh` or `:shell`: Open a shell from within vi/vim
- `:exit`: Exit the shell and return to vi/vim
- `:read <filename>` or `:r <filename>`: Insert the contents of a file into the current file at the cursor position
- `:read !<command>` or `:r !<command>`: Insert the output of a shell command into the file at the current cursor position (e.g., `:read !date` to insert the current date)
- `:write !<command>` or `:w !<command>`: Send the contents of the file to a shell command (e.g., `:write !sort` to sort the contents of the file)
- `:30, 35s/old/new/g`: Substitute 'old' with 'new' from line 30 to 35

### Mapping Keys

You can create custom key mappings in vi/vim to streamline your workflow.

- `:map <key> <command>`: Map a key to a command in Normal Mode
- `:imap <key> <command>`: Map a key to a command in Insert Mode
- `:nmap <key> <command>`: Map a key to a command in Normal Mode only
- `:vmap <key> <command>`: Map a key to a command in Visual Mode only

#### Copy and Paste Mappings

```vim
:map ^c "ayy"
:map ^v "ap"
```

This maps `Ctrl + c` to copy the current line and `Ctrl + v` to paste it to the "a" buffer.

### Example Use Cases

#### Swapping Last Name and First Name

```text
Potter, Harry
```

To swap the last name and first name in vi/vim, you can use the following command in Normal Mode:

```vim
:s/\(.*\), \(.*\)/\2 \1/
```

This command uses a regular expression to match the last name and first name, then rearranges them.

```text
Harry Potter
```

#### Find and Replace

```text
drwxr-xr-x 2 user user 4096 Oct 28 10:00 Documents
```

To replace "user" with "admin" in the above line, you can use the following command in Normal Mode:

```vim
:%s/user/admin/g
```

#### Sorting Lines

```text
1 banana
3 apple
2 cherry
```

To sort the lines in alphabetical order, you can use the following command in Normal Mode:

```vim
:!sort
```

This will replace the current content with the sorted lines.

```text
3 apple
1 banana
2 cherry
```

## Mail Utility

The mail utility is a command-line program used to send and receive email on Unix-like operating systems. It allows users to compose, send, and read emails directly from the terminal.

### Installing Mail Utility

To install the mail utility, you can use the package manager for your Linux distribution. For example, on Debian-based systems, you can use:

```bash
sudo apt-get install mailutils
```

Depending on your distribution, the package name may vary (e.g., `mailx`, `heirloom-mailx`).
For Fedora-based systems, you can use:

```bash
sudo dnf install mailx
```

### Opening Mail Utility

```bash
mail
```

This command opens the mail utility, allowing you to read and manage your emails from the terminal. You can use various commands within the mail utility to navigate and interact with your messages.

### Reading Emails

When you open the mail utility, you will see a list of your emails. Each email is assigned a number. To read an email, type its number and press Enter. For example, to read the first email, type:

```bash
1
```

#### Additional Reading Commands

- `n`: Move to the next email
- `b`: Move to the previous email
- `d`: Delete the current email
- `t`: Tag the current email for deletion
- `u`: Untag the current email

### Marking as Read or Unread

To mark an email as read, simply read it by typing its number. To mark an email as unread, you can use the `u` command while viewing the email.

### Composing and Sending Emails

To compose and send an email (with a subject, recipient, and body) using the mail utility, use the following command:

```bash
mail -s "Subject" recipient@example.com
```

Replace "Subject" with the subject of your email and "<recipient@example.com>" with the email address of the recipient. After entering the command, you will be prompted to enter the body of the email. Type your message and press Ctrl + D to send it.

#### Attaching Files

To attach a file to your email using the mail utility, use the `-a` option followed by the file path. For example:

```bash
mail -s "Subject" -a /path/to/file recipient@example.com
```

Replace `/path/to/file` with the actual path of the file you want to attach.

### Additional Mail Commands

- `m`: Move to the next email
- `p`: Print the current email
- `d`: Delete the current email
- `q`: Quit the mail utility
- `h`: Display the list of emails (header)
- `r`: Reply to the current email
- `f`: Forward the current email
- `s <filename>`: Save the current email to a file
- `!<command>`: Execute a shell command from within the mail utility
- `?`: Display help information about mail commands

## Cron

Cron is a time-based job scheduler in Unix-like operating systems. It allows users to schedule tasks (known as "cron jobs") to run automatically at specified intervals.

### Crontab

The `crontab` command is used to create, edit, and manage cron jobs. Each user has their own crontab file, which contains a list of scheduled tasks.

To edit your crontab file, use the following command:

```bash
crontab -e
```

This command opens your crontab file in the default text editor. You can add, modify, or delete cron jobs in this file.

### Cron Job Syntax

A cron job consists of six fields:

```text
* * * * * command_to_execute
| | | | | |
| | | | | +------ Command to be executed
| | | | +-------- Day of the week (0 - 7) (Sunday is both 0 and 7)
| | | +---------- Month (1 - 12)
| | +------------ Day of the month (1 - 31)
| +-------------- Hour (0 - 23)
+---------------- Minute (0 - 59)
```

### Example Cron Job

#### Daily Script Execution

To run a script every day at 2:30 AM, you would add the following line to your crontab file:

```text
30 2 * * * /path/to/your/script.sh
```

This cron job will execute the script located at `/path/to/your/script.sh` every day at 2:30 AM.

#### Multiple Times a Day

To run a script every 2, 5, and 8 minutes, you would add the following line to your crontab file:

```text
2,5,8 * * * * echo "The date is `date`" >> /home/user/dates.log
```

This cron job will execute the command every 2, 5, and 8 minutes.

### Mail Notifications

By default, cron sends an email to the user with the output of the cron job. You can specify a different email address by adding the following line at the top of your crontab file:

```text
MAILTO="your_email@example.com"
```

### Removing Cron Jobs

To remove a cron job, simply delete the corresponding line from your crontab file and save the changes.

Another option is to comment out the line by adding a `#` at the beginning of the line. This way, the cron job will be ignored without being deleted.

```text
#2,5,8 * * * * echo "The date is `date`" >> /home/user/dates.log
```
