# Group Audit

## Overview

The **Group Audit** module examines Linux groups and their memberships to identify security misconfigurations that may affect access control and privilege management. It reviews configured groups, verifies user memberships, detects duplicate Group IDs (GIDs), and identifies multiple groups with GID 0.

Linux groups simplify permission management by allowing administrators to assign permissions to a collection of users instead of configuring permissions individually. Proper group management supports the **Principle of Least Privilege (PoLP)** and reduces the risk of excessive permissions.

---

## Learning Objectives

After reading this document, you should be able to:

- Explain the purpose of Linux groups.
- Understand how Group IDs (GIDs) are used.
- Differentiate between primary and supplementary groups.
- Describe the purpose of the `/etc/group` file.
- Explain why duplicate GIDs and multiple GID 0 groups are security concerns.
- Understand how the Linux Security Audit Toolkit performs group-related security checks.

---

# Understanding Linux Groups

A Linux group is a collection of users that share common permissions.

Instead of granting permissions to each user individually, administrators assign permissions to a group.

Example:

```text
developers

├── Alice
├── Bob
└── Charlie
```

If a directory belongs to the **developers** group, every member of that group receives the permissions assigned to the group.

This simplifies permission management and improves scalability on multi-user systems.

---

# Why Groups Matter

Without groups, every file permission would need to be configured for individual users.

Example:

```text
Project Directory

↓

Owner      : Alice
Group      : developers
Permissions: rwxrwx---
```

Every member of the **developers** group can collaborate without assigning permissions individually.

Groups also help implement the **Principle of Least Privilege**, ensuring users receive only the access required for their responsibilities.

---

# Understanding Group IDs (GIDs)

Every Linux group is assigned a numerical identifier called the **Group ID (GID)**.

Example:

```text
Group Name : developers
GID        : 1001
```

Although administrators work with group names, Linux internally uses the GID when determining group ownership and permissions.

Just as Linux identifies users by UID, it identifies groups by GID.

---

# Primary vs Supplementary Groups

Every Linux user belongs to:

- One **Primary Group**
- Zero or more **Supplementary Groups**

Example:

```text
User : alice

Primary Group
    developers

Supplementary Groups
    docker
    sudo
    audio
```

### Primary Group

The primary group is assigned when the user account is created and becomes the default group ownership for newly created files.

### Supplementary Groups

Supplementary groups grant additional permissions without changing the user's primary group.

For example:

```text
Alice

↓

Member of docker group

↓

Allowed to manage Docker containers
```

---

# The `/etc/group` File

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

Unlike `/etc/passwd`, this file stores information about groups rather than user accounts.

---

# Security Checks Performed

The Group Audit module performs the following checks.

---

## 1. List All System Groups

The toolkit enumerates every configured group.

**Purpose**

- Review configured groups.
- Identify unnecessary or obsolete groups.
- Verify expected system configuration.

---

## 2. Display Group Memberships

The toolkit displays users belonging to each group.

**Purpose**

- Verify privileged group memberships.
- Review access assignments.
- Detect unauthorized users in sensitive groups.

Common privileged groups include:

- sudo
- wheel
- docker
- adm
- lpadmin

Membership in these groups should be reviewed periodically.

---

## 3. Duplicate GIDs

The toolkit searches for groups sharing the same Group ID.

Example:

```text
developers
GID = 1001

engineering
GID = 1001
```

Because Linux uses the GID internally, duplicate GIDs can lead to permission ambiguity and make access control difficult to manage.

Although uncommon, duplicate GIDs may occur due to manual configuration errors or account migrations.

---

## 4. Multiple GID 0 Groups

Normally, only the **root** group should have GID 0.

Example:

```text
root
GID = 0
```

Potentially insecure configuration:

```text
root
GID = 0

admins
GID = 0

operators
GID = 0
```

Additional groups with GID 0 increase the risk of unintended privileged access and complicate permission auditing.

---

# Common Attack Scenarios

## Excessive Group Membership

A user is accidentally added to the **sudo** group.

Although the account was intended to be a standard user, it now has administrative privileges.

Regular group audits help identify excessive permissions before they are abused.

---

## Duplicate GID Misconfiguration

Two different groups are assigned the same GID.

Because Linux uses the GID internally, users in one group may receive unintended access to files owned by the other group.

---

## Forgotten Administrative Groups

Temporary administrative groups created during maintenance are never removed.

Over time, these groups accumulate unnecessary members, increasing the attack surface.

Periodic group reviews help prevent privilege creep.

---

# Manual Verification

The following commands can be used to manually verify the same information inspected by the toolkit.

### List all groups

```bash
cut -d: -f1 /etc/group
```

---

### Display group memberships

```bash
getent group
```

---

### Find duplicate GIDs

```bash
cut -d: -f3 /etc/group | sort | uniq -d
```

---

### Find groups with GID 0

```bash
awk -F: '$3 == 0 {print $1}' /etc/group
```

---

# Commands Used in This Audit

| Command | Purpose |
|---------|---------|
| `getent` | Retrieve group information from the system database. |
| `cut` | Extract GID values from `/etc/group`. |
| `awk` | Process and format group information. |
| `sort` | Sort GIDs before duplicate detection. |
| `uniq` | Identify duplicate GIDs. |
| `grep` | Search for specific group names or patterns. |

---

# How the Toolkit Implements These Checks

High-level workflow:

```text
Read /etc/group

        │

        ▼

Extract Group Names

        │

        ▼

Display Memberships

        │

        ▼

Check Duplicate GIDs

        │

        ▼

Check GID 0 Groups

        │

        ▼

Generate Findings
```

The toolkit performs read-only inspections using standard Linux utilities and does not modify any system configuration.

---

# Expected Findings

A properly configured Linux system should typically have:

- One group with GID 0 (`root`)
- No duplicate GIDs
- Appropriate membership in privileged groups
- No obsolete or unused administrative groups

---

# Severity Levels

| Severity | Meaning |
|----------|---------|
| **INFO** | Informational result requiring no action. |
| **LOW** | Minor configuration issue. |
| **MEDIUM** | Configuration should be reviewed. |
| **HIGH** | Configuration presents a significant security risk. |

---

# Security Best Practices

- Follow the Principle of Least Privilege.
- Periodically review group memberships.
- Remove unused groups.
- Avoid duplicate GIDs.
- Restrict membership in privileged groups such as `sudo`, `wheel`, and `docker`.
- Ensure only the `root` group uses GID 0.
- Perform regular security audits to identify permission drift.

---

# Related Documentation

- User Audit
- Privilege Audit
- Filesystem Security Audit

---

# References

- `man group`
- `man groupadd`
- `man groupmod`
- `man gpasswd`
- `man getent`
- CIS Benchmarks for Linux
- NIST SP 800-53 AC-2 (Account Management)
- Red Hat Enterprise Linux Security Guide
- Ubuntu Server Guide
