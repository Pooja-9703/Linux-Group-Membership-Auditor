# User Audit

## Overview

The **User Audit** module examines user accounts configured on a Linux system to identify common security misconfigurations related to user identities and authentication. It reviews account information stored by the operating system and performs several security checks that help administrators detect privileged accounts, duplicate identifiers, and weak authentication configurations.

Since every process in Linux executes under the identity of a user account, auditing users is one of the first steps in assessing the overall security of a system.

---

## Learning Objectives

After reading this document, you should be able to:

- Understand how Linux identifies users.
- Explain the purpose of User IDs (UIDs).
- Differentiate between regular, system, and root accounts.
- Describe the purpose of `/etc/passwd` and `/etc/shadow`.
- Understand why duplicate UIDs and multiple UID 0 accounts are security risks.
- Explain how the Linux Security Audit Toolkit performs user-related security checks.

---

# Linux User Accounts

Linux is a multi-user operating system. Every process runs under the identity of a user account, and the permissions assigned to that account determine what the process can access or modify.

Each user account contains information such as:

- Username
- User ID (UID)
- Primary Group ID (GID)
- Home directory
- Login shell

Example:

```text
alice:x:1000:1000:Alice:/home/alice:/bin/bash
```

Although administrators typically identify users by name, Linux internally uses the **User ID (UID)** when making permission decisions.

---

# Types of User Accounts

## Root User

The **root** account is the system administrator.

Characteristics:

- UID = 0
- Full access to the operating system
- Can modify any file
- Can install or remove software
- Can create or delete users
- Can change system configuration

Because the root account bypasses nearly all permission checks, only one account should normally have UID 0.

---

## Regular Users

Regular users perform everyday tasks such as logging into the system, creating files, and running applications.

Typical UID ranges:

| Distribution | Default Starting UID |
|--------------|---------------------:|
| Ubuntu | 1000 |
| Debian | 1000 |
| RHEL / CentOS | 1000 |

Regular users have limited permissions and must use mechanisms such as `sudo` to perform administrative tasks.

---

## System Users

System users are created for services and background processes rather than interactive logins.

Common examples include:

- daemon
- nobody
- www-data
- mysql
- sshd

These accounts typically have no valid login shell and exist to isolate system services from one another.

---

# Understanding User IDs (UIDs)

Every user account is assigned a unique numerical identifier known as the **User ID (UID)**.

Example:

```text
Username : alice
UID      : 1001
```

Although usernames are easier for humans to remember, the Linux kernel uses the UID internally when evaluating file ownership and permissions.

For example:

```text
alice (UID 1001)

↓

Creates report.txt

↓

Owner = UID 1001
```

If another account is assigned the same UID, Linux treats both accounts as the same owner for permission checks.

---

# Important User Account Files

## `/etc/passwd`

The `/etc/passwd` file stores basic information about every user account.

Example:

```text
root:x:0:0:root:/root:/bin/bash
```

Field breakdown:

| Field | Description |
|-------|-------------|
| Username | User account name |
| Password Placeholder | Usually `x`; password hash is stored in `/etc/shadow` |
| UID | User Identifier |
| GID | Primary Group Identifier |
| GECOS | User information (full name, comments, etc.) |
| Home Directory | User's default working directory |
| Login Shell | Program started after login |

The file is readable by all users because many applications need access to basic account information.

---

## `/etc/shadow`

The `/etc/shadow` file stores password hashes and password aging information.

Unlike `/etc/passwd`, this file is readable only by privileged users.

It contains:

- Password hashes
- Password expiration dates
- Password warning periods
- Account expiration information

Restricting access to `/etc/shadow` helps prevent attackers from obtaining password hashes for offline password-cracking attacks.

---

# Security Checks Performed

The User Audit module performs the following security checks.

---

## 1. List All System Users

The toolkit enumerates every configured user account.

**Purpose**

- Review all user accounts.
- Identify unused or unexpected accounts.
- Verify service accounts.

---

## 2. Multiple UID 0 Accounts

Normally, only the root account should have UID 0.

Example:

```text
root
UID = 0
```

Potentially insecure configuration:

```text
root
UID = 0

admin
UID = 0

backup
UID = 0
```

Every account with UID 0 receives unrestricted administrative privileges.

Maintaining multiple UID 0 accounts reduces accountability and increases the attack surface.

---

## 3. Duplicate UIDs

The toolkit checks whether multiple accounts share the same UID.

Example:

```text
alice
UID = 1001

bob
UID = 1001
```

Since Linux authorizes access based on the UID rather than the username, duplicate UIDs may allow one account to access files owned by another.

Duplicate UIDs also make system auditing and forensic investigations more difficult.

---

## 4. Passwordless Accounts

The toolkit identifies accounts that do not require a password for authentication.

Passwordless accounts may increase the risk of unauthorized access if additional authentication controls are not implemented.

Service accounts that are intentionally configured without passwords should still be reviewed to ensure they cannot be used for interactive logins.

---

# Common Attack Scenarios

## Unauthorized Administrative Account

An attacker who gains administrative access may create another account with UID 0 to maintain persistent root access while avoiding casual inspection of the root account.

Regular user audits help identify unexpected UID 0 accounts.

---

## Duplicate UID Abuse

An administrator accidentally assigns an existing UID to a new user.

Although the usernames differ, Linux treats both accounts as the same owner for permission checks, allowing unintended access to files and directories.

---

## Forgotten User Accounts

Former employee accounts that remain active may provide attackers with valid login credentials if the passwords are compromised or reused.

Regular account reviews help identify unused accounts that should be disabled or removed.

---

# How the Toolkit Implements These Checks

The User Audit module retrieves account information from the Linux user database and performs several validation steps.

High-level workflow:

```text
Read user account database

        ↓

Extract usernames and UIDs

        ↓

Count user accounts

        ↓

Identify UID 0 accounts

        ↓

Detect duplicate UIDs

        ↓

Review password configuration

        ↓

Generate findings
```

The implementation relies on standard Linux utilities, including:

- `awk`
- `cut`
- `grep`
- `sort`
- `uniq`

These utilities allow the toolkit to inspect user account information without modifying the system.

---

# Security Best Practices

- Maintain only one UID 0 account whenever possible.
- Remove or disable unused user accounts.
- Disable interactive logins for service accounts.
- Enforce strong password policies.
- Review user accounts regularly.
- Avoid shared user accounts.
- Periodically audit `/etc/passwd` and `/etc/shadow`.

---

# References

- `man passwd`
- `man shadow`
- `man useradd`
- `man usermod`
- `man userdel`
- Linux Filesystem Hierarchy Standard (FHS)
- CIS Benchmarks for Linux
- Red Hat Enterprise Linux Security Guide
- Ubuntu Server Guide
