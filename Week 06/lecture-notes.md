# CSCI-130 Linux Fundamentals - Week 6 (September 30, 2025) Lecture Notes

## Lecture Outline

- Attendance on Canvas
- About `wget` (and a `curl`) tools: talking to a web/remote server and running a session from the command line (without a browser).
- Counting number of lines in the output
- The `head` and `tail` tools
- The `awk` tool
- The `sort` utility
- Pattern matching and regular expressions

## About `wget` (and a `curl`) tools

### `wget`

The `wget` tool is a command-line utility used for downloading files from the web. It supports various protocols, including HTTP, HTTPS, and FTP. `wget` is particularly useful for downloading files in a non-interactive way, making it ideal for scripts and automated tasks.

Basic usage of `wget`:

```bash
wget [options] [URL]
```

Example:

```bash
wget https://example.com/file.txt
```

This command downloads the file `file.txt` from the specified URL.

## `curl`

The `curl` tool is another command-line utility used for transferring data to or from a server. It supports a wide range of protocols, including HTTP, HTTPS, FTP, and more. Unlike `wget`, `curl` is often used for making requests and interacting with APIs.

Basic usage of `curl`:

```bash
curl [options] [URL]
```

Example:

```bash
curl https://example.com/file.txt -o file.txt
```

This command downloads the file `file.txt` from the specified URL and saves it with the name `file.txt`.

## Counting number of lines in the output

You can use the `wc` (word count) command to count the number of lines in a file or output. The `-l` option specifically counts lines.

Example:

```bash
find . -name "NASA_access_log_Aug95" | xargs wc -l
```

This command finds the file `NASA_access_log_Aug95` and counts the number of lines in it.

Example output:

```text
1569898 ./NASA_access_log_Aug95
```

This output indicates that the file `NASA_access_log_Aug95` contains 1,569,898 lines.

### The `head` and `tail` tools

The `head` and `tail` tools are used to display the beginning and end of a file, respectively.

#### `head`

The `head` command displays the first few lines of a file. By default, it shows the first 10 lines.

Example:

```bash
head file.txt
```

## `tail`

The `tail` command displays the last few lines of a file. Like `head`, it shows the last 10 lines by default.

Example:

```bash
tail file.txt
```

Both commands have options to customize the number of lines displayed. For example, to show the first 20 lines with `head`, you can use:

```bash
head -n 20 file.txt
```

And to show the last 20 lines with `tail`, you can use:

```bash
tail -n 20 file.txt
```

You can also submit the command without the `-n` option, like so:

```bash
head -20 file.txt
```

## The `awk` tool

The `awk` tool is a powerful text processing utility that allows you to manipulate and analyze text files. It operates on a line-by-line basis and can split lines into fields based on a specified delimiter (default is whitespace). "awk" stands for "Aho, Weinberger, and Kernighan," the surnames of its creators.

Basic usage of `awk`:

```bash
find . -name "NASA_access_log_Aug95" | awk '{print $1}'
```

Example output of the first few lines:

```text
in24.inetnebr.com
uplherc.upl.com
uplherc.upl.com
uplherc.upl.com
uplherc.upl.com
```

This command finds the file `NASA_access_log_Aug95` and uses `awk` to print the first field (column) of each line.

Let's try finding all the 404 errors in the log file, but let's do it with `egrep` and show how complex patterns can be built.

```bash
find . -name "NASA_access_log_Aug95" | egrep '404 -'
```

### Example using the Linux password shadow file

You can also use `awk` to process other types of files, such as the Linux password shadow file. For example, to extract usernames from the shadow file:

```bash
cat /etc/shadow | awk -F: '{print $1}'
```

Example output of the first few lines:

```text
root
bin
daemon
adm
lp
```

Let's try to find all the users with a password set to never expire (indicated by a `-1` in the shadow file):

```bash
cat /etc/shadow | awk -F: '$5 == -1 {print $1}'
```

Example output of the first few lines:

```text
bin
daemon
adm
lp
sync
```

Let's try to output the usernames, their hashed passwords, and the last password change date where the password is not locked (i.e., the second field is not `*` or `!`):

```bash
sudo cat /etc/shadow | awk -F ':' '$2 != "*" && $2 != "!" && $2 != "!*" {print $1, $2, $3}'
```

Example output of the first few lines:

