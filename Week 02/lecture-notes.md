# CSCI-130 Linux Fundamentals - Week 2 (September 2, 2025) Lecture Notes

## Lecture Outline

- Attendance on Canvas
- Quick review: setup VM and running first few commands
- Review: few ways to go to different directories
- History
- Autocompletion feature
- Three things to always know; who am I, where am I, what am I using
- Aliases
- Semicolons
- Escaping special characters
- What is the shell?
- Subshell
- Listing the content of the directory

## Attendance on Canvas

At the start of every class, Professor Sverdlov takes attendance on Canvas. A quiz will be created on Canvas, students will need to open the quiz and answer the single question of "Did you attend today's lecture?" with "Yes, I attended today's lecture".

## Quick Review: Setup Virtual Machine and Running First Few Commands

Professor Sverdlov demonstrated how to set up VirtualBox and run Fedora 42 as a live user.

## Review: Few Ways to Go to Different Directories

He then demonstrated the `pwd` and `cd` commands. See [Week 01 Lecture Notes](../Week%2001/lecture-notes.md).

During the demonstration, he accidentally ran the wrong command and used "CTRL + C" to cancel/interupt the active running command.

Additionally, he showed a different way, via a variable:

```bash
$ cd $HOME
$ pwd
/home/user
```

Also showed the '~' parameter, which is a shortcut similar to adding the '$HOME' variable.

```bash
$ cd ~
$ pwd
/home/user
```

## History

The `history` command will show a list of previously run commands.

```bash
$ history
1  pwd
2  cd ~
3  pwd
```

Use the bang (`!`) operator to run a historical command by its number.

```bash
$ !3
pwd
/home/user
```

Utilize the bang (`!`) operator to run a historical command using the beginning of the command.

```bash
$ !cd
cd /home/user
```

The `^` operator will replace the string.

```bash
$ ^tmp^home^
cd home
$ pwd
/home
```

