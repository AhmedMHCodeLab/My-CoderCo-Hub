# OverTheWire Bandit - Levels 00 to 20

## Level 0 - SSH Login

### 🎯 Objective
Establish SSH connection to a remote server on a non-standard port (2220) using the given credentials.

### 🧠 Thought Process
Default SSH assumes port 22. I recalled the `-p` flag to override the port.  
No additional authentication methods or private keys were required — simple user/password login.

### 🔐 Credentials
- **Username:** `bandit0`
- **Password:** `bandit0`
- **Host:** `bandit.labs.overthewire.org`
- **Port:** `2220`

### 💻 Command Used
```bash
ssh bandit0@bandit.labs.overthewire.org -p 2220
```

### 🛠️ Troubleshooting
- Initial attempt without -p 2220 failed → confirmed I understood the default behavior of ssh
- Used -v for verbose output to verify connection steps

### 📚 Lessons Learned
- SSH defaults to port 22 unless overridden
- Always read instructions carefully — small details like ports matter
- Repetition builds confidence, even in simple steps

---

## Level 1 - Reading Special Files

### 🎯 Objective
Read the contents of a file named "-" (dash) which is a special filename.

### 🧠 Thought Process
Files with special names like "-" need to be handled carefully in the shell. The dash can be interpreted as stdin/stdout.

### 💻 Command Used
```bash
cat ./-
# or
cat < -
```

### 📚 Lessons Learned
- Special filenames require careful handling
- Using "./" prefix helps avoid interpretation issues
- Alternative approaches include using full paths or redirection

---

## Level 2 - Files with Spaces

### 🎯 Objective
Read a file that contains spaces in its filename.

### 💻 Command Used
```bash
cat "spaces in this filename"
# or
cat spaces\ in\ this\ filename
```

### 📚 Lessons Learned
- Filenames with spaces need quotes or escape characters
- Tab completion can help with complex filenames

---

## Level 3 - Hidden Files

### 🎯 Objective
Find and read a hidden file in a directory.

### 💻 Command Used
```bash
ls -la
cat .hidden
```

### 📚 Lessons Learned
- Hidden files start with a dot (.)
- Use ls -a to show hidden files
- Use ls -la for detailed listing including permissions

---

## Level 4 - Finding Human-Readable Files

### 🎯 Objective
Find the only human-readable file among several files.

### 💻 Command Used
```bash
file ./*
cat ./-file07
```

### 📚 Lessons Learned
- The `file` command identifies file types
- Most files contain binary data, look for "ASCII text"

---

## Level 5 - File with Specific Properties

### 🎯 Objective
Find a file with specific properties: human-readable, 1033 bytes, not executable.

### 💻 Command Used
```bash
find . -type f -size 1033c ! -executable
cat ./maybehere07/.file2
```

### 📚 Lessons Learned
- `find` command with multiple criteria
- `-size 1033c` for exact byte size
- `! -executable` for non-executable files

---

## Level 6 - System-wide File Search

### 🎯 Objective
Find a file owned by user bandit7, group bandit6, and 33 bytes in size.

### 💻 Command Used
```bash
find / -user bandit7 -group bandit6 -size 33c 2>/dev/null
cat /var/lib/dpkg/info/bandit7.password
```

### 📚 Lessons Learned
- Search the entire system with `/`
- Redirect stderr with `2>/dev/null` to hide permission errors
- Ownership and group criteria in find

---

## Level 7 - grep for Text Search

### 🎯 Objective
Find the password next to the word "millionth" in a large file.

### 💻 Command Used
```bash
grep millionth data.txt
```

### 📚 Lessons Learned
- `grep` is essential for text searching
- Works efficiently on large files

---

## Level 8 - Finding Unique Lines

### 🎯 Objective
Find the only line that occurs exactly once in a file.

### 💻 Command Used
```bash
sort data.txt | uniq -u
```

### 📚 Lessons Learned
- `sort` followed by `uniq -u` finds unique lines
- Data must be sorted before using uniq

---

## Level 9 - Strings in Binary Files

### 🎯 Objective
Find human-readable strings in a binary file that start with "=".

### 💻 Command Used
```bash
strings data.txt | grep "^="
```

### 📚 Lessons Learned
- `strings` extracts readable text from binary files
- Combine with grep for pattern matching

---

## Level 10 - Base64 Decoding

### 🎯 Objective
Decode a base64 encoded file.

### 💻 Command Used
```bash
base64 -d data.txt
```

### 📚 Lessons Learned
- `base64 -d` decodes base64 encoded data
- Base64 is a common encoding method

---

## General Tips and Tricks

### Essential Commands
- `ls -la` - List all files including hidden ones
- `find` - Powerful file searching
- `grep` - Text pattern matching
- `cat` - Read file contents
- `file` - Identify file types
- `strings` - Extract readable text from binary files
- `sort` - Sort lines in text
- `uniq` - Find unique/duplicate lines
- `base64` - Encode/decode base64

### Common Patterns
- Always read instructions carefully
- Use tab completion for complex filenames
- Redirect stderr when searching system-wide
- Combine commands with pipes for powerful operations
- Test commands on smaller datasets first

### SSH Connection
```bash
ssh bandit[level]@bandit.labs.overthewire.org -p 2220
```

Remember to replace `[level]` with the current level number.