```text
rodney-gauna $6$2Rau04iCrcOwoeav$7Bn.nqt5KXWNd3r3d.2xdx2/9CeBmsZFxtANDRmOzmFcC8lV8VV6W190DZ2rDjVekidMiBI1OV/p0JyPxXVk5/ 20319
```

Let's try something similar but only output the username part before any `.` in the original output:

```bash
sudo cat /etc/shadow | awk -F ':' '$2 != "*" && $2 != "!" && $2 != "!*" {print $1, $2, $3}' | awk -F '.' '{print $1}'
```

Example output of the first few lines:

```text
rodney-gauna $6$2Rau04iCrcOwoeav$7Bn
```

### Using the `tr` command with `awk`

You can use the `tr` command to translate or delete characters. For example, to replace colons (`:`) with spaces in the output of the shadow file:

```bash
sudo cat /etc/shadow | tr ':' ' ' | awk '{print $2}'
```

Example output of the first few lines:

```text
*
*!
*
*!
*!
```

### Using variables in `awk`

You can define and use variables in `awk` for more complex processing.

```bash
sudo cat /etc/shadow | tr ':' ' ' | awk '{$NF=""; print $0}'
```

Example output of the first few lines:

```text
root * 18000 0 99999 7 -1
bin * 18000 0 99999 7 -1
daemon * 18000 0 99999 7 -1
adm * 18000 0 99999 7 -1
lp * 18000 0 99999 7 -1
```

This command removes the last field from each line of the shadow file output.

## The `sort` utility

The `sort` utility is used to sort lines of text files. By default, it sorts lines in ascending order.

Let's try an example of sorting the HTTP status codes from the NASA log file.

```bash
cat NASA_access_log_Aug95 | awk '$9 == "200" {print $7}' | sort
```

Example output of the first few lines:

```text
/
/
/
/
/
```

In this example, we use `awk` to filter lines where the HTTP status code (9th field) is `200` and print the requested resource (7th field). The output is then sorted. And "/" indicates the root resource of the web server.

Let's try to sort the output and remove duplicates using `uniq`:

```bash
cat NASA_access_log_Aug95 | awk '$9 == "500" {print $1}' | sort -u
```

Example output of the first few lines:

```text
ad13-006.compuserve.com
labpc20.woodbury.ed
```

This command filters lines with a `500` status code, prints the IP addresses (1st field), sorts them, and removes duplicates with sort's `-u` parameter.

## Pattern matching and regular expressions with `awk`

Pattern matching and regular expressions (regex) are powerful tools for searching and manipulating text based on specific patterns. They are widely used in various command-line tools, including `grep`, `sed`, and `awk`.

Let's try with the password shadow file to find real users (i.e., those with a valid password hash, not `*` or `!`). We can assume that a valid password hash has at least 3 characters.

```bash
sudo cat /etc/shadow | awk -F ':' '$2 ~ /.{3,}/ {print $1}'
```

Example output of the first few lines:

```text
rodney-gauna
```

This command uses a regex pattern `.{3,}` to match passwords with at least 3 characters.
The `~` operator in `awk` is used for pattern matching.
In the `.{3,}` pattern:

- `.` matches any single character.
- `{3,}` specifies that the preceding element (any character) must occur at least 3 times. The first parameter in the curly braces is the minimum number of occurrences, and the second parameter (if provided) would be the maximum number of occurrences. If only one number is provided, it indicates the minimum number of occurrences.

This command effectively filters out users with locked or empty passwords, displaying only those with valid password hashes because they have at least 3 characters in their password field.

Here is another example with the NASA log file to find all requests that have an HTTP status code of 300, 302, or 304.

```bash
cat NASA_access_log_Aug95 | awk '$9 ~ /^(30[024])$/ {print $6" "$7" "$9}'
```

Example output of the first few lines:

```text
"GET / 304
"GET /images/ksclogo-medium.gif 304
"GET /images/MOSAIC-logosmall.gif 304
"GET /images/USA-logosmall.gif 304
"GET /images/WORLD-logosmall.gif 304
```

In this command, the regex pattern `^(30[024])$` is used to match HTTP status codes `300`, `302`, or `304`. The `^` and `$` anchors ensure that the entire field matches one of these codes. The output includes the HTTP method (6th field), the requested resource (7th field), and the status code (9th field).
