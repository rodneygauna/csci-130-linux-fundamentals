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

