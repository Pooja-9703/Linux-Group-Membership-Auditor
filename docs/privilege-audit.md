# Privilege Audit

## Overview

The **Privilege Audit** module evaluates privilege-related configurations on a Linux system to identify security risks that could lead to unauthorized administrative access or privilege escalation. It reviews users with administrative privileges, searches for insecure file permissions, and identifies executables with special permission bits such as **SUID** and **SGID**.

Proper privilege management is one of the most critical aspects of Linux security. Excessive permissions, misconfigured files, or unnecessary privileged executables can significantly increase the attack surface of a system.

---

## Learning Objectives

After reading this document, you should be able to:

- Explain the concept of privileges in Linux.
- Understand the Principle of Least Privilege (PoLP).
- Describe how `sudo` works.
- Explain the purpose of SUID and SGID.
- Understand why world-writable files are dangerous.
- Perform manual privilege-related security checks.
- Understand how the Linux Security Audit Toolkit audits privilege configurations.

---

# Understanding Privileges

A privilege defines what actions a user or process is permitted to perform on a Linux system.

Examples include:

- Reading files
- Modifying files
- Executing programs
- Installing software
- Creating users
- Changing system configuration

Linux determines these privileges using:

- User ownership
- Group ownership
- File permissions
- Special permission bits
- Security policies

The **root** user has unrestricted privileges, while regular users operate with limited permissions.

---

# Principle of Least Privilege (PoLP)

The **Principle of Least Privilege** states that users, applications, and services should be granted only the permissions necessary to perform their intended tasks.

Example:

```text
Database Server

Needs:
✓ Read database files
✓ Write database files

Does NOT Need:
✗ Modify system users
✗ Install software
✗ Change firewall rules
```

Applying least privilege reduces the impact of configuration mistakes and limits what an attacker can do after compromising an account.

---

# Administrative Privileges and sudo

Rather than logging in directly as the root user, Linux systems commonly use the **sudo** mechanism to grant temporary administrative privileges.

Example:

```bash
sudo apt update
```

When a user executes a command using `sudo`, Linux verifies whether that user is authorized according to the **sudoers policy**.

Benefits of using `sudo` include:

- Individual accountability
- Reduced use of the root account
- Controlled privilege delegation
- Improved auditing of administrative actions

---

# Set User ID (SUID)

The **Set User ID (SUID)** permission bit allows an executable file to run with the permissions of its owner instead of the user executing it.

Example:

```text
-rwsr-xr-x
```

Common legitimate example:

```text
/usr/bin/passwd
```

Although a regular user executes the `passwd` program, it temporarily runs with the privileges of its owner (typically root) so that it can update password information.

### Why Does It Matter?

Improperly configured or vulnerable SUID programs can allow attackers to execute commands with elevated privileges.

Administrators should periodically review all SUID binaries and remove unnecessary ones.

---

# Set Group ID (SGID)

The **Set Group ID (SGID)** permission bit allows an executable to run with the permissions of the file's group.

Example:

```text
-rwxr-sr-x
```

When applied to directories, newly created files inherit the directory's group ownership instead of the creator's primary group.

This behavior is commonly used in shared project directories.

### Why Does It Matter?

Improper SGID configuration may unintentionally grant users access to sensitive files or shared resources.

---

# World-Writable Files

A world-writable file allows every user on the system to modify its contents.

Example:

```text
-rw-rw-rw-
```

Such files should be reviewed carefully because attackers may be able to:

- Modify application data
- Replace executable scripts
- Inject malicious code
- Tamper with configuration files

Unless explicitly required, world-writable files should be avoided.

---

# Security Checks Performed

The Privilege Audit module performs the following security checks.

---

## 1. Users with sudo Privileges

The toolkit identifies users who have administrative privileges.

**Purpose**

- Review privileged accounts.
- Verify authorized administrative access.
- Support periodic privilege reviews.

---

## 2. World-Writable Files

The toolkit searches for files that are writable by every user.

**Purpose**

- Detect insecure permissions.
- Reduce opportunities for privilege escalation.
- Improve filesystem security.

---

## 3. SUID Binaries

The toolkit lists executables with the SUID permission bit enabled.

**Purpose**

- Review privileged executables.
- Identify unnecessary SUID programs.
- Detect potential privilege escalation paths.

---

## 4. SGID Binaries

The toolkit lists executables with the SGID permission bit enabled.

**Purpose**

- Review group-based privilege delegation.
- Detect unnecessary SGID binaries.
- Verify secure permission management.

---

# Common Attack Scenarios

## Excessive sudo Privileges

A user is accidentally granted unrestricted `sudo` access.

If the account is compromised, an attacker immediately gains administrative control over the system.

---

## Vulnerable SUID Binary

A vulnerable SUID executable contains a programming flaw that allows arbitrary command execution.

Because the program runs with elevated privileges, an attacker may obtain root access.

---

## World-Writable Startup Script

A startup script executed by a privileged service is world-writable.

An attacker modifies the script, causing malicious commands to execute the next time the service starts.

---

## Misconfigured Shared Directory

A shared directory uses SGID but contains sensitive files accessible to unauthorized users.

Improper group management results in unintended data exposure.

---

# Manual Verification

The following commands can be used to manually perform the same privilege-related checks.

### View sudo group members

```bash
getent group sudo
```

---

### List SUID binaries

```bash
find / -xdev -type f -perm -4000 2>/dev/null
```

---

### List SGID binaries

```bash
find / -xdev -type f -perm -2000 2>/dev/null
```

---

### Find world-writable files

```bash
find / -xdev -type f -perm -0002 2>/dev/null
```

---

# Commands Used in This Audit

| Command | Purpose |
|---------|---------|
| `getent` | Retrieve group information for administrative groups. |
| `find` | Locate world-writable files and SUID/SGID binaries. |
| `stat` | Display file ownership and permission details. |
| `grep` | Search for relevant configuration values. |
| `awk` | Process structured command output. |

---

# How the Toolkit Implements These Checks

High-level workflow:

```text
Identify Administrative Users

            │

            ▼

Locate World-Writable Files

            │

            ▼

Locate SUID Binaries

            │

            ▼

Locate SGID Binaries

            │

            ▼

Generate Findings
```

The toolkit performs read-only inspections using standard Linux utilities and does not modify any system configuration.

---

# Expected Findings

A properly configured Linux system should typically have:

- A limited number of users with administrative privileges.
- No unexpected world-writable files.
- Only legitimate SUID binaries.
- Only necessary SGID binaries.

Unexpected findings should be reviewed to determine whether they are legitimate system requirements or potential security risks.

---

# Severity Levels

| Severity | Meaning |
|----------|---------|
| **INFO** | Informational finding requiring no action. |
| **LOW** | Minor security concern. |
| **MEDIUM** | Configuration should be reviewed. |
| **HIGH** | Significant security risk requiring immediate attention. |

---

# Security Best Practices

- Follow the Principle of Least Privilege.
- Grant administrative privileges only to trusted users.
- Review membership in privileged groups regularly.
- Remove unnecessary SUID and SGID binaries.
- Eliminate unnecessary world-writable files.
- Periodically audit file permissions.
- Monitor privilege changes on production systems.

---

# Related Documentation

- User Audit
- Group Audit
- Filesystem Security Audit
- Password Policy Audit

---

# References

- `man sudo`
- `man sudoers`
- `man chmod`
- `man find`
- `man stat`
- CIS Benchmarks for Linux
- NIST SP 800-53 AC-6 (Least Privilege)
- Red Hat Enterprise Linux Security Guide
- Ubuntu Server Guide
