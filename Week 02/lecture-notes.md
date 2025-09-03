# Lecture Notes

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

P.S. did a very demonstration of how to setup VirtualBox and ran Fedora 42 as a live user.
He then showed the 'pwd' and 'cd' commands.
Accidently ran the wrong command and used "CTRL + C" to cancel/interupt the active running command.
Showed a different way, via a variable:

```bash
cd $HOME
>
```

Also showed the '~' parameter, which is a shortcut similar to adding the '$HOME' variable.

```bash
> cd ~
/home/user
```

Showed the history command

```bash
> history
1  pwd
2  cd ~
3 pwd
```

Typing bang (!) along with the number will run that historical command

```bash
> !3
pwd
/home/user
```

You can also do a search that will run the historical command that starts with the search parameters

```bash
> !cd
cd /home/user
```

The '^' operator will replace the string.

```bash
> ^tmp^home^
cd home
> pwd
/home
```

History is stored at the session level. I'll need to add more information about how this works later.

Discussed the 'whoami' command

Discussed the 'hostname' command (which is the name of the machine).

Showed an example of the 'alias' command. the alias command creates a keyword shortcut that run a full command.

```bash
> alias whereami='pwd'
> whereami
/home/user
```

Showed an alias example that included a shell command and echo.

```bash
> alias time='date;echo "time to go home"'
> time
Wed Sep 3 12:20:00 AM UTC 2025
time to go home
```

If you are using single quotes or double quotes, like the example above, you'll need to use the proper escapes.
Quotes seem to be sacred. For example `alias whoami="echo don't panic"` will cause a problem but it's looking for the "'" to be closed.
To make the above work, use an escape. For example, `alias whoami="echo don\'t panic"`

Note the ';' ends the command. In the example above, it ran the 'time' command and then ran the echo.

Typing the 'alias' command will give a list of all the aliases stored.

## What is the Shell

I need add my pervious notes about that the shell is and how it compares to Bash.

Demonstrated subshells by using the 'sh' command.

## Listing the content of the directory

The 'ls' command lists the directory (file structre).
There are many different parameters that can be used.

```bash
> ls
Desktop Downloads Pictures Templates Documents Music Video
```

You can print out the files in a list format

```bash
>ls -l
Desktop
Downloads
Pictures
Templates
```

You can print out the files in a list format and hidden files.

```bash
>ls -la
.bash
.bashrc
Desktop
...
```

## Preview around permissions

During the explaination of 'ls' there was a conversation around permissons.

It's by owner, group, other

| owner	| group	| other	|
| ---	| ---	| ---	|
| -rwx	| rw-	| r--	|

If the listed file is a directory, it will display 'drwx'.

| owner	| group	| other	|
| ---	| ---	| ---	|
| drwx	| r-x	| r-x	|


