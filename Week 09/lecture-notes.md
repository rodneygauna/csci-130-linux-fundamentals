# CSCI-130 Linux Fundamentals - Week 9 (October 21, 2025) Lecture Notes

## Lecture Outline

- Attendance on Canvas
- Our first script
- Finishing up with regular expressions
  - Matching email addresses
  - Matching phone numbers
  - Finding repetitions in a string
  - Sanitizing input (removing unwanted characters)
- In file in place substitution

## Our First Script

You can create a simple bash script using any text editor. Here is an example of a basic script that processes the `NASA_access_log_Aug95` file to find and count occurrences of the term "apollo" along with associated codes:

```bash
#!/bin/bash
# This is a script to count the occurrences of each unique response code for 'apollo' requests in the NASA access log.
codes=$(grep 'apollo' NASA_access_log_Aug95 | awk '{print $(NF-1)}' | sort -u)
for i in $codes; do
    echo "code '$i'" ; grep 'apollo' NASA_access_log_Aug95 | awk -v code="$i" '$(NF-1) == code {print $0}'  | wc -l ;
done
```

Here is a breakdown of what the script does:

1. `#!/bin/bash`: This line indicates that the script should be run using the bash shell.
2. `codes=$(...)`: This command extracts unique response codes associated with 'apollo' requests from the log file.
3. `for i in $codes; do ... done`: This loop iterates over each unique response code.
4. Inside the loop:
   - `echo "code '$i'"`: Prints the current response code.
   - `grep 'apollo' NASA_access_log_Aug95 | awk -v code="$i" '$(NF-1) == code {print $0}' | wc -l`: This command counts how many times the current response code appears in 'apollo' requests.

How to run the script:

1. Save the script to a file, e.g., `apollo_count.sh`.
2. Make the script executable with the command: `chmod +x apollo_count.sh`.
3. Run the script using: `./apollo_count.sh`.

You can also use the `source` command to run the script in the current shell environment:

```bash
source apollo_count.sh
```

Example output when running the script:

```text
code '200'
151024
code '302'
117
code '304'
9856
code '404'
1707
code '500'
2
```

## Finishing Up with Regular Expressions

### Matching Email Addresses

To match email addresses using regular expressions, you can use the following pattern:

```regex
[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}
```

This pattern breaks down as follows:

- `[a-zA-Z0-9._%+-]+`: Matches the local part of the email (before the @ symbol).
- `@`: Matches the @ symbol.
- `[a-zA-Z0-9.-]+`: Matches the domain name (after the @ symbol).
- `\.`: Matches the dot before the top-level domain.
- `[a-zA-Z]{2,}`: Matches the top-level domain (e.g., com, org, net).

Examples this pattern matches:

- `user@example.com`
- `john.doe@subdomain.example.org`
- `alice+tag@gmail.com`

A similar example that Professor Sverdlov showed in class:

```bash
echo "abc123@some.other.com" | egrep '[a-zA-Z0-9_\-\.]+\@([a-z0-9_]+\.){1,2}(com|edu|net|gov|ca)$'
```

This pattern breaks down the following:

- `[a-zA-Z0-9_\-\.]+`: Matches the local part of the email.
- `\@`: Matches the @ symbol.
- `([a-z0-9_]+\.){1,2}`: Matches one or two subdomains.
- `(com|edu|net|gov|ca)$`: Matches specific top-level domains at the end of the string.

Output:

```text
abc123@some.other.com
```

Professor Sverdlov also showed how to use Perl to do the same thing:

```bash
echo "wer22@mail.yahoo.com" | perl -ne 'print "$1\n" if/([^\.\@]+\.(com|edu|net))/'
```

This command breaks down as follows:

- `perl -ne`: Invokes Perl with the `-n` option to loop over input lines and `-e` to execute the provided code.
- `print "$1\n" if/([^\.\@]+\.(com|edu|net))/`: Prints the matched email if it fits the specified pattern.

Output:

```text
yahoo.com
```

### Matching Phone Numbers

To match phone numbers in various formats, you can use the following regular expression:

```regex
(\+?1[\s.-]?)?\(?[0-9]{3}\)?[\s.-]?[0-9]{3}[\s.-]?[0-9]{4}
```

This pattern breaks down as follows:

- `(\+?1[\s.-]?)?`: Matches an optional country code (+1) with optional spacing or punctuation.
- `\(?[0-9]{3}\)?`: Matches the area code, with optional parentheses.
- `[\s.-]?`: Matches optional separators (space, dot, or dash).
- `[0-9]{3}`: Matches the first three digits of the phone number.
- `[\s.-]?`: Matches optional separators again.
- `[0-9]{4}`: Matches the last four digits of the phone number.

Examples this pattern matches:

- `123-456-7890`
- `(123) 456-7890`
- `+1 123-456-7890`
- `123.456.7890`
- `1234567890`

Professor Sverdlov showed this example in class:

phones contains:

```text
+1 (760) 123-4567x333
+1 761.123.3456ext234
762.123.3456
763-123-4567
(764) 123-4567
765 123 4567
+1.766.123.6543
```

```bash
perl -ne 'print "($2) $3-$4 $6\n" if /([\( \.\-]|)(\d\d\d)\D+(\d{3})\D+(\d{4})(\D+(\d+))?/' phones
```

This command breaks down as follows:

- `perl -ne`: Invokes Perl with the `-n` option to loop over input lines and `-e` to execute the provided code.
- `print "($2) $3-$4 $6\n" if /.../`: Prints the formatted phone number if it matches the specified pattern.
- The regex inside the slashes captures different parts of the phone number for formatting.

Output:

```text
(760) 123-4567 333
(761) 123-3456 234
(762) 123-3456
(763) 123-4567
(764) 123-4567
(765) 123-4567
(766) 123-6543
```

### Finding Repetitions in a String

To find repetitions of characters or sequences in a string, you can use the following regular expression:

```regex
(.)\1+
```

Professor Sverdlov provided this example:

```bash
echo "skdfldksqweqwekdsflksdkds" | perl -ne 'print "$1\n" if /(\w{3})\1+/'
```

This command breaks down as follows:

- `perl -ne`: Invokes Perl with the `-n` option to loop over input lines and `-e` to execute the provided code.
- `print "$1\n" if /(\w{3})\1+/`: Prints the matched sequence of three word characters if it is repeated consecutively.

Output:

```text
qwe
```

This pattern captures any sequence of three word characters (`\w{3}`) that is immediately followed by the same sequence (`\1+`), indicating repetition.

### In file in place substitution

Professor Sverdlov used the following example:

html1 file contains:

```text
img.gif
img1.gif
```

```bash
perl -pi.back -e 's/\.gif/\.jpg/g' html1
```

This command breaks down as follows:

- `perl -pi.back -e`: Invokes Perl with the `-p` option to loop over input lines, `-i.back` to edit the file in place while creating a backup with a `.back` extension, and `-e` to execute the provided code.
- `s/\.gif/\.jpg/g`: Substitutes all occurrences of `.gif` with `.jpg` globally in each line of the file.

Output:

```text
img.jpg
img1.jpg
```

### Sanitizing Input (removing unwanted characters)

Professor Sverdlov also showed this example:

```bash
echo 'my text here !@##@$!@#@#$*()**_+ other text' | perl -pe 's/\W//g'
```

This command breaks down as follows:

- `perl -pe`: Invokes Perl with the `-p` option to loop over input lines and print them after processing, and `-e` to execute the provided code.
- `s/\W//g`: Substitutes all non-word characters (`\W`) with nothing (removes them) globally in each line of input.

Output:

```text
mytexthereothertext
```

You can use this command to keep the spaces:

```bash
echo 'my text here !@##@$!@#@#$*()**_+ other text' | perl -pe 's/-a-zA-Z0-9 ]//g'
```

This command breaks down as follows:

- `perl -pe`: Invokes Perl with the `-p` option to loop over input lines and print them after processing, and `-e` to execute the provided code.
- `s/-a-zA-Z0-9 ]//g`: Substitutes all characters that are not lowercase letters, uppercase letters, digits, or spaces with nothing (removes them) globally in each line of input.

Output:

```text
my text here  other text
```

## Examples of bash string library

Professor Sverdlov showed this example:

```bash
m=/home/bob/bin/ls
echo ${m%/*} # prints the directory
echo ${m##*/} # prints the filename
```

This command breaks down as follows:

- `m=/home/bob/bin/ls`: Assigns the string `/home/bob/bin/ls` to the variable `m`.
- `echo ${m%/*}`: Uses parameter expansion to remove the shortest match of `/*` from the end of the string stored in `m`, effectively printing the directory path `/home/bob/bin`.
- `echo ${m##*/}`: Uses parameter expansion to remove the longest match of `*/` from the beginning of the string stored in `m`, effectively printing the filename `ls`.

Output:

```text
/home/bob/bin
ls
```

Another example:

```bash
mkdir pics
cd pics
touch pic{1..50}.JPG
for i in 'ls *.JPG'; do mv "$i" "${i%.JPG}.jpg"; done
```

This command breaks down as follows:

- `mkdir pics`: Creates a new directory named `pics`.
- `cd pics`: Changes the current directory to `pics`.
- `touch pic{1..50}.JPG`: Creates 50 empty files named `pic1.JPG` to `pic50.JPG`.
- `for i in 'ls *.JPG'; do mv "$i" "${i%.JPG}.jpg"; done`: Loops through each file with a `.JPG` extension and renames it to have a `.jpg` extension by removing the `.JPG` suffix and appending `.jpg`.

Output:

```bash
$ ls -l
pic1.jpg
pic2.jpg
...
pic50.jpg
```
