# CSCI-130 Linux Fundamentals - Week 7 (October 7, 2025) Lecture Notes

## Lecture Outline

- Attendance on Canvas
- Midterm next week
  - Prep quiz tonight
- Pattern matching and regular expressions (continued)
  - Patterns
  - Ranges
  - Alternations
  - Grouping
  - Extracting matches
  - What to do if you cannot find a pattern?
    - Some examples:
      - Matching an IP address (easy)
      - Matching phone numbers (not so easy)
      - Matching email addresses
      - Finding repetitions in the string
      - Sanitizing the input

## Midterm Next Week

The midterm is scheduled for next week. Please make sure to review the material covered so far. You can use your notes (only, no manuals or textbooks).
There will be a prep quiz available tonight to help you prepare.

## Pattern Matching and Regular Expressions (Continued)

Different tools in Linux use regular expressions for pattern matching, including `grep` and `awk`. Regular expressions allow you to search for specific patterns within text.

### Metacharacters

| Character | Meaning | Example |
|-----------|---------|---------|
| `.`       | Matches any single character except a newline | `a.c` matches `abc`, `a-c`, `a c` |
| `^`       | Matches the start of a line | `^abc` matches `abcdef` but not `xabc` |
| `$`       | Matches the end of a line | `abc$` matches `xyzabc` but not `abcxyz` |
| Repetition | ---- | ---- |
| `?`       | Matches 0 or 1 occurrence of the preceding element | `ab?c` matches `ac` or `abc` |
| `+`      | Matches 1 or more occurrences of the preceding element | `ab+c` matches `abc`, `abbc`, `abbbc`, etc. |
| `{min, max}` | Matches at least `min` and at most `max` occurrences of the preceding element | `a{2,4}` matches `aa`, `aaa`, or `aaaa` |
| `*`      | Matches 0 or more occurrences of the preceding element | `ab*c` matches `ac`, `abc`, `abbc`, `abbbc`, etc. |
| Ranges, Grouping, Alternation | ---- | ---- |
| `\|`       | Alternation (logical OR) | `abc\|def` matches `abc` or `def` |
| `()`      | Grouping | `(abc)+` matches `abc`, `abcabc`, `abcabcabc`, etc. `(this)\|(that)` matches `this` or `that` |
| `[]`      | Character class (matches any one character within the brackets) | `[abc]` matches `a`, `b`, or `c`  ``tr[iu]`` matches `trick` or `truck` |
| `[^]`     | Negated character class (matches any one character not within the brackets) | `[^abc]` matches any character except `a`, `b`, or `c`  `tr[^i]ck` matches `truck` |

### Special Sequences

| Range | perl | egrep, awk, perl |
|-------|------|------------------|
| space | `\s` | `' '` (yes there is a space in the example) |
| digits | `\d` | `[0-9]` |
| word characters | `\w` | `[A-Za-z0-9_]` |
| not space | `\S` | `[^ ]` |
| not digits | `\D` | `[^0-9]` |
| not word characters | `\W` | `[^A-Za-z0-9_]` |

### Patterns

Patterns are sequences of characters that define a search criteria. In regular expressions, patterns can include literal characters, metacharacters, and special sequences.

Example: Matching a user when searching a directory listing

```bash
ls -l | awk '$4 ~ /rodney-gauna/ {print $4 $7}'
```

Example output:

```text
rodney-gauna /home/rodney-gauna
```

Example: Matching a user (begins with) when searching a directory listing

```bash
ls -l | awk '$4 ~ /^rodney/ {print $4 $7}'
```

Example output:

