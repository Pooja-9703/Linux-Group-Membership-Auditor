# Group Audit

## Overview

The **Group Audit** module examines Linux groups and their memberships to identify potential security issues related to group configuration and privilege management. It reviews system groups, verifies group memberships, and detects potentially dangerous configurations such as duplicate Group IDs (GIDs) and multiple groups with GID 0.

Groups are a fundamental part of Linux's permission model. Proper group management simplifies permission administration, supports the principle of least privilege, and reduces the need to grant excessive permissions directly to individual users.

---

## Learning Objectives

After reading this document, you should understand:

- What Linux groups are and why they exist.
- The difference between primary and supplementary groups.
- What a Group ID (GID) is.
- The purpose of the `/etc/group` file.
- Why duplicate GIDs and multiple GID 0 groups can create security risks.
- How the Linux Security Audit Toolkit performs group-related security checks.

---

# Linux Groups

A Linux group is a collection of user accounts that share common permissions.

Instead of assigning permissions to every individual user, permissions can be granted to an entire group.

For example:

```text
Developers Group

├── Alice
├── Bob
└── Charlie
```

If a directory belongs to the **developers** group, every member of that group can access it according to the assigned group permissions.

This approach simplifies permission management, especially on systems with many users.

---

# Understanding Group IDs (GIDs)

Every Linux group is assigned a unique numerical identifier called the **Group ID (GID)**.

Example:

```text
Group Name : developers
GID        : 1001
```

Although administrators work with group names, Linux internally uses the GID when evaluating group ownership and permissions.

---

# Primary vs Supplementary Groups

Every user has one **primary group** and may belong to multiple **supplementary groups**.

Example:

```text
User: alice

Primary Group:
    developers

Supplementary Groups:
    docker
    sudo
    audio
```

### Primary Group

The primary group is assigned when a user account is created and is typically used as the default group ownership for new files created by that user.

### Supplementary Groups

Supplementary groups provide additional permissions without changing the user's primary group.

For example:

```text
Alice

↓

Member of docker group

↓

Can manage Docker without being root
```

---

# The /etc/group File

Linux stores group information in the `/etc/group` file.

Example:

```text
developers:x:1001:alice,bob,charlie
```

Field breakdown:

| Field | Description |
|------|-------------|
| Group Name | Name of the group |
| Password Placeholder | Usually `x` |
| GID | Group Identifier |
| Members | Comma-separated list of users |

Unlike `/etc/passwd`, the `/etc/group` file stores information about group memberships rather than user accounts.

---

# Why Groups Matter

Groups make permission management scalable.

Instead of assigning permissions to every user individually:

```text
File

↓

Owner
Group
Others
```

Linux evaluates:

1. Is the user the owner?
2. Is the user a member of the file's group?
3. Otherwise, use "Others" permissions.

This permission hierarchy is one of the core concepts of Linux access control.

---

# Security Checks Performed

The Group Audit module performs the following checks.

---

## 1. List All System Groups

The toolkit lists every configured group.

Purpose:

- Review existing groups.
- Identify unnecessary or obsolete groups.
- Verify expected group configurations.

---

## 2. Display Group Memberships

The toolkit displays users belonging to each group.

Purpose:

- Verify privileged group memberships.
- Detect unauthorized users in sensitive groups.
- Review access assignments.

Administrators should periodically review memberships of groups such as:

- sudo
- wheel
- docker
- adm
- lpadmin

These groups often grant elevated privileges or access to sensitive system resources.

---

## 3. Duplicate GIDs

The toolkit searches for groups that share the same Group ID.

Example:

```text
developers
GID = 1001

engineering
GID = 1001
```

Because Linux uses the GID internally, duplicate GIDs can cause permission ambiguity and make access control difficult to manage.

Although duplicate GIDs are uncommon, they may result from configuration mistakes or improper account migrations.

---

## 4. Multiple GID 0 Groups

Normally:

```text
root
GID = 0
```

Dangerous example:

```text
root
GID = 0

admins
GID = 0

operators
GID = 0
```

Creating additional groups with GID 0 can unintentionally grant users privileged group ownership and complicate permission auditing.

Unless specifically required, only the **root** group should have GID 0.

---

# How the Toolkit Implements These Checks

The Group Audit module gathers information from the Linux group database and performs several validation steps.

High-level workflow:

```text
Read group database

↓

Extract group names

↓

Extract GIDs

↓

Display memberships

↓

Identify duplicate GIDs

↓

Check for multiple GID 0 groups

↓

Generate findings
```

The implementation relies on standard Linux utilities such as:

- `getent`
- `cut`
- `awk`
- `sort`
- `uniq`
- `grep`

These utilities allow the toolkit to inspect group information without modifying any system configuration.

---

# Security Best Practices

- Follow the principle of least privilege.
- Regularly review group memberships.
- Remove unused groups.
- Avoid duplicate GIDs.
- Ensure only the root group uses GID 0.
- Restrict membership in privileged groups such as `sudo` and `wheel`.
- Periodically audit group configurations on production systems.

---

# References

- `man group`
- `man groupadd`
- `man groupmod`
- `man gpasswd`
- `man getent`
- Linux Filesystem Hierarchy Standard (FHS)
- CIS Linux Benchmark
- Red Hat Enterprise Linux Security Guide
- Ubuntu Server Guide
