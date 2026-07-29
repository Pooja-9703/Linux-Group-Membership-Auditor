# Privilege Audit

## Overview

The **Privilege Audit** module examines user privileges and file permissions to identify configurations that could allow unauthorized users to gain elevated access. It reviews users with administrative privileges, detects insecure file permissions, and identifies special permission bits that may introduce privilege escalation risks.

Privilege management is a fundamental aspect of Linux security. Improperly configured privileges can allow attackers to execute administrative commands, modify sensitive files, or gain complete control of a system.

---

## Learning Objectives

After reading this document, you should understand:

- What privileges are in Linux.
- The principle of least privilege.
- How `sudo` works.
- What SUID and SGID are.
- Why world-writable files are dangerous.
- How attackers abuse permission misconfigurations.
- How the Linux Security Audit Toolkit performs privilege-related security checks.

---

# Understanding Privileges

A privilege determines what actions a user or process is permitted to perform on a Linux system.

Examples include:

- Reading files
- Writing files
- Executing programs
- Managing users
- Installing software
- Changing system configuration

Linux grants these privileges based on:

- User ownership
- Group ownership
- File permissions
- Special permission bits
- Capabilities (advanced feature)

The root user has unrestricted privileges, while regular users operate with limited permissions.

---

# The Principle of Least Privilege

The **Principle of Least Privilege (PoLP)** states that users and processes should have only the permissions required to perform their intended tasks.

For example:

```text
Web Server

Needs:
✓ Read website files
✓ Bind to network ports

Does NOT need:
✗ Create user accounts
✗ Modify system configuration
✗ Access another user's files
```

Applying least privilege reduces the impact of accidental mistakes and limits the damage an attacker can cause after compromising an account.

---

# Administrative Privileges and sudo

Linux systems discourage logging in directly as the root user for everyday administration.

Instead, authorized users temporarily elevate their privileges using the `sudo` command.

Example:

```bash
sudo apt update
```

When a user runs a command with `sudo`, the system checks whether that user is authorized according to the `/etc/sudoers` configuration or associated policy files.

Using `sudo` instead of logging in as root improves accountability because administrative actions can be associated with individual user accounts.

---

# Understanding Linux File Permissions

Every file and directory has three permission sets:

```text
Owner

Group

Others
```

Each permission set contains:

- Read (r)
- Write (w)
- Execute (x)

Example:

```text
-rwxr-xr--
```

Breakdown:

```text
Owner : rwx
Group : r-x
Others: r--
```

These permissions determine who can access or modify a file.

---

# Special Permission Bits

Linux provides three special permission bits:

- SUID
- SGID
- Sticky Bit

This module focuses on SUID and SGID because they may affect privilege management.

---

## Set User ID (SUID)

When the **SUID** bit is set on an executable file, the program runs with the permissions of the file owner rather than the user executing it.

Example:

```text
-rwsr-xr-x
```

Common legitimate example:

```text
/usr/bin/passwd
```

Although ordinary users execute the `passwd` program, it temporarily runs with root privileges to update password information.

### Security Risks

Poorly designed or vulnerable SUID programs may allow attackers to execute commands with elevated privileges, potentially leading to privilege escalation.

Administrators should regularly review SUID binaries and remove unnecessary ones.

---

## Set Group ID (SGID)

The **SGID** bit causes an executable to run with the permissions of the file's group.

On directories, newly created files inherit the directory's group ownership.

Example:

```text
-rwxr-sr-x
```

### Security Risks

Unnecessary SGID binaries or directories may allow users to gain unintended access to shared resources.

Regular auditing helps ensure SGID is applied only where required.

---

# World-Writable Files

A world-writable file allows any user on the system to modify its contents.

Example:

```text
-rw-rw-rw-
```

### Why Is This Dangerous?

If a privileged application relies on a world-writable file, an attacker may be able to:

- Modify application behavior.
- Inject malicious data.
- Replace scripts.
- Escalate privileges.

World-writable files should be carefully reviewed and restricted whenever possible.

---

# Security Checks Performed

The Privilege Audit module performs the following checks.

---

## 1. Users with sudo Privileges

The toolkit identifies users who can execute commands with administrative privileges.

Purpose:

- Review privileged accounts.
- Verify that administrative access is granted only to authorized users.
- Support periodic access reviews.

---

## 2. World-Writable Files

The toolkit searches for files that are writable by all users.

Purpose:

- Identify potential privilege escalation paths.
- Detect insecure permission configurations.
- Support file permission hardening.

---

## 3. SUID Binaries

The toolkit lists executable files with the SUID permission bit.

Purpose:

- Review privileged executables.
- Identify unexpected or unnecessary SUID programs.
- Detect potential privilege escalation opportunities.

---

## 4. SGID Binaries

The toolkit lists executable files with the SGID permission bit.

Purpose:

- Review shared privilege mechanisms.
- Detect unnecessary SGID executables.
- Support secure permission management.

---

# How the Toolkit Implements These Checks

The Privilege Audit module performs several permission-based inspections.

High-level workflow:

```text
Identify privileged users

↓

Search for world-writable files

↓

Locate SUID binaries

↓

Locate SGID binaries

↓

Generate findings
```

The implementation uses standard Linux utilities, including:

- `find`
- `stat`
- `getent`
- `grep`
- `awk`

These commands allow the toolkit to inspect system permissions without modifying the system.

---

# Security Best Practices

- Grant administrative privileges only to trusted users.
- Review membership in the `sudo` or `wheel` group regularly.
- Follow the Principle of Least Privilege.
- Remove unnecessary SUID and SGID binaries.
- Restrict world-writable files.
- Monitor permission changes on critical system files.
- Perform regular privilege audits as part of routine system maintenance.

---

# References

- `man sudo`
- `man sudoers`
- `man chmod`
- `man find`
- `man stat`
- Linux Filesystem Hierarchy Standard (FHS)
- CIS Linux Benchmark
- Red Hat Enterprise Linux Security Guide
- Ubuntu Server Guide