```text
rodney-gauna /home/rodney-gauna

Example: Matching a user (ends with) when searching a directory listing

```bash
ls -l | awk '$4 ~ /gauna$/ {print $4 $7}'
```

Example output:

```text
rodney-gauna /home/rodney-gauna
```

### Ranges

Ranges allow you to specify a set of characters to match. You can define a range using square brackets `[]`.

Example: Matching users with names starting with letters 'a' to 'm'

```bash
ls -l | awk '$4 ~ /^[a-m]/ {print $4 $7}'
```

Example output of the first few lines:

```text
aaron /home/aaron
adam /home/adam
alice /home/alice
```

### Alternations

Alternations allow you to match one of several patterns using the `\|` operator.

Example: Matching a user (either "rodney" or "alice") when searching a directory listing

```bash
ls -l | awk '$4 ~ /rodney\|alice/ {print $4 $7}'
```

Example output:

```text
rodney-gauna /home/rodney-gauna
alice-smith /home/alice-smith
```

### Repeatition

Repetition allows you to specify how many times an element should appear using `*`, `+`, `?`, or `{min,max}`.

Example: Matching users with names that start with "rod" followed by one or more characters

```bash
ls -l | awk '$4 ~ /rod+/ {print $4 $7}'
```

Example output:

```text
rodney-gauna /home/rodney-gauna
rodman /home/rodman
rodddy /home/rodddyy
```

### Grouping

Grouping allows you to combine multiple elements into a single unit using parentheses `()`.

Example: Matching users with names that start with "rod" followed by any characters

```bash
ls -l | awk '$4 ~ /(rod).*/ {print $4 $7}'
```

Example output:

```text
rodney-gauna /home/rodney-gauna
rodman /home/rodman
```

### Extracting Matches

There are instances when you want to extract what you matched. You can use tools like `grep`, `sed`, or `awk` to extract matches.

Let's use the "somexmllog.xml" file to demonstrate extracting matches.

```xml
<run1><time>1234</time><description>my text 1</description></run1>
<run2><time>1234</time><description>my text 2</description></run2>
<run3><time>1234</time><description>my text lkdfgjlkdf 3</description></run3>
```

Example: Extract the text between `<description>` and `</description>` but do not include the tags themselves.

```bash
cat somexmllog.xml | egrep `/<description>([^<]+)<\/description>/` -o
```

Example output:

```text
my text 1
my text 2
my text lkdfgjlkdf 3
```

### What to Do If You Cannot Find a Pattern?

Sometimes, you may encounter situations where you cannot find a specific pattern using regular expressions. Here are some strategies to help you in such cases:

- Break down the pattern into smaller components and try to match each component separately.
- Use online regex testers to experiment with different patterns and see how they match your input.
- Consult documentation or resources for the specific tool you are using, as different tools may have variations in regex syntax.
- Practice with simpler patterns and gradually build up to more complex ones.

### Some Examples

#### Matching an IP Address

```bash
cat /var/log/syslog | egrep -o '([0-9]{1,3}\.){3}[0-9]{1,3}'
```

```text
192.168.1.1
10.0.0.1
```

Explanation:

- `([0-9]{1,3}\.){3}` matches three octets followed by a dot.
- `[0-9]{1,3}` matches the last octet.

#### Matching Phone Numbers

```bash
cat contacts.txt | egrep -o '\(?[0-9]{3}\)?[-. ]?[0-9]{3}[-. ]?[0-9]{4}'
```

```text
(123) 456-7890
123-456-7890
123.456.7890
```

Explanation:

- `\(?[0-9]{3}\)?` matches an optional area code with parentheses.
- `[-. ]?` matches an optional separator (dash, dot, or space).
- `[0-9]{3}` matches the next three digits.
- `[-. ]?` matches another optional separator.
- `[0-9]{4}` matches the last four digits.

#### Matching Email Addresses

```bash
cat emails.txt | egrep -o '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}'
```

```text
user@example.com
john.doe@gmail.com
alice.smith@company.org
```

Explanation:

- `[a-zA-Z0-9._%+-]+` matches the email username.
- `@` matches the "at" symbol.
- `[a-zA-Z0-9.-]+` matches the domain name.
- `\.[a-zA-Z]{2,}` matches the top-level domain (TLD).

#### Finding Repetitions in the String

```bash
echo "abc abc abc" | egrep -o '(abc ){2,}'
```

```text
abc abc abc
```

Explanation:

- `(abc ){2,}` matches the string "abc " repeated two or more times.

#### Sanitizing the Input

```bash
echo "<script>alert('Hello');</script>" | sed 's/<[^>]*>//g'
```

```text
alert('Hello');
```

Explanation:

- `(abc ){2,}` matches the string "abc " repeated two or more times.

```bash
echo "<script>alert('Hello');</script>" | sed 's/<[^>]*>//g'
```

```text
alert('Hello');
```

Explanation:

- `s/<[^>]*>//g` removes all HTML tags from the input.
