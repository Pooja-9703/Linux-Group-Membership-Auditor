# User Audit

## Overview

The **User Audit** module examines user accounts configured on a Linux system to identify common security issues related to user identities and authentication. It reviews user account information, detects potentially dangerous configurations, and helps administrators verify that user accounts follow security best practices.

User account auditing is one of the first steps in securing a Linux system because every authenticated action is performed under a user identity. Misconfigured accounts, duplicate user identifiers, or improperly secured authentication settings can lead to privilege escalation, unauthorized access, and inaccurate audit trails.

---

## Learning Objectives

After reading this document, you should understand:

- How Linux identifies users.
- The purpose of User IDs (UIDs).
- The difference between regular users, system users, and the root account.
- The role of `/etc/passwd` and `/etc/shadow`.
- Why duplicate UIDs and multiple UID 0 accounts are security risks.
- How the Linux Security Audit Toolkit performs user security checks.

---

# Linux User Management

Linux is a multi-user operating system. Every process executes under the identity of a user account.

Each user has:

- Username
- User ID (UID)
- Primary Group ID (GID)
- Home directory
- Login shell

Example:

```text
alice:x:1000:1000:Alice:/home/alice:/bin/bash
```

Linux uses the **UID**, not the username, to determine ownership and permissions.

---

## Types of User Accounts

### Root User

The root account is the system administrator.

Characteristics:

- UID = 0
- Unrestricted access
- Can modify any file
- Can install software
- Can create or delete users
- Can change permissions

Because the root account bypasses nearly all permission checks, only one account should normally have UID 0.

---

### Regular Users

Regular users perform everyday tasks.

Typical UID ranges:

- Ubuntu: 1000+
- RHEL/CentOS: 1000+

Regular users have limited permissions and require elevated privileges (such as `sudo`) for administrative tasks.

---

### System Users

System users are created for services and background processes.

Examples include:

- daemon
- nobody
- www-data
- mysql
- sshd

These accounts usually cannot log in interactively and exist solely to isolate system services.

---

# Understanding User IDs (UIDs)

A **User ID (UID)** is the numerical identifier assigned to every user account.

Although administrators recognize users by name, the Linux kernel uses the UID internally.

Example:

```text
Username : alice
UID      : 1001
```

When a process accesses a file, Linux compares the file owner's UID with the process's UID to determine whether access should be granted.

---

## Why UID Matters

Permissions are assigned to UIDs—not usernames.

For example:

```text
alice (UID 1001)

↓

Creates report.txt

↓

Owner = UID 1001
```

If another account is accidentally assigned the same UID, Linux treats both accounts as the same owner for permission checks.

This can lead to unauthorized access and inaccurate auditing.

---

# Important Files

## /etc/passwd

The `/etc/passwd` file stores basic user account information.

Example:

```text
root:x:0:0:root:/root:/bin/bash
```

Field breakdown:

| Field | Description |
|------|-------------|
| Username | Account name |
| Password Placeholder | Usually `x` (actual password hash stored elsewhere) |
| UID | User Identifier |
| GID | Primary Group Identifier |
| Comment | User information |
| Home Directory | Default login directory |
| Login Shell | Shell executed after login |

---

## /etc/shadow

The `/etc/shadow` file stores password hashes and password aging information.

Unlike `/etc/passwd`, only privileged users can read this file.

It contains:

- Password hashes
- Password expiration dates
- Password warning periods
- Account expiration information

Protecting `/etc/shadow` is essential because exposure of password hashes can facilitate offline password-cracking attacks.

---

# Security Checks Performed

The User Audit module performs the following checks.

## 1. List All System Users

The toolkit lists every configured user account.

Purpose:

- Verify expected accounts
- Identify unused accounts
- Review service accounts

---

## 2. Multiple UID 0 Accounts

Normally:

```text
root
UID = 0
```

Dangerous example:

```text
root
UID = 0

admin
UID = 0

backup
UID = 0
```

Any account with UID 0 has full administrative privileges.

Multiple UID 0 accounts make accountability difficult and increase the attack surface.

---

## 3. Duplicate UIDs

The toolkit searches for multiple accounts sharing the same UID.

Example:

```text
alice
UID = 1001

bob
UID = 1001
```

Because Linux authorizes access based on UID, duplicate UIDs may allow one user to access files owned by another.

---

## 4. Passwordless Accounts

The toolkit checks for accounts that do not require a password.

Passwordless accounts may allow unauthorized logins if additional security controls are not in place.

---

# How the Toolkit Implements These Checks

The User Audit module reads user information from `/etc/passwd` and `/etc/shadow`.

High-level workflow:

```text
Read user database

↓

Extract usernames and UIDs

↓

Count users

↓

Identify UID 0 accounts

↓

Detect duplicate UIDs

↓

Inspect password status

↓

Generate findings
```

The implementation relies on standard Linux utilities such as:

- `awk`
- `cut`
- `sort`
- `uniq`
- `grep`

---

# Security Best Practices

- Maintain only one UID 0 account whenever possible.
- Remove unused user accounts.
- Disable interactive logins for service accounts.
- Review user accounts regularly.
- Enforce strong password policies.
- Avoid shared user accounts.
- Periodically audit `/etc/passwd` and `/etc/shadow`.

---

# References

- `man passwd`
- `man shadow`
- `man useradd`
- Linux Filesystem Hierarchy Standard (FHS)
- CIS Linux Benchmark
- Red Hat Enterprise Linux Security Guide
- Ubuntu Server Guide
