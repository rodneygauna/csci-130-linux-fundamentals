# Lecture Notes

## Lecture Outline

- Attendance on Canvas
- Quick review: setup VM and running first few commands
- Review: few way

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

