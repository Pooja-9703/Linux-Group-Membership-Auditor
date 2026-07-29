# Filesystem Security Audit

## Overview

The **Filesystem Security Audit** module examines the Linux filesystem for insecure permissions, ownership issues, and misconfigurations that could expose the system to unauthorized access or privilege escalation. It reviews directories, files, ownership information, and critical system files to identify common security risks.

The Linux filesystem is one of the primary security boundaries of an operating system. Every application, user, and service interacts with files and directories. Improper permissions or ownership can allow attackers to modify sensitive files, access confidential information, or execute malicious code.

---

## Learning Objectives

After reading this document, you should understand:

- How Linux file permissions work.
- The importance of file ownership.
- What world-writable files and directories are.
- What orphaned files and groups are.
- Why hidden files should be reviewed.
- Why critical system files require strict permissions.
- How the Linux Security Audit Toolkit performs filesystem security checks.

---

# Understanding the Linux Filesystem

Everything in Linux is represented as a file.

Examples include:

- Regular files
- Directories
- Devices
- Sockets
- Pipes
- Symbolic links

Each filesystem object has:

- Owner
- Group
- Permissions

Example:

```text
-rwxr-xr--
```

Every access request is evaluated against these attributes before Linux grants or denies access.

---

# File Ownership

Every file belongs to:

- One user (Owner)
- One group (Group)

Example:

```text
Owner : alice
Group : developers
```

Ownership determines who can modify a file and who can change its permissions.

---

# File Permissions

Each file has three permission sets:

```text
Owner

Group

Others
```

Each set contains:

- Read (r)
- Write (w)
- Execute (x)

Example:

```text
-rwxr-xr--
```

Permission breakdown:

```text
Owner : rwx
Group : r-x
Others: r--
```

Linux checks permissions in the following order:

1. Owner
2. Group
3. Others

---

# World-Writable Directories

A world-writable directory allows any user on the system to create, delete, or modify files within that directory.

Example:

```text
drwxrwxrwx
```

Not every world-writable directory is insecure.

For example:

```text
/tmp
```

is intentionally world-writable but protected using the **Sticky Bit**, which prevents users from deleting files owned by others.

However, unexpected world-writable directories should be reviewed because they may allow attackers to place malicious files or interfere with application data.

---

# Sticky Bit

The **Sticky Bit** is a special permission applied to directories.

Example:

```text
drwxrwxrwt
```

When the Sticky Bit is set:

- Users can create files.
- Users cannot delete files owned by other users.
- The directory remains suitable for shared temporary storage.

Without the Sticky Bit, any user with write permission could delete another user's files.

---

# World-Writable Files

A world-writable file allows every user on the system to modify its contents.

Example:

```text
-rw-rw-rw-
```

These files should be reviewed carefully because they may allow:

- Data modification
- Configuration tampering
- Malicious code injection
- Privilege escalation

Unless explicitly required, world-writable files should be avoided.

---

# Orphaned Files

An orphaned file is owned by a User ID (UID) that no longer exists on the system.

Example:

```text
Owner UID : 1050

↓

User deleted

↓

File still exists
```

Orphaned files often remain after user accounts are removed.

Although they may not immediately create a vulnerability, they complicate permission management and may unintentionally become accessible if the UID is later reused.

---

# Orphaned Groups

An orphaned group occurs when a file references a Group ID (GID) that no longer exists.

Example:

```text
Group GID : 1100

↓

Group deleted

↓

File still exists
```

These files should be reviewed to ensure ownership remains accurate.

---

# Hidden Files

Hidden files begin with a period (`.`).

Example:

```text
.bashrc
.profile
.ssh
.gitconfig
```

Hidden files are commonly used to store:

- Shell configuration
- SSH keys
- Application settings
- User preferences

Hidden files are not inherently suspicious. However, unexpected hidden files or directories may indicate unauthorized software or attempts to conceal malicious content.

---

# Critical System Files

Certain files are essential to the operation and security of Linux.

Examples include:

- `/etc/passwd`
- `/etc/shadow`
- `/etc/group`
- `/etc/gshadow`
- `/etc/sudoers`

These files should have restrictive permissions to prevent unauthorized modification.

For example:

```text
/etc/shadow
```

should only be readable by privileged users because it stores password hashes.

---

# Security Checks Performed

The Filesystem Security Audit module performs the following checks.

---

## 1. World-Writable Directories

Purpose:

- Identify directories writable by all users.
- Detect missing Sticky Bit protection.
- Review shared directories.

---

## 2. World-Writable Files

Purpose:

- Identify files writable by all users.
- Detect insecure permissions.
- Reduce opportunities for privilege escalation.

---

## 3. Orphaned Files

Purpose:

- Identify files whose owners no longer exist.
- Maintain accurate ownership records.
- Improve filesystem hygiene.

---

## 4. Orphaned Groups

Purpose:

- Detect files associated with deleted groups.
- Ensure correct group ownership.

---

## 5. Hidden Files

Purpose:

- Review hidden configuration files.
- Detect unexpected hidden content.
- Support system auditing.

---

## 6. Critical System File Permissions

The toolkit verifies permissions for important system files, including:

- `/etc/passwd`
- `/etc/shadow`
- `/etc/group`
- `/etc/gshadow`
- `/etc/sudoers`

Purpose:

- Verify secure permissions.
- Detect accidental misconfigurations.
- Protect authentication and authorization data.

---

# Common Attack Scenarios

### World-Writable Configuration File

An attacker discovers that a configuration file is writable by every user.

The attacker modifies the file, causing a privileged service to execute malicious commands when it restarts.

---

### Missing Sticky Bit

A shared directory is world-writable but lacks the Sticky Bit.

A malicious user deletes another user's files, causing data loss or disrupting applications.

---

### Weak Permissions on `/etc/shadow`

If an attacker gains read access to `/etc/shadow`, they may attempt offline password-cracking attacks against stored password hashes.

---

### Hidden Malware

An attacker stores malicious scripts in a hidden directory within a user's home folder to avoid casual detection.

Regular filesystem audits can help identify such artifacts.

---

# How the Toolkit Implements These Checks

The Filesystem Security Audit module performs several permission and ownership inspections.

High-level workflow:

```text
Scan filesystem

↓

Identify world-writable directories

↓

Identify world-writable files

↓

Locate orphaned files

↓

Locate orphaned groups

↓

Review hidden files

↓

Verify permissions of critical system files

↓

Generate findings
```

The implementation relies on standard Linux utilities, including:

- `find`
- `stat`
- `ls`
- `awk`
- `grep`

These commands allow the toolkit to inspect filesystem metadata without modifying files or permissions.

---

# Security Best Practices

- Apply the Principle of Least Privilege to files and directories.
- Remove unnecessary world-writable permissions.
- Use the Sticky Bit on shared writable directories such as `/tmp`.
- Periodically review hidden files and directories.
- Correct orphaned file and group ownership.
- Protect critical system files with restrictive permissions.
- Perform regular filesystem audits to detect permission drift.

---

# References

- `man chmod`
- `man chown`
- `man find`
- `man stat`
- `man ls`
- Linux Filesystem Hierarchy Standard (FHS)
- CIS Linux Benchmark
- Red Hat Enterprise Linux Security Guide
- Ubuntu Server Guide
