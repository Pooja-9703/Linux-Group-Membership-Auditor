# Linux File Permissions

## Overview

Linux file permissions determine who can read, modify, or execute files and directories. Every file and directory has an associated owner, group, and permission set that controls access to system resources.

Understanding file permissions is fundamental to Linux system administration and security. Proper permission management helps protect sensitive files, enforce access control, and reduce the risk of unauthorized access or privilege escalation.

---

## Learning Objectives

After reading this document, you should be able to:

- Understand Linux file ownership.
- Interpret symbolic and numeric permission notation.
- Modify file permissions and ownership.
- Explain special permission bits such as SUID, SGID, and Sticky Bit.
- Understand the role of `umask`.
- Apply permission management best practices.

---

# Linux Permission Model

Every file and directory in Linux has three permission categories:

- **Owner (User)** – The user who owns the file.
- **Group** – Users belonging to the file's assigned group.
- **Others** – All remaining users on the system.

Permissions are evaluated in this order:

```text
Owner
   │
   ▼
Group
   │
   ▼
Others
```

Each category has its own set of permissions.

---

# Permission Types

Linux defines three basic permissions.

| Permission | Symbol | Meaning |
|------------|--------|---------|
| Read | `r` | View the contents of a file or list a directory. |
| Write | `w` | Modify a file or create/delete files within a directory (subject to directory permissions). |
| Execute | `x` | Run a file as a program or access a directory. |

---

# Viewing Permissions

Use the `ls -l` command to display permissions.

```bash
ls -l
```

Example output:

```text
-rwxr-xr-- 1 user developers 4096 Jul 29 script.sh
```

Breaking it down:

```text
- rwx r-x r--

│ │   │   │
│ │   │   └── Others
│ │   └────── Group
│ └────────── Owner
└──────────── File Type
```

---

# File Types

The first character indicates the file type.

| Symbol | File Type |
|--------|-----------|
| `-` | Regular file |
| `d` | Directory |
| `l` | Symbolic link |
| `c` | Character device |
| `b` | Block device |
| `p` | Named pipe |
| `s` | Socket |

---

# Numeric (Octal) Permissions

Permissions can also be represented numerically.

| Permission | Value |
|------------|------:|
| Read (`r`) | 4 |
| Write (`w`) | 2 |
| Execute (`x`) | 1 |

The values are added together.

| Permission | Value |
|------------|------:|
| `rwx` | 7 |
| `rw-` | 6 |
| `r-x` | 5 |
| `r--` | 4 |
| `-wx` | 3 |
| `-w-` | 2 |
| `--x` | 1 |
| `---` | 0 |

Common permission settings:

| Numeric | Symbolic | Typical Use |
|---------:|----------|-------------|
| 644 | `rw-r--r--` | Regular files |
| 755 | `rwxr-xr-x` | Executable files and directories |
| 600 | `rw-------` | Private files |
| 700 | `rwx------` | Private directories or scripts |

---

# Changing Permissions

The `chmod` command modifies file permissions.

Using numeric notation:

```bash
chmod 755 script.sh
```

Using symbolic notation:

```bash
chmod u+x script.sh
```

Examples:

```bash
chmod 644 file.txt

chmod 600 secrets.txt

chmod 755 backup.sh
```

---

# Changing Ownership

The `chown` command changes file ownership.

```bash
sudo chown alice file.txt
```

Change both owner and group:

```bash
sudo chown alice:developers file.txt
```

---

# Changing Group Ownership

The `chgrp` command changes the group assigned to a file.

```bash
chgrp developers file.txt
```

---

# Special Permission Bits

Linux supports three special permission bits.

## SUID (Set User ID)

When applied to an executable, the program runs with the permissions of the file owner instead of the user executing it.

Example:

```text
-rwsr-xr-x
```

Common example:

```text
/usr/bin/passwd
```

---

## SGID (Set Group ID)

When applied to an executable, the program runs with the permissions of the file's group.

When applied to a directory, newly created files inherit the directory's group ownership.

Example:

```text
-rwxr-sr-x
```

---

## Sticky Bit

The Sticky Bit is commonly applied to shared directories.

Example:

```text
drwxrwxrwt
```

When enabled, users can delete only files they own, even if the directory is writable by everyone.

A common example is:

```text
/tmp
```

---

# Default File Permissions (umask)

The `umask` value determines which permissions are removed when new files and directories are created.

View the current umask:

```bash
umask
```

Example:

```text
0022
```

Typical defaults:

| umask | New Files | New Directories |
|-------:|-----------|-----------------|
| 022 | 644 | 755 |
| 027 | 640 | 750 |
| 077 | 600 | 700 |

---

# Security Best Practices

- Follow the Principle of Least Privilege.
- Grant write access only when necessary.
- Review file ownership regularly.
- Remove unnecessary SUID and SGID binaries.
- Avoid world-writable files.
- Use restrictive permissions for sensitive files.
- Audit file permissions periodically.

---

# Common Commands

| Command | Purpose |
|---------|---------|
| `ls -l` | Display file permissions and ownership. |
| `chmod` | Change file permissions. |
| `chown` | Change file owner and group. |
| `chgrp` | Change file group ownership. |
| `stat` | Display detailed file metadata. |
| `umask` | View or modify the default permission mask. |

---

# References

- `man chmod`
- `man chown`
- `man chgrp`
- `man umask`
- `man stat`
- GNU Core Utilities Documentation
- Linux Filesystem Hierarchy Standard (FHS)
- Red Hat Enterprise Linux Documentation