History is saved on the `~/.bash_history` file of the user's home directory.
Which ever session is closed last is written to the file. If you open two terminals and run commands in both, the history from the terminal that is closed last will be saved. This also applies to subshells (which we'll go over in more detail later).

## Autocompletion Feature

The autocompletion feature in the shell allows users to quickly complete file and directory names by pressing the `Tab` key. This can save time and reduce errors when typing long paths.

Additionally, if there are multiple matches, pressing `Tab` twice will show all possible completions.

For example, if you type `cd Doc` and press `Tab`, it will complete to `cd Documents/` if that is the only match. If there are multiple matches, it will complete to `cd Documents/` and `cd Downloads/` and so on.

## Three Things to Always Know; Who Am I, Where Am I, and What Am I Using

The `whoami` command displays the current user's username.

```bash
$ whoami
user
```

The `pwd` command displays the current working directory.

```bash
$ pwd
/home/user
```

The `hostname` command displays the name of the machine.

```bash
$ hostname
my-computer
```

## Aliases

Aliases are shortcuts for longer commands. They can save time and keystrokes when working in the shell. You can create an alias using the `alias` command.

Examples:

```bash
$ alias lsa='ls -la'
$ lsa
drwxr-xr-x  5 user user 4096 Sep  3 12:20 Desktop
drwxr-xr-x  5 user user 4096 Sep  3 12:20 Downloads
drwxr-xr-x  5 user user 4096 Sep  3 12:20 Pictures
drwxr-xr-x  5 user user 4096 Sep  3 12:20 Templates
drwxr-xr-x  5 user user 4096 Sep  3 12:20 Documents
drwxr-xr-x  5 user user 4096 Sep  3 12:20 Music
drwxr-xr-x  5 user user 4096 Sep  3 12:20 Video
```

Here is an example of creating an alias for the `pwd` command:

```bash
> alias whereami='pwd'
> whereami
/home/user
```

Typing the `alias` command will give a list of all the aliases stored.

```bash
$ alias
alias lsa='ls -la'
alias time='date;echo "time to go home"'
alias whereami='pwd'
```

Additionally, you can create more complex aliases that include multiple commands. For example:

```bash
$ alias time='date;echo "time to go home"'
$ time
Wed Sep 3 12:20:00 AM UTC 2025
time to go home
```

### Semicolons

Semicolons (`;`) can be used to separate multiple commands on a single line. In the example above, the `alias time` command uses a semicolon to separate the `date` command from the `echo` command.

### Escaping Special Characters

It is important to note that if you are using single quotes or double quotes, like the example above, you'll need to use the proper escapes. For example, `alias whoami="echo don\'t panic"` will cause a problem but it's looking for the `'` to be closed.
To make the above work, use an escape. For example, `alias whoami="echo don\'t panic"`

## What is the Shell

The shell is a command-line interface that allows users to interact with the operating system. It provides a way to execute commands, run programs, and manage files and processes. Examples include Bash, Zsh, and Fish.

This is different from a terminal, which is the actual interface (like a window or a console) that displays the shell.

## Subshell

A subshell is a separate instance of the shell that is spawned by the current shell. It can be used to run commands in isolation from the parent shell. For example, you can use the `sh` command to start a new subshell.

```bash
$ sh
$ echo "This is a subshell"
This is a subshell
$ exit
```

To explain what is happening in the example above, a new subshell is created when the `sh` command is run. This subshell is a separate instance of the shell, and any commands run within it do not affect the parent shell. When the `echo` command is run, it outputs "This is a subshell" to the terminal. Finally, when the `exit` command is run, the subshell is terminated, and control returns to the parent shell.

## Listing the content of the directory

The `ls` command is used to list the contents of a directory. By default, it lists the files and directories in the current working directory.

```bash
$ ls
Desktop  Downloads  Pictures  Templates  Documents  Music  Video
```

You can use options with the `ls` command to modify its behavior. For example, the `-l` option displays detailed information about each file and directory.

```bash
$ ls -l
total 0
drwxr-xr-x  5 user user 4096 Sep  3 12:20 Desktop
drwxr-xr-x  5 user user 4096 Sep  3 12:20 Downloads
drwxr-xr-x  5 user user 4096 Sep  3 12:20 Pictures
drwxr-xr-x  5 user user 4096 Sep  3 12:20 Templates
```

Adding multiple options to the `ls` command is easy. You can combine options to achieve the desired output. For example, you can print out the files in a list format and hidden files.

```bash
$ ls -la
drwxr-xr-x  8 user user 4096 Sep  3 12:20 .
drwxr-xr-x  5 user user 4096 Sep  3 12:20 ..
drwxr-xr-x  5 user user 4096 Sep  3 12:20 .bash
-rw-r--r--  1 user user  220 Sep  3 12:20 .bashrc
drwxr-xr-x  5 user user 4096 Sep  3 12:20 Desktop
drwxr-xr-x  5 user user 4096 Sep  3 12:20 Downloads
drwxr-xr-x  5 user user 4096 Sep  3 12:20 Pictures
drwxr-xr-x  5 user user 4096 Sep  3 12:20 Templates
```

### Preview Around Permissions

During the explanation of 'ls' there was a conversation around permissions.

Here is a breakdown of the permission string:

The first character indicates the type of file. A `-` indicates a regular file, while a `d` indicates a directory.

The next nine characters indicate the permissions for the owner, group, and other users.

Here is a table that better explains the permission string:

| Owner | Group | Other | Explanation |
| --- | --- | --- | --- |
| -rwx | rw- | r-- | Regular file with read, write, and execute permissions for owner, read and execute for group, and read for others. |
| drwx | r-x | r-x | Directory with read, write, and execute permissions for owner, read and execute for group, and read for others. |

Note that the example in the table above indicates that the owner has read, write, and execute permissions, while the group has read and execute permissions, and others have only read permissions.

## Assignment

This week's assignment is to create a research paper that explores the different distrobutions available.

1. Do a web search and find out how many (approximate) various Linux distributions exist.
2. List the most popular distributions in the following categories:
    1. Server-grade
    2. Most popular personal desktop/laptop
        1. Distributions that target Windows users
3. Oriented toward multimedia.
4. For embedded/small devices.
5. Oriented toward the highest security.

Give a brief description of each distribution.
Write a report not exceeding 2 pages (excluding any illustrations/graphics)

How to submit:
Make a PDF file of your paper and submit that PDF file into the Canvas.
