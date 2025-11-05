# CSCI-130 Linux Fundamentals - Week 10 (October 28, 2025) Lecture Notes

## Lecture Outline

- Attendance on Canvas
- About the rest of the semester (Students presentations)
- Text editor: the vi (vim)
- Mail utility

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

- **Normal Mode**: This is the default mode where you can navigate and manipulate text.
- **Insert Mode**: This mode allows you to insert and edit text.

To switch from Normal Mode to Insert Mode, press `i`. To return to Normal Mode from Insert Mode, press `Esc`.

There is also a third mode called Command-Line Mode, which you can access from Normal Mode by typing `:`. This mode allows you to enter commands for saving, quitting, and other operations.

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

## Mail Utility